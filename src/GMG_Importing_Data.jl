### A Pluto.jl notebook ###
# v0.19.25

#> [frontmatter]
#> chapter = "2"
#> Authors = ["Pascal Aellig"]
#> title = "Importing Data"
#> section = "2"
#> order = "2"
#> tags = ["GMG", "lecture"]
#> layout = "layout.jlhtml"
#> description = "Importing Data"
#> License = "MIT"

using Markdown
using InteractiveUtils

# ╔═╡ eb3b3a31-c5af-48ca-98b8-28e76cb7ee17
md" # Importing Data 
**DISCLAIMER: THIS PART IS TAKEN FROM THE GMG TUTORIAL OF M.THIELMANN @UNI BAYREUTH**

### 1. Data sources
Before you can use GMG, you obviously need data. Given the different kinds of data available, there is a multitude of sources. Here, we list some of them that may be useful in the future:

- [MB4D Data Repository](https://dataservices.gfz-potsdam.de/4dmb/): Repository for data obtained within SPP 4DMB
- [ETOPO1](https://www.ncei.noaa.gov/products/etopo-global-relief-model): Global relief data with a resolution of 1 arc-minute
- [IRIS Earth Model Collaboration](http://ds.iris.edu/ds/products/emc-earthmodels/): Different Earth Models, in particular a large collection of seismic tomographies
- [our own database](https://seafile.rlp.net/d/22b0fb85550240758552/): a collection of different data which we have already processed with GMG
- and many more…
A lot of data is also not available via dedicated repositories, but via more general repositories such as Zenodo or even hosted on private websites. For the purpose of this tutorial, we will now focus on data from seismic tomographies. For the European Alps, there are several datasets which are freely available. Here, we will use the dataset by Paffrath et al. which uses AlpArray data. The data is available for download in a [public repository](https://doi.org/10.5880/fidgeo.2021.032)

Paffrath, M., Friederich, W., and the AlpArray and AlpArray-Swath D working group: Imaging structure and geometry of slabs in the greater Alpine area – A P-wave traveltime tomography using AlpArray Seismic Network data, Solid Earth Discuss., [https://doi.org/10.5194/se-12-2671-2021](https://doi.org/10.5194/se-12-2671-2021), 2021."

# ╔═╡ 283cbe28-b5a5-4bcd-bf10-fbd65edddc53
md"### 2. Importing tomographic data given as ASCII file"

# ╔═╡ Cell order:
# ╟─eb3b3a31-c5af-48ca-98b8-28e76cb7ee17
# ╟─283cbe28-b5a5-4bcd-bf10-fbd65edddc53
