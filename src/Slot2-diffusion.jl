### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = "2"
#> Authors = "Ludovic Räss, Ivan Utkin"
#> section = "2.1"
#> order = "2.1"
#> title = "Diffusion on the GPU"
#> tags = ["bcn"]
#> layout = "layout.jlhtml"

using Markdown
using InteractiveUtils

# ╔═╡ ad8c3d40-0f67-11ee-3e3c-c330512f54c1
md"## Diffusion on the GPU
**Hands-on I**

Now it's time to get started. In the coming 2 hours, we will program a 2D transientdiffusion equation in a vectorised fashion in Julia. Then, we will turn it into a multi-threaded loop version, and finally into a GPU code. The last part will consist of modifying the diffusion code to solve the channel flow in 2D with free-surface and variable viscosity.

### Solving transient 2D diffusion on the CPU I
Starting from the [scripts_start/visu_2D.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_start/visu_2D.jl) script, create a new script `diffusion_2D.jl` where we will add diffusion physics:

 $\frac{∂C}{∂t}$ = -∇⋅q~, 

 q = -D~∇C ~, 

where D is the diffusion coefficient.

Let's use a simple explicit forward Euler time-stepping scheme and keep the same Gaussian distribution as initial condition.

The diffusion coefficient D = d_0 should be defined in all gird points such that it could be spatially variable in a later stage:
```julia
D = d0 .* ones(...)
```
> 💡 If you struggle getting started, check-out the [scripts_s2/diffusion_2D.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/diffusion_2D.jl) script and try replacing the `??` by some more valid content.
>
> The solution script can be found at [scripts_solutions/diffusion_2D_sol.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_solutions/diffusion_2D_sol.jl)

### Solving  transient 2D diffusion on the CPU II
We will perform one additional step in order to make our code closer to be ready for kernel programming on GPUs.

We will here isolate the lines that perform the actual computations, i.e., solve the PDE, and move those operations into functions. To avoid race conditions and keep correct synchronisation, we need to define 2 different compute functions, one for assigning the fluxes (`update_q!`) and one for updating the values of C (`update_C!`).

> 💡 Note the exclamation mark `!` in the function name. This is a Julia convention if the function modifies the arguments passed to it.

Create a new script, `diffusion_2D_fun.jl`, where you will use the following template for the compute functions:
```julia
function update_q!()
    Threads.@threads for iz = 1:size(C, 2)
        for iy = 1:size(C, 1)
            if (iy <= ?? && iz <= ??) qy[iy, iz] = ?? end
            if (iy <= ?? && iz <= ??) qz[iy, iz] = ?? end
        end
    end
    return
end
```

The `Threads.@threads` in front of the outer loop allows for shared memory parallelisation on the CPU (aka [multi-threading](https://docs.julialang.org/en/v1/manual/multi-threading/)) if Julia is launched with more than one thread.

Perform the similar tasks for `update_C!` function.

Also, replace the averaging helper functions my macros, and use macros as well to define helper functions for performing the derivative operations.

> 💡 If you run out of ideas, check-out the [scripts_s2/diffusion_2D_fun.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/diffusion_2D_fun.jl) script and try replacing the `??` by some more valid content.
>
> The solution script can be found at [scripts_solutions/diffusion_2D_fun_sol.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_solutions/diffusion_2D_fun_sol.jl)

### Solving transient 2D diffusion on GPU
Let's now move to GPU computing. Starting from the [diffusion_2D_fun.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/diffusion_2D_fun.jl) script you just finalised, we'll make it ready for GPU execution.

In a new script `diffusion_2D_cuda.jl`, we first need to modify the compute functions (or kernels hereafter) to replace the spatial loops by 2D vectorised indices that will parallelise the execution over many GPU threads:
```julia
function update_q!()
    iy = (blockIdx().x - 1) * blockDim().x + threadIdx().x
    iz = (blockIdx().y - 1) * blockDim().y + threadIdx().y
    ??
    return
end
```
Then, in the `# numerics` section, we need to define some kernel launch parameters to specify the number of parallel workers to launch on the GPU:
```julia
nthreads = (16, 16)
nblocks  = cld.((ny, nz), nthreads)
```
You'll find more details about GPU kernel programming in the [CUDA.jl](https://github.com/JuliaGPU/CUDA.jl) documentation or on [this course website](https://pde-on-gpu.vaw.ethz.ch).

In the `# init` section, we will have now to specify that the arrays should be 'uploaded' to the GPU. The `C` init can be wrapped by `CuArray()`. The fluxes and `D` array can be initialised on the GPU by adding `CUDA.` before `ones` or `zeros`. Also, one needs to specify the arithmetic precision as we want to perform double precision `Float64` computations, e.g., `CUDA.zeros(Float64, nx, ny)`.

The kernel launch configuration and synchronisation need to be passed to the kernel launch call as following: 
```julia
CUDA.@sync @cuda threads=nthreads blocks=nblocks update_q!()
```

Finally, one needs to gather back on the host the `C` array for plotting, resulting in calling `Array(C)`.

> 💡 If you run out of ideas, check-out the [scripts_s2/diffusion_2D_cuda.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s2/diffusion_2D_cuda.jl) script and try replacing the `??` by some more valid content.
>
> The solution script can be found at [scripts_solutions/diffusion_2D_cuda_sol.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_solutions/diffusion_2D_cuda_sol.jl)
"

# ╔═╡ Cell order:
# ╟─ad8c3d40-0f67-11ee-3e3c-c330512f54c1
