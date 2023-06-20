### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = "2"
#> Authors = "Ludovic Räss, Ivan Utkin"
#> section = "2.3"
#> order = "2.3"
#> title = "Channel Flow 2D"
#> tags = ["bcn"]
#> layout = "layout.jlhtml"

using Markdown
using InteractiveUtils

# ╔═╡ ad8c3d40-0f67-11ee-3e3c-c330512f54c1
md"## Channel Flow 2D 

The final step is to now turn the diffusion script into a channel flow script with non-linear viscosity and a free-surface.

![channel flow](/assets/bcn/model_setup.png#badge)

We consider the shear-driven Stokes flow with power-law rheology in a quasi-2D setup:

 $\frac{\partial \tau_{xy}}{\partial y} + \frac{\partial\tau_{xz}}{\partial z} + \rho g\sin\alpha = 0$

 $\tau_{ij} = 2\eta \varepsilon_{ij}, \quad \varepsilon_{ij} = \frac{1}{2}\left(\frac{\partial v_i}{\partial x_j} + \frac{\partial v_j}{\partial x_i} \right)$

 $\eta = k \varepsilon_\mathrm{II}^{n-1}$

Modify the diffusion script to turn it into a free-surface channel flow. To this end, following changes are necessary:
- the flux become the viscous stresses τ_{ij}
- the quantity C becomes the out-of-plane velocity v_x
- \rho g\sin\alpha needs to be added as source term to the flux balance equation
- the diffusion coefficient D turns now into the nonlinear viscosity η
- the force-balance equation can be used to retrieve v_x iteratively.

For the iterative process can be designed as augmenting the force balance equation with a pseudo-time step \partial τ one can then use to reach a steady state:

 $\frac{\partial \tau_{xy}}{\partial y} + \frac{\partial\tau_{xz}}{\partial z} + \rho g\sin\alpha = \frac{\partial v_x}{\partial τ}$ ~.

We now have a rule to update v_x as function of the residual of the balance equation $\mathrm{R}v_x$:

 $\mathrm{R}v_x = \frac{\partial \tau_{xy}}{\partial y} + \frac{\partial\tau_{xz}}{\partial z} + \rho g\sin\alpha~,$

 $\frac{\partial v_x}{\partial τ} = \mathrm{R}v_x~,$

such that:

 $\partial v_x = \partial v_x + \partial τ * \mathrm{R}v_x~.$

This simple iterations results in a Picrad-like scheme; simple but not ideal in terms of number of iterations to converge to a given tolerance.

> 👀 This simple 'pseudo-transient' scheme can be accelerated by using a second order scheme. This is on-going research. Check out [this lecture](https://pde-on-gpu.vaw.ethz.ch/lecture3/#solving_elliptic_pdes) and [related publication (Räss et al., 2022)](https://gmd.copernicus.org/articles/15/5757/2022/) if curious about it.

To proceed, start from the `diffusion_2D_fun.jl` script from [this previous step](#solving-transient-2d-diffusion-on-the-cpu-i) and make sure the new physics is correctly implemented. In a second step, we will then port it to GPU kernel programming.

Start a new script titled `channel_flow_2D.jl` or start from the provided [scripts_s2/channel_flow_2D.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/channel_flow_2D.jl) script. There, we introduce some new physics parameters:
```julia
# physics
# non-dimensional
npow    = 1.0 / 3.0
sinα    = sin(π / 12)
# dimensionally independent
ly, lz  = 1.0, 1.0 # [m]
k0      = 1.0      # [Pa*s^npow]
ρg      = 1.0      # [Pa/m]
# scales
psc     = ρg * lz
ηsc     = psc * (k0 / psc)^(1.0 / npow)
# dimensionally dependent
ηreg    = 1e4 * ηsc
```
namely, power-law exponent `npow`, slope angle `sinα`, consistency factor `k0`, gravity acceleration `ρg` and some scaling relations.

Then we need some additional numerics parameters:
```julia
# numerics
ϵtol    = 1e-6
ηrel    = 5e-1
maxiter = 20000max(ny, nz)
ncheck  = 500max(ny, nz)
```
namely, the nonlinear tolerance `ϵtol`, some relaxation for the viscosity continuation `ηrel`, and a modification of the iteration parameter definition.

In the `# init` section, rename `C` as `vx`, `D` as `ηeff`, `qy` as `τxy` and `qz` as `τxz`. Also, no longer need to initialise `C` now `vx` with a Gaussian; simply use zeros.

From the equations, we see that the nonlinear viscosity \eta is function of the second strain-rate invariant ɛ_\mathrm{II} at a given power. You can implement `eII` as a macro in the code:
```julia
macro eII() esc(:(sqrt.((avz(diff(vx, dims=1) ./ dy)) .^ 2 .+ (avy(diff(vx, dims=2) ./ dz)) .^ 2))) end
```

Also, we now have to include the `err >= ϵtol` condition in our `while` loop, such that:
```julia
while err >= ϵtol && iter <= maxiter
    # iteration loop
end
```

For the boundary condition, enforce no-slip condition at the bottom and open-box at the top. This can be achieved as following:
```julia
vx[:, end] .= vx[:, end-1]
vx[1, :]   .= vx[2, :]
```
Make finally sure to update the error checking and plotting as well:
```julia
if iter % ncheck == 0
    err = maximum(abs.(diff(τxy, dims=1) ./ dy .+ diff(τxz, dims=2) ./ dz .+ ρg * sinα)) * lz / psc
    push!(iters_evo, iter / nz); push!(errs_evo, err)
    p1 = heatmap(yc, zc, vx'; aspect_ratio=1, xlabel='y', ylabel='z', title='Vx', xlims=(-ly / 2, ly / 2), ylims=(0, lz), c=:turbo, right_margin=10mm)
    p2 = heatmap(yv, zv, ηeff'; aspect_ratio=1, xlabel='y', ylabel='z', title='ηeff', xlims=(-ly / 2, ly / 2), ylims=(0, lz), c=:turbo, colorbar_scale=:log10)
    p3 = plot(iters_evo, errs_evo; xlabel='niter/nx', ylabel='err', yscale=:log10, framestyle=:box, legend=false, markershape=:circle)
    display(plot(p1, p2, p3; size=(1200, 400), layout=(1, 3), bottom_margin=10mm, left_margin=10mm))
    @printf('  #iter/nz=%.1f, err=%1.3e\n', iter / nz, err)
end
```
Running the code should produce a figure similar to:

![channel flow](/assets/bcn/channel_flow.png)
> 💡 If you run out of ideas, check-out the [scripts_s2/channel_flow_2D.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/channel_flow_2D.jl) script and try replacing the `??` by some more valid content.
> 
> The solution script can be found at [scripts_solutions/channel_flow_2D_sol.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_solutions/channel_flow_2D_sol.jl)

In a second step, create now a GPU code titled `channel_flow_2D_cuda.jl` out of the channel flow script using kernel programming. Apply the same workflow as done for the diffusion codes.

On the GPU, we now need 4 kernels to avoid sync issues and ensure correct execution:
```julia
update_ηeff!()
update_τ!()
update_v!()
apply_bc!()
```

> 💡 If you run out of ideas, check-out the [scripts_s2/channel_flow_2D_cuda.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/channel_flow_2D_cuda.jl) script and try replacing the `??` by some more valid content. 
> 
> The solution script can be found at [scripts_solutions/channel_flow_2D_cuda_sol.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_solutions/diffusion_2D_cuda_sol.jl)

"

# ╔═╡ Cell order:
# ╟─ad8c3d40-0f67-11ee-3e3c-c330512f54c1
