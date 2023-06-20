### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = "2"
#> Authors = "Ludovic Räss, Ivan Utkin"
#> section = "1"
#> order = "1"
#> title = "Getting started"
#> tags = ["bcn"]
#> layout = "layout.jlhtml"

using Markdown
using InteractiveUtils

# ╔═╡ f7ffde32-0f66-11ee-3804-a501e21026b1
md"## Getting started
This section provides directions on getting your GPU HPC dev environment ready on the `octopus` supercomputer at the University of Lausanne, Switzerland. During this Master-class, we will use SSH to login to a remote multi-GPU compute node on `octopus`. Each of the participant should get access to 4 Nvidia Titan Xm 12GB. 


### Useful resources
- The Julia language: [https://julialang.org](https://julialang.org)
- PDE on GPUs ETH Zurich course: [https://pde-on-gpu.vaw.ethz.ch](https://pde-on-gpu.vaw.ethz.ch)
- Julia Discourse (Julia Q&A): [https://discourse.julialang.org](https://discourse.julialang.org)
- Julia Slack (Julia dev chat): [https://julialang.org/slack/](https://julialang.org/slack/)

### Julia and HPC
Some words on the Julia at scale effort, the Julia HPC packages, and the overall Julia for HPC motivation (two language barrier)

#### The (yet invisible) cool stuff
Today, we will develop code that:
- Runs on graphics cards using the Julia language
- Uses a fully local and iterative approach (scalability)
- Retrieves automatically the Jacobian Vector Product (JVP) using automatic differentiation (AD)
- (All scripts feature less than 400 lines of code)

Too good to be true? Hold on 🙂 ...

#### Why to still bother with GPU computing in 2023
- It's around for more than a decade
- It shows massive performance gain compared to serial CPU computing
- First exascale supercomputer, Frontier, is full of GPUs
![Frontier](/assets/bcn/frontier.png#badge)

#### Performance that matters
![cpu_gpu_evo](/assets/bcn/cpu_gpu_evo.png#badge)

Taking a look at a recent GPU and CPU:
- Nvidia Tesla A100 GPU
- Nvidia Titan Xm GPU
- AMD EPYC 'Rome' 7282 (16 cores) CPU

| Device         | TFLOP/s (FP64) | Memory BW TB/s | Imbalance (FP64)     |
| :------------: | :------------: | :------------: | :------------------: |
| Tesla A100     | 9.7            | 1.55           | 9.7 / 1.55  × 8 = 50 |
| AMD EPYC 7282  | 0.7            | 0.085          | 0.7 / 0.085 × 8 = 66 |

**Meaning:** we can do about 50 floating point operations per number accessed from main memory.
Floating point operations are 'for free' when we work in memory-bounded regimes.

👉 Requires to re-think the numerical implementation and solution strategies

Unfortunately, the cost of evaluating a first derivative ∂A / ∂x using finite-differences:
```julia
q[ix] = -D * (A[ix+1] - A[ix]) / dx
```
consists of:
- 1 reads + 1 write => 2 × 8 = **16 Bytes transferred**
- 1 (fused) addition and division => **1 floating point operations**

👉 assuming D, ∂x are scalars, q and A are arrays of `Float64` (read from main memory)

#### Performance that matters - an example
Not yet convinced? Let's have a look at an example.

Let's assess how close from memory copy (1355 GB/s) we can get solving a 2D diffusion problem on an Nvidia Tesla A100 GPU.

 ∇⋅(D ∇ C) = $\frac{∂C}{∂t}$ 

 _Note: You need a GPU for this to run it in this Notebook. If you don't have one, you can still follow the code and run it on VS Code/Cluster._
👉 Let's test the performance using a simple [scripts_s1/perftest.jl](https://github.com/PTsolvers/Galileo23-MC1-GPU/blob/main/scripts_s1/perftest.jl) script.

#### Why to still bother with GPU computing in 2022
Because it is still challenging

Why?
- Very few software uses it efficiently
- It requires to rethink the solving strategy as non-local operations will kill the fun
"

# ╔═╡ Cell order:
# ╠═f7ffde32-0f66-11ee-3804-a501e21026b1
