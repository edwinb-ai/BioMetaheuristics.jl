using Documenter
using Newtman, Newtman.TestFunctions
using Literate

# ! Convert scripts to markdown using Literate
files = ["examples.jl", "api.jl"]

function lit_to_md(file)
    examples_path = joinpath("docs", "src", "examples")
    out_md_path = joinpath("docs", "src")
    Literate.markdown(
        joinpath(examples_path, file),
        out_md_path;
        documenter=true
    )
end

map(lit_to_md, files)

# ! Build the full Documentation with Documenter
makedocs(;
    modules=[Newtman, Newtman.TestFunctions],
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://edwinb-ai.github.io/Newtman.jl/stable/",
        assets=String[]
    ),
    pages=[
        "Home" => "index.md",
        "Theory" => "theory.md",
        "Examples" => ["examples.md", "api.md"],
        "Implementations" => "algorithms.md",
        "Benchmark functions" => "benchmarks.md",
        "Reference" => "reference.md",
        "License" => "license.md",
    ],
    repo="https://github.com/edwinb-ai/Newtman.jl/blob/{commit}{path}#L{line}",
    sitename="Newtman.jl",
    authors="Edwin Bedolla"
)

deploydocs(
    repo="github.com/edwinb-ai/Newtman.jl.git",
    push_preview=true
)
