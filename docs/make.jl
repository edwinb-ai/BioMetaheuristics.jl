using Documenter, Newtman

makedocs(;
    modules=[Newtman],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "Refence" => "reference.md",
    ],
    sitename="Newtman.jl",
    authors="Edwin Bedolla",
)

deploydocs(
    repo="github.com/edwinb-ai/Newtman.jl.git"
)
