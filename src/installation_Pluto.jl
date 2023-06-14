### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> order = "2"
#> title = "1. Introduction and Installation"
#> tags = ["welcome"]
#> license = "MIT"
#> description = "This is the first step towards programming in Julia"
#> layout = "md.jlmd"

using Markdown
using InteractiveUtils

# ╔═╡ 60485fb8-c536-4473-b6ea-ca66dadf4c33
md"# Introduction to Julia by AG Geophysik at the University of Mainz"

# ╔═╡ f2c32ef4-4178-44d4-9a20-f91c904c476f
md"**DISCLAIMER**: This webpage is a work in progress and if you got recommendations, feel free to [email us](mailto:paellig@uni-mainz.de)\
Furthermore, this Introduction was inspired by the MIT Computational Thinking class and Marcel Thielmanns's course on the Geophysical Model Generator @Uni Bayreuth"

# ╔═╡ 33d824f1-e8ed-4a3c-8abf-fd77d8288e33
md"## 1. Introduction"

# ╔═╡ fa85cebf-206c-4423-9d0e-55ea4a7912da
md"The Julia scientific programming language is fast, completely open source and comes with a nice package manager. It works on essentially all systems and has an extremely active user base. Programming in Julia is fairly easy and comparable to programming in MATLAB. If you have experience in MATLAB programming, transitioning to Julia should be relatively smooth." 

# ╔═╡ bc1d6928-1ed4-4c03-b2ca-a5c1578b141a
md"In this course you will learn how to use Julia from simple coding exercises to get familiar with the structure of Julia to interactive geodynamical programming using LaMeM and other packages developed by the AG Geophysik at the University of Mainz"

# ╔═╡ f13f5733-001e-450a-b879-8b291d95b7ca
md"### 1.1 Installation of Julia"

# ╔═╡ 2aee427c-b8c4-429d-b68d-3dcda38cba35
md"#### Step 1: Download Julia 

Go to [https://julialang.org/downloads](https://julialang.org/downloads) and download the current stable release, using the correct version for your operating system (Linux x86, Mac, Windows, etc).

Additionally, we rely on [Microsoft Visual Studio Code](https://code.visualstudio.com) as a debugger and visualisation tool. After downloading both Julia and VS Code, make sure to also install the Julia Language extension within VS Code. See [here](https://code.visualstudio.com/docs/languages/julia) for help when setting it up. 

#### Step 2: Run Julia

After installing, **make sure that you can run Julia**. On some systems, this means searching for the program installed on your computer; in others, it means running the command `julia` in a terminal. Make sure that you can execute `1 + 1`


#### Step 3: Install [Pluto](https://github.com/fonsp/Pluto.jl)

Next we will install the [**Pluto**](https://github.com/fonsp/Pluto.jl), the notebook environment that we will be using during the course. Pluto is a Julia _programming environment_ designed for interactivity and quick experiments.

Open the **Julia REPL**. This is the command-line interface to Julia, similar to the previous screenshot.

Here you type _Julia commands_, and when you press ENTER, it runs, and you see the result.

To install Pluto, we want to run a _package manager command_. To switch from _Julia_ mode to _Pkg_ mode, type `]` (closing square bracket) at the `julia>` prompt. 

```julia
julia> ]
(@v1.9) pkg> add Pluto
```

This might take a couple minutes to download all the dependencies. If you do not want to continue to work on the notebook, you can close the Terminal now.

#### Step 4: Run Pluto on a modern Browser
Viewing Pluto notebooks require a modern browser. The notebooks work best on Mozilla Firefox or Google Chrome, however Safari is also operational.

#### Step 5: Starting Pluto and running the interactive notebooks
Before we are able to run the notebooks, we need to open the Julia REPL (if you closed it after step 3) and **load Pluto** and type **PLuto.run()**.

```julia
julia> using Pluto

julia> Pluto.run()
```
The terminal will tell you the URL (e.g. **http://localhost:1234/**) and open a browser window on its own. 
"

# ╔═╡ Cell order:
# ╟─60485fb8-c536-4473-b6ea-ca66dadf4c33
# ╟─f2c32ef4-4178-44d4-9a20-f91c904c476f
# ╠═33d824f1-e8ed-4a3c-8abf-fd77d8288e33
# ╟─fa85cebf-206c-4423-9d0e-55ea4a7912da
# ╟─bc1d6928-1ed4-4c03-b2ca-a5c1578b141a
# ╟─f13f5733-001e-450a-b879-8b291d95b7ca
# ╟─2aee427c-b8c4-429d-b68d-3dcda38cba35
