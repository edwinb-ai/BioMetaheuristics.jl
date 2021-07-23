using Documenter
using BioMetaheuristics, BioMetaheuristics.TestFunctions

# ! Build the full Documentation with Documenter
makedocs(;
    modules=[BioMetaheuristics, BioMetaheuristics.TestFunctions],
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://edwinb-ai.github.io/BioMetaheuristics.jl/stable/",
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
    repo="https://github.com/edwinb-ai/BioMetaheuristics.jl/blob/{commit}{path}#L{line}",
    sitename="BioMetaheuristics.jl",
    authors="Edwin Bedolla"
)

deploydocs(
    repo="github.com/edwinb-ai/BioMetaheuristics.jl.git",
    push_preview=true
)
