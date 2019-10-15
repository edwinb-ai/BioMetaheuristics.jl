using Documenter, Newtman

makedocs(;
    modules=[Newtman],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "Functions" => "benchmarks.md",
        "Algorithms" => "algorithms.md",
        "Population" => "population.md",
    ],
    sitename="Newtman.jl",
    authors="Edwin Bedolla",
)

# deploydocs(
#     repo="github.com/edwinb-ai/Newtman.jl.git"
# )
