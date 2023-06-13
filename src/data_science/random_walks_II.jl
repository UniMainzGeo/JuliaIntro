### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = 2
#> video = "https://www.youtube.com/watch?v=pIAFHyLmwbM"
#> image = "https://user-images.githubusercontent.com/6933510/191981723-657fd4b8-c23d-4fb9-a3f2-496b4574fac1.png"
#> section = 6
#> order = 6
#> title = "Random Walks II"
#> layout = "layout.jlhtml"
#> youtube_id = "pIAFHyLmwbM"
#> description = ""
#> tags = ["lecture", "module2", "track_julia", "track_data", "statistics", "plotting", "random", "structure", "type", "programming", "interactive"]

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 85b45a43-d7bf-4597-a1a6-329b41dce20d
using PlutoUI, Plots, LinearAlgebra, SparseArrays

# ╔═╡ 85c26eb4-c258-4a8b-9415-7b5f7ddff02a
TableOfContents(aside=true)

# ╔═╡ 2d48bfc6-9617-11eb-3a85-279bebd21332
md"""
# Julia concepts

- Customised display of objects
- Structured matrices in Julia
- `cumsum`
- Vectors of vectors
- Concatenation of vectors: `hcat`


- `heatmap` (Plots.jl)
- `surface` (Plots.jl)

"""

# ╔═╡ 30162386-039f-4cd7-9121-a3382be3c294
md"""
# Pascal's triangle

"""

# ╔═╡ 4e7b163e-dfd0-457e-b1f3-8807a4d8060a
md"""
Let's start by thinking about Pascal's triangle. (Note that [Pascal was not the first person to study these numbers](https://en.wikipedia.org/wiki/Pascal%27s_triangle).)
"""

# ╔═╡ e8ceab7b-45db-4393-bb8e-e000ecf78d2c
pascal(N) = [binomial(n, k) for n = 0:N, k=0:N]

# ╔═╡ 2d4dffb9-39e4-48de-9688-980b96814c9f
pascal(10)

# ╔═╡ 8ff66523-bc2e-4c53-975b-8ba4f99eb1c6
md"""
The non-zero entries are the **binomial coefficients**: the $k$th entry on the $n$th row is the coefficient of $x^k$ in the expansion $(1 + x)^n$, starting from $n=0$ in the first row and $k=0$ in the first column.
"""

# ╔═╡ 2868dd57-7164-4162-8c5d-30628dedeb7a
md"""
Note that there are 0s above the main diagonal -- in other words the matrix is **lower triangular**.

Julia has special types to represent some classes of structured matrices in the standard library `LinearAlgebra` package:
"""

# ╔═╡ f6009473-d3c1-444f-88ae-814f770e811b
L = LowerTriangular(pascal(10))

# ╔═╡ 9a368602-acd3-43fb-9dff-e407a4bab930
md"""
We see that the display is special: the known "**structural**" zeros are shown as dots, instead of numbers.
"""

# ╔═╡ 67517333-175f-48c4-a915-76658cbf1304
md"""
As we have already seen, Julia also has a sparse matrix type that we could use for this, in the `SparseArrays` standard library:
"""

# ╔═╡ d6832372-d336-4a54-bbcf-d0bb70e4de64
sparse(pascal(10))  

# ╔═╡ 35f14826-f1e4-4977-a31a-0f6148fe25ad
md"""
For fun, let's look at where the entries of Pascal's triangle are odd. We'll make a slider:
"""

# ╔═╡ 7468fc5d-7f35-45e2-b5fc-7e63b562bc8f
@bind n_pascal Slider(1:63, show_value=true, default=1)

# ╔═╡ 1ca8aa3b-b05d-40f6-a925-2f0248b79ca2
sparse(isodd.(pascal(n_pascal)))

# ╔═╡ 38d88b7c-3b4f-430b-8d3c-f672ab0c7a49
md"""
Note that the visual representation of a sparse matrix changes at a particular value of $n$. For larger values of $n$ the **sparsity pattern** is displayed using dots for non-zero values.
"""

# ╔═╡ f4c9b02b-738b-4de1-9e9d-05b1616bee0b
md"""
The pattern is quite striking!
"""

# ╔═╡ d1c47afa-ab7f-4543-a161-e3ceb6f11eb4
md"""
You may be interested to know that there is an alternative way to look at Pascal's triangle:
"""

# ╔═╡ bf78e00f-05d9-4a05-8512-4924ef9e25f7
[binomial(i + j, i) for i = 0:10, j = 0:10]

# ╔═╡ b948830f-ead1-4f36-a237-c998f2f7deb8
md"""
and that in fact this can be produced from the previous version using matrix multiplication!:
"""

# ╔═╡ 15223c51-8d31-4a50-a8ff-1cb7d35de454
pascal(10) * pascal(10)'

# ╔═╡ 0bd45c4a-3286-427a-a927-15869be2ebfe
md"""
## Convolutions build Pascal's triangle!
"""

# ╔═╡ 999fb608-fb1a-46cb-82ca-f3f31fe617e1
pascal(6)

# ╔═╡ 6509e69a-6e50-4816-a98f-67ba437383fb
md"""
Where do those binomial coefficients come from? That's not how we learnt to build Pascal's triangle at school!

We learned to build each number up by *summing two adjacent numbers from the previous row*. In the lower-triangular representation we we sum the number immediately above with the one to the left of it.
"""

# ╔═╡ e58976a9-1784-441e-bb76-3011538b8ad0
md"""
We can think of this as... a **convolution** with the vector $[1, 1]$ ! 
Recall that convolutions like this are used as **image filters**, where we want to apply the same *local* operation everywhere along a vector (i.e. one in which we modify a vector in a neighbourhood).
"""

# ╔═╡ 1efc2b68-9313-424f-9850-eb4496cc8486
md"""
# Random walks: Independent and identically-distributed random variables
"""

# ╔═╡ 6e93ffda-217b-4d46-86b5-534ddc1bae90
md"""
The discussion of Pascal's triangle and convolutions will surprisingly turn up below. For now let's go back to thinking about **random walks**.

Recall that in a random walk, at each tick of a clock we take a step in space, say left or right.

Each spatial step is random, so we can think of each step as being a **random variable** with a certain probability distribution, for example the random variable that takes the value $+1$ with probability $\frac{1}{2}$ and $-1$ also with probability $\frac{1}{2}$.

Often we will think about random walks in which each step is "the same". What do we mean by "the same"? We don't mean that the *outcome* is the same, but rather that each step has the same *probability distribution*, i.e. the same probability of taking each possible value. In other words, each step is given by *copies of the same random variable*. 

Steps are also *independent* of each other (the choice of step direction right now *does not affect* the choice at the next step). Hence the steps form a collection of **independent and identically-distributed random variables**, or IID random variables.
"""

# ╔═╡ 396d2490-3cb9-4f68-8fdf-9209d2010e02
md"""
## Random walks as a cumulative sum
"""

# ╔═╡ dc1c22e8-1c7b-43b7-8421-c2ca708931a5
md"""
Let's call the random variable that describes the $i$th *step* $X_i$. Then the overall position $S_n$ of the random walk at time $n$ is given by

$$S_n = X_1 + \cdots + X_n = \sum_{i=1}^n X_i.$$

(Here we have taken the initial position $S_0$ equal to 0. If the initial position is not zero, then this instead gives the **displacement** $S_n - S_0$ at time $n$.)


Recall that by the sum of two random variables we mean a new random variable whose outcomes are sums of the outcomes, with probabilities given by taking the possible pairs of outcomes giving each new outcome.
"""

# ╔═╡ e7a52b56-322c-4478-a670-dec1013c9bd8
md"""
## Cumulative sum
"""

# ╔═╡ 5f136388-5573-4814-a088-a66278acdbbe
md"""
We previously looked at sums like this. The difference now is that we are interested in the entire **trajectory**, i.e. the sequence $S_1$, $S_2$, $\ldots$, $S_n$, $\ldots$. The trajectory is given by **partial sums**:
"""

# ╔═╡ e440dc3b-bafd-4e0c-9fe8-13fce8eea22d
md"""
$$\begin{align}
S_1 & = X_1 \\
S_2 &= X_1 + X_2 \\
S_3 &= X_1 + X_2 + X_3
\end{align}$$

etc.
"""

# ╔═╡ 89d3e90d-3685-473d-aea4-0b7c5b80d7f7
md"""
Note that $S_{n+1}$ is *not* independent of $S_n$ (or the other $S_m$). E.g. if $S_{100}$ happens to be large, then $S_{101}$ will be about as large.

Thinking about types, as we did a couple of lectures ago, we would need to define a *new* type to represent a random walk, since we cannot generate consecutive values as independent samples.
"""

# ╔═╡ 203eea14-1c68-4a9f-ab18-9a2e5f408a79
md"""
How could we calculate a trajectory of a walk? Suppose we generate steps $X_i$, e.g.
"""

# ╔═╡ b6d4b045-a39f-4236-ace2-9f631e853d1b
steps = rand( (-1, +1), 10 )

# ╔═╡ e61b56be-d334-4c8f-aa8e-887bb27c058c
md"""
The whole trajectory is given by the **cumulative sum** also called "prefix sum" or "scan". Julia has the function `cumsum` to calculate this:
"""

# ╔═╡ 782f0b9a-3793-4abb-826b-9e14d6eae690
cumsum([1, 2, 3, 4])

# ╔═╡ 1764b56a-f297-4a4e-a931-31aa987ec785
md"""
So the trajectory is given by 
"""

# ╔═╡ 8082092b-b6bf-4619-8776-39fdd6c9b7c1
cumsum(steps)

# ╔═╡ 34c0b850-5e95-4eb9-8435-3aae8d124772
plot(cumsum(steps), m=:o, leg=false, size=(500, 300))

# ╔═╡ 4115f7cb-d45f-4cc2-86bf-316c074393f8
md"""
Note that in Julia this is just a convenience function; it will be no more performant than writing the `for` loop yourself (unlike in some other languages, where `for` loops are slow).
"""

# ╔═╡ 6bc2f20d-3d09-425b-a471-44090dc3161e
md"""
# Evolving probability distributions in time
"""

# ╔═╡ 98994cb9-45dc-48aa-b62d-2407f7184bee
md"""
So far we have looked at single trajectories of random walks. We can think of this as the equivalent of sampling using `rand`. 

Suppose that we run many trajectories of a random walk. At a given time $t$ we can ask where all of the walks are by taking a histogram of the $S_t^{(k)}$, where the superscript $^{(k)}$ denotes the $k$th trajectory out of the collection.

Doing so gives us the *probability distribution* of the random variable $S_t$.
Let's call $p_i^t := \mathbb{P}(S_t = i)$ the probability of being at site $i$ at time $t$. Then the probability distribution at time $t$ is given by the collection of all the $p_i^t$; we can group these into a vector $\mathbf{p}^t$.

Now we can ask what happens at the *next* time step $t+1$. Taking histograms again gives the probabilities $p_j^{t+1}$ and the vector $\mathbf{p}^t$ of all of them.

But $\mathbf{p}^{t+1}$ and $\mathbf{p}^{t}$ are related in some way, since we go from $S_t$ to $S_{t+1}$ by just taking a single step. 

Let's think about the case of a simple random walk in one dimension. To arrive at site $i$ at time $t+1$, we must have been in one of the *neighbouring* sites at time $t$ and jumped with probability $\frac{1}{2}$ in the direction of site $i$. Hence we have

$$p_i^{t+1} = \textstyle \frac{1}{2} (p_{i-1}^{t} + p_{i+1}^{t}).$$

This is sometimes called the **master equation** (even though that is rather a useless, non-descriptive name); it describes how the *probability distribution of the random walk evolves in time*.
"""

# ╔═╡ f11f8d7d-cd3f-4585-aab4-083b892c6d4c
md"""
## Implementing time evolution of probabilities

Let's write a function to **evolve** a probability vector to the next time step for a simple random walk:
"""

# ╔═╡ fb804fe2-58be-46c9-9200-ceb8863d052c
function evolve(p)
	p′ = similar(p)   # make a vector of the same length and type
	                  # to store the probability vector at the next time step
	
	for i in 2:length(p)-1   # iterate over the *bulk* of the system
		
		p′[i] = 0.5 * (p[i-1] + p[i+1])

	end
	
	# boundary conditions:
	p′[1] = 0
	p′[end] = 0
	
	return p′
end

# ╔═╡ 40e457b4-616c-4fab-9c8e-2e5063129597
md"""
Wait... Do you recognise this?

This is just a **convolution** again! The kernel is now $[\frac{1}{2}, 0, \frac{1}{2}]$. Apart from the extra $0$ and the $\frac{1}{2}$, this is the *same* as in Pascal's triangle... so probabilities in simple random walk behave like Pascal's triangle!
"""

# ╔═╡ 979c1fbd-c9f6-4e8b-a648-6a0210fc9e7f
md"""
Note that just as with images we have a problem at the edges of the system: We need to specify **boundary conditions** on the first and last cells. For now we have put 0s at the boundary, corresponding to probability *escaping* at the boundary: any probability that arrives at the boundary at a given time step does not stay in the system. We can think of the probability as analogous to a chemical moving through a system that leaves our system (and e.g. moves into the outside world) when it reaches an edge.
"""

# ╔═╡ 583e3a92-01e7-4b88-9be0-f1e3b3c95005
md"""
We also need to specify an *initial* condition $\mathbf{p}_0$. This tells us where our walker is at time $0$. Suppose that all walkers start at site $i=0$. We will place this in the middle of our vector. Then the *probability* of being at $0$ is 1 (certainty), while the probability at any other site is 0 (impossible):
"""

# ╔═╡ 0b26efab-4e93-4d53-9c4d-faea68d12174
function initial_condition(n)
	
	p₀ = zeros(n)
	p₀[n ÷ 2 + 1] = 1
	
	return p₀
end

# ╔═╡ b9ce5af1-84f7-4a2d-92c9-de2c5498a88d
md"""
Now let's evolve the probability vector in time by applying the `evolve` function repeatedly, starting from the initial probability distribution:
"""

# ╔═╡ b48e55b7-4b56-41aa-9796-674d04adf5df
function time_evolution(p0, N)
	ps = [p0]
	p = p0
	
	for i in 1:N
		p = evolve(p)
		push!(ps, copy(p))
	end
	
	return ps
end

# ╔═╡ 53a36c1a-0b8c-4099-8854-08d73c9f118e
md"""
Let's visualise this:
"""

# ╔═╡ 6b298184-32c6-412d-a900-b113d6bd3d53
begin
	grid_size = 101
	
	p0 = initial_condition(grid_size)
end

# ╔═╡ b84a7255-7b0a-4ba1-8c87-9f5d3fa32ef3
ps = time_evolution(p0, 100)

# ╔═╡ c430c4de-d9bf-44e1-aa40-6b823d718b04
md"""
Note that `ps` is a `Vector`, whose elements are each `Vector`s! I.e. we have a vector of vectors. This is often a convenient way to *build up* a matrix.
"""

# ╔═╡ 99717c6e-f713-49d5-8ee5-a08c4a464223
ps[2]

# ╔═╡ 242ea831-c421-4a76-b658-2a57fa924a4f
md"""
t = $(@bind tt Slider(1:length(ps), show_value=true, default=1))
"""

# ╔═╡ aeaef573-1e90-45f3-a7fe-31ec5e2808c4
bar(ps[tt], ylim=(0, 1), leg=false, size=(500, 300), alpha=0.5)

# ╔═╡ efe186da-3273-4767-aafc-fc8eae01dbd9
md"""
### Concatenating vectors into a matrix
"""

# ╔═╡ 61201091-b8b3-4776-9be9-4c23d5ba88ba
md"""
Now we want to visualise this in a different way, for which we must join up (**concatenate**) all the probability vectors into a matrix:
"""

# ╔═╡ 66c4aed3-a04b-4a09-b954-79e816d2a3f7
M = reduce(hcat, ps)'

# ╔═╡ b135f6be-5e82-4c72-af11-0eb0d4141dec
md"""
We can visualise the matrix with a **heat map**:
"""

# ╔═╡ e74e18e3-ad08-4a53-a803-cd53564dca65
heatmap(M, yflip=true)

# ╔═╡ ed02f00f-1bcd-43fa-a56c-7be9968614cc
md"""
We can also visualise this as a 3D surface:
"""

# ╔═╡ 8d453f89-4a4a-42d0-8a00-9b153a3f435e
plotly()

# ╔═╡ f7de29b5-2a51-45e4-a0a5-f7f602681303
surface(M)

# ╔═╡ 7e817bad-dc51-4c29-a4fc-f7a8bb3663ca
md"""
But this is not necessarily very clear, so let's draw it ourselves as stacked histograms:
"""

# ╔═╡ 403d607b-6171-431b-a058-0aad0909846f
gr()

# ╔═╡ 80e033c4-a862-443d-a198-932f5822a44e
ylabels = [-(grid_size÷2):grid_size÷2;]

# ╔═╡ c8c16c14-26b0-4f83-8135-4f862ed90686
begin
	plot(leg=false)
	
	for which in 1:15
		for i in 1:length(ps[which])
			plot!([which, which], [-grid_size÷2 + i, -grid_size÷2 + i], [0, ps[which][i] ], c=which, alpha=0.8, lw = 2)
		end
	end
	
	xlims!(1, 15)
	
	plot!()
end

# ╔═╡ 29612df6-203f-42bc-b53b-86af618d60ec
let
	color_list = [:red, RGB(0, 1, 0.1), :blue]
	xs = []
	ys = []
	zs = []
	cs = []
	cs2 = []
	
	for which in 1:15
		for i in 1:length(ps[which])
			push!(xs, which, which, NaN)
			push!(ys, ylabels[i], ylabels[i], NaN)
			push!(zs, 0, ps[which][i], NaN)
			# push!(zs, 0, 1, NaN)D
			push!(cs, color_list[mod1(which, 3)], color_list[mod1(which, 3)], color_list[mod1(which, 3)])
		end
		push!(cs2, which)
	end
				# plot(xs, ys, zs)
	
	plot(leg=false)
	
	plot!(1:15, [0; cumsum(sign.(randn(14)))], zeros(15), alpha=0.6, m=:o, lw=2, c=color_list)
	plot!(xs, ys, zs, c=cs, xlims=(1, 15), ylims=(-30, 30), zlims=(0, 1), lw=2.5, alpha=0.7, xticks=(1:15), yticks=(-20:10:20))
	
xlabel!("t")
	ylabel!("space")

end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[compat]
Plots = "~1.29.1"
PlutoUI = "~0.7.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "195c5505521008abea5aee4f96930717958eac6f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.4.0"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[DataAPI]]
git-tree-sha1 = "46d2680e618f8abd007bce0c3026cb0c4a8f2032"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.12.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e3290f2d49e661fbd94046d7e3726ffcb2d41053"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.4+0"

[[Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[Extents]]
git-tree-sha1 = "5e1e4c53fa39afe63a7d356e30452249365fba99"
uuid = "411431e0-e8b7-467b-b5e0-f676ba4f2910"
version = "0.1.1"

[[FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "bc9f7725571ddb4ab2c4bc74fa397c1c5ad08943"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.69.1+0"

[[GeoInterface]]
deps = ["Extents"]
git-tree-sha1 = "fb28b5dc239d0174d7297310ef7b84a11804dfab"
uuid = "cf35fbd7-0cd7-5166-be24-54bfbe79505f"
version = "1.0.1"

[[GeometryBasics]]
deps = ["EarCut_jll", "GeoInterface", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "12a584db96f1d460421d5fb8860822971cdb8455"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.4"

[[Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

[[Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "ab9aa169d2160129beb241cb2750ca499b4e90e9"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.17"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e60321e3f2616584ff98f0a4f18d98ae6f89bbb3"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.17+0"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "6c01a9b494f6d2a9fc180a08b182fcb06f0958a0"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.2"

[[Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "21303256d239f6b484977314674aef4bb1fe4420"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.1"

[[Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "9e42de869561d6bdf8602c57ec557d43538a92f0"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.1"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "d12e612bba40d189cead6ff857ddb67bd2e6a387"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.1"

[[RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "f86b3a049e5d05227b10e15dbb315c5b90f14988"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.9"

[[StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArraysCore", "Tables"]
git-tree-sha1 = "13237798b407150a6d2e2bce5d793d7d9576e99e"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.13"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

[[x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─85c26eb4-c258-4a8b-9415-7b5f7ddff02a
# ╠═85b45a43-d7bf-4597-a1a6-329b41dce20d
# ╟─2d48bfc6-9617-11eb-3a85-279bebd21332
# ╟─30162386-039f-4cd7-9121-a3382be3c294
# ╟─4e7b163e-dfd0-457e-b1f3-8807a4d8060a
# ╠═e8ceab7b-45db-4393-bb8e-e000ecf78d2c
# ╠═2d4dffb9-39e4-48de-9688-980b96814c9f
# ╟─8ff66523-bc2e-4c53-975b-8ba4f99eb1c6
# ╟─2868dd57-7164-4162-8c5d-30628dedeb7a
# ╠═f6009473-d3c1-444f-88ae-814f770e811b
# ╟─9a368602-acd3-43fb-9dff-e407a4bab930
# ╟─67517333-175f-48c4-a915-76658cbf1304
# ╠═d6832372-d336-4a54-bbcf-d0bb70e4de64
# ╟─35f14826-f1e4-4977-a31a-0f6148fe25ad
# ╠═7468fc5d-7f35-45e2-b5fc-7e63b562bc8f
# ╠═1ca8aa3b-b05d-40f6-a925-2f0248b79ca2
# ╟─38d88b7c-3b4f-430b-8d3c-f672ab0c7a49
# ╟─f4c9b02b-738b-4de1-9e9d-05b1616bee0b
# ╟─d1c47afa-ab7f-4543-a161-e3ceb6f11eb4
# ╠═bf78e00f-05d9-4a05-8512-4924ef9e25f7
# ╟─b948830f-ead1-4f36-a237-c998f2f7deb8
# ╠═15223c51-8d31-4a50-a8ff-1cb7d35de454
# ╟─0bd45c4a-3286-427a-a927-15869be2ebfe
# ╠═999fb608-fb1a-46cb-82ca-f3f31fe617e1
# ╟─6509e69a-6e50-4816-a98f-67ba437383fb
# ╟─e58976a9-1784-441e-bb76-3011538b8ad0
# ╟─1efc2b68-9313-424f-9850-eb4496cc8486
# ╟─6e93ffda-217b-4d46-86b5-534ddc1bae90
# ╟─396d2490-3cb9-4f68-8fdf-9209d2010e02
# ╟─dc1c22e8-1c7b-43b7-8421-c2ca708931a5
# ╟─e7a52b56-322c-4478-a670-dec1013c9bd8
# ╟─5f136388-5573-4814-a088-a66278acdbbe
# ╟─e440dc3b-bafd-4e0c-9fe8-13fce8eea22d
# ╟─89d3e90d-3685-473d-aea4-0b7c5b80d7f7
# ╟─203eea14-1c68-4a9f-ab18-9a2e5f408a79
# ╠═b6d4b045-a39f-4236-ace2-9f631e853d1b
# ╟─e61b56be-d334-4c8f-aa8e-887bb27c058c
# ╠═782f0b9a-3793-4abb-826b-9e14d6eae690
# ╟─1764b56a-f297-4a4e-a931-31aa987ec785
# ╠═8082092b-b6bf-4619-8776-39fdd6c9b7c1
# ╠═34c0b850-5e95-4eb9-8435-3aae8d124772
# ╟─4115f7cb-d45f-4cc2-86bf-316c074393f8
# ╟─6bc2f20d-3d09-425b-a471-44090dc3161e
# ╟─98994cb9-45dc-48aa-b62d-2407f7184bee
# ╟─f11f8d7d-cd3f-4585-aab4-083b892c6d4c
# ╠═fb804fe2-58be-46c9-9200-ceb8863d052c
# ╟─40e457b4-616c-4fab-9c8e-2e5063129597
# ╟─979c1fbd-c9f6-4e8b-a648-6a0210fc9e7f
# ╟─583e3a92-01e7-4b88-9be0-f1e3b3c95005
# ╠═0b26efab-4e93-4d53-9c4d-faea68d12174
# ╟─b9ce5af1-84f7-4a2d-92c9-de2c5498a88d
# ╠═b48e55b7-4b56-41aa-9796-674d04adf5df
# ╟─53a36c1a-0b8c-4099-8854-08d73c9f118e
# ╠═6b298184-32c6-412d-a900-b113d6bd3d53
# ╠═b84a7255-7b0a-4ba1-8c87-9f5d3fa32ef3
# ╟─c430c4de-d9bf-44e1-aa40-6b823d718b04
# ╠═99717c6e-f713-49d5-8ee5-a08c4a464223
# ╟─242ea831-c421-4a76-b658-2a57fa924a4f
# ╠═aeaef573-1e90-45f3-a7fe-31ec5e2808c4
# ╟─efe186da-3273-4767-aafc-fc8eae01dbd9
# ╟─61201091-b8b3-4776-9be9-4c23d5ba88ba
# ╠═66c4aed3-a04b-4a09-b954-79e816d2a3f7
# ╟─b135f6be-5e82-4c72-af11-0eb0d4141dec
# ╠═e74e18e3-ad08-4a53-a803-cd53564dca65
# ╟─ed02f00f-1bcd-43fa-a56c-7be9968614cc
# ╠═8d453f89-4a4a-42d0-8a00-9b153a3f435e
# ╠═f7de29b5-2a51-45e4-a0a5-f7f602681303
# ╟─7e817bad-dc51-4c29-a4fc-f7a8bb3663ca
# ╠═403d607b-6171-431b-a058-0aad0909846f
# ╠═80e033c4-a862-443d-a198-932f5822a44e
# ╟─c8c16c14-26b0-4f83-8135-4f862ed90686
# ╠═29612df6-203f-42bc-b53b-86af618d60ec
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
