using Documenter, Newtman

makedocs(;
    modules=[Newtman],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "Types" => "benchmarks.md",
    ],
    repo="https://github.com/developEdwin/Newtman.jl/blob/{commit}{path}#{line}",
    sitename="Newtman.jl",
    authors="Edwin Bedolla",
)

deploydocs(
    repo="https://github.com/edwinb-ai/Newtman.jl.git"
)
