---
layout: "layout.jlhtml"
---

<link rel="stylesheet" href="$(root_url)/assets/styles/homepage.css" type="text/css" />

<div id="title" class="banner">
    <h1>Introduction to Julia: <strong>A new approach to computational Geodynamics</strong></h1>
</div>
<!-- <img src="$(root_url)/assets/JGU_MAGMA.svg" class="logo"> -->
<div class="page-head">
    <blockquote class="contain">
        <div class="page-head-content">
            <div class="page-head-content-left">
                <h1>Introduction to Julia: <strong>A new approach to computational Geodynamics</strong></h1>
                <!-- <p>Julia is a new programming language that combines the ease of use of Pytchon with the speed of C. It is a modern language to solve modern problems. It is a language for scientists, engineers, students, and researchers who are solving problems that previously took a long time to solve or compute. The open source packages enables you to solve problems in geodynamics, geophysics, and geology withput having hundereds of lines of code. The goal of this course is to introduce students to the Julia programming language and to show how it can be used to solve problems in geodynamics.</p> -->
            <!-- </p>
    </blockquote> -->
<!-- <p></p>
<blockquote class="contain"> -->
    <p>This is a test website for the interactive Julia programming at the Institute of Geosciences at the University of Mainz. This website was inspired by <blockquote style='font-style: normal;'>Some material on this website is based on: <br><em><b>Computational Thinking</b>, a live online Julia/Pluto textbook</em>. (<a href="https://computationalthinking.mit.edu/">computationalthinking.mit.edu</a>)</blockquote> </p>
    <p style="text-align:center;">
    <img src="$(root_url)/assets/jgu_logo.svg"
        width="150" 
        height="150">
    <!-- <p>Upon completion, students are well trained to be scientific “trilinguals”, seeing and experimenting with mathematics interactively as math is meant to be seen, and ready to participate and contribute to open source development of large projects and ecosystems.</p> -->
</blockquote>

<!-- <main class="homepage"> -->
<div class="contain">
    <blockquote class="contain">
        <h1>Subjects</h1>
        <div class="subjects">$(
            let
                sidebar_data = Base.include(@__MODULE__, joinpath(@__DIR__, "..", "sidebar data.jl"))
                sections = sidebar_data["Subjects"]

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
                            #Include the following line to create a link without an image
                            image === nothing || isempty(image) ? @htl("""<a title=$(desc) class=$(class) href=$(root_url * "/" * other_page.url)>$(name)</a>""") : nothing
                        end for other_page in pages
                    ])
                    """)
                    for (section_name, pages) in sections
                ]
            end
            )</div>
    <div>
        <h1>Details</strong></h1>
        <p>See also the course repository <a href="https://github.com/UniMainzGeo/JuliaIntro">github.com/UniMainzGeo/JuliaIntro</a>.</p>
        <p></p>
        <h2 id="meet_our_staff">Meet our staff</h2>
        <p><strong>Lecturer:</strong> <a href="https://www.geosciences.uni-mainz.de/geophysics-and-geodynamics/team/univ-prof-dr-boris-kaus/">Boris Kaus</a></p>
        <p><strong>Technical lead:</strong> <a href="https://github.com/aelligp">Pascal Aellig</a></p>
        <p><strong>Guest lecturers:</strong>  <a href="https://ptsolvers.github.io/GPU4GEO/">Ludovic Raess</a>, <a href="https://ptsolvers.github.io/GPU4GEO/">Ivan Utkin</a>, <em>more to be announced</em></p>
    </div>
    </blockquote>
    <div class="page-foot">
        <div class="copyright">
            <a href="https://github.com/UniMainzGeo/JuliaIntro"><b>Edit this page on <img class="github-logo" src="https://unpkg.com/ionicons@5.1.2/dist/svg/logo-github.svg"></b></a> Website built with <a href="https://plutojl.org/">Pluto.jl</a> and the <a href="https://julialang.org">Julia programming language</a>.
        </div>
    </div>
</div>