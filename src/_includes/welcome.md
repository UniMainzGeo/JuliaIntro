---
layout: "layout.jlhtml"
---

<link rel="stylesheet" href="$(root_url)/assets/styles/homepage.css" type="text/css" />

<div id="title" class="banner">
    <h1>Introduction to Julia: <strong>A new approach to computational Geodynamcis</strong></h1>
</div>
<!-- <img src="$(root_url)/assets/JGU_MAGMA.svg" class="logo"> -->

<!-- <blockquote class="banner"> -->
<blockquote class="contain">
    <p>This is a test website for the interactive Julia programming at the Institute of Geosciences at the University of Mainz. This website was inspired by <blockquote style='font-style: normal;'>Some material on this website is based on: <br><em><b>Computational Thinking</b>, a live online Julia/Pluto textbook</em>. (<a href="https://computationalthinking.mit.edu/">computationalthinking.mit.edu</a>)</blockquote> </p>
    <p style="text-align:center;">
    <img src="$(root_url)/assets/jgu_logo.svg"
        width="150" 
        height="150">
    <!-- <p>Upon completion, students are well trained to be scientific “trilinguals”, seeing and experimenting with mathematics interactively as math is meant to be seen, and ready to participate and contribute to open source development of large projects and ecosystems.</p> -->
</blockquote>

<main class="homepage">
    <div class="subjectscontainer wide">
        <div class="contain">
            <section>
                <div class="contain">
                    <h2>Learning Julia</h2>
                    <p>In literature it’s not enough to just know the technicalities of grammar. In music it’s not enough to learn the scales. The goal is to communicate experiences and emotions. For a computer scientist, it’s not enough to write a working program, the program should be <strong>written with beautiful high level abstractions that speak to your audience</strong>. This class will show you how.</p>
                </div>
                <div class="preview">
                    <img src="https://user-images.githubusercontent.com/6933510/136203632-29ce0a96-5a34-46ad-a996-de55b3bcd380.png">
                </div>
            </section>
        </div>
    </div>
    <div class="wide subjectscontainer">
        <h1>Subjects</h1>
        <div class="subjects">$(
            let
                sidebar_data = Base.include(@__MODULE__, joinpath(@__DIR__, "..", "sidebar data.jl"))
                sections = sidebar_data["main"]
            
                [
                    @htl("""
                    $([
                        let
                            input = other_page.input
                            output = other_page.output
                            
                            name = get(output.frontmatter, "title", basename(input.relative_path))
                            desc = get(output.frontmatter, "description", nothing)
                            tags = get(output.frontmatter, "tags", String[])
                            
                            image = get(output.frontmatter, "image", nothing)
                            
                            class = [
                                "no-decoration",
                                ("tag_$(replace(x, " "=>"_"))" for x in tags)...,
                            ]
                            
                            image === nothing || isempty(image) ? nothing : @htl("""<a title=$(desc) class=$(class) href=$(root_url * "/" * other_page.url)>
                                <h3>$(name)</h3>
                                <img src=$(image)>
                            </a>""")
                        end for other_page in pages
                    ])
                    """)
                    for (section_name, pages) in sections
                ]
            end
            )</div>
    </div>
    <div>
        <h1>Details</h1>
        <blockquote>
            <p>See also the course repository <a href="https://github.com/UniMainzGeo">github.com/UniMainzGeo</a>.</p>
        </blockquote>
        <p></p>
        <blockquote>
            <p><em><strong><a href="$(root_url)/reviews/">What people are saying about the course!</a></strong></em></p>
        </blockquote>
        <h2 id="meet_our_staff">Meet our staff</h2>
        <p><strong>Lecturer:</strong> <a href="https://www.geosciences.uni-mainz.de/geophysics-and-geodynamics/team/univ-prof-dr-boris-kaus/">Boris Kaus</a></p>
        <p><strong>Technical lead:</strong> <a href="https://github.com/aelligp">Pascal Aellig</a></p>
        <p><strong>Guest lecturers:</strong>  <a href="https://ptsolvers.github.io/GPU4GEO/">Ludovic Raess</a>, <a href="https://ptsolvers.github.io/GPU4GEO/">Ivan Utkin</a>, <em>more to be announced</em></p>
    </div>
    <div class="page-foot">
        <div class="copyright">
            <a href="https://github.com/UniMainzGeo/JuliaIntro"><b>Edit this page on <img class="github-logo" src="https://unpkg.com/ionicons@5.1.2/dist/svg/logo-github.svg"></b></a><br>
            Website built with <a href="https://plutojl.org/">Pluto.jl</a> and the <a href="https://julialang.org">Julia programming language</a>.
        </div>
    </div>
</main>