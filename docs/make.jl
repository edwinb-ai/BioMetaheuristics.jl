using Documenter
using Newtman, Newtman.TestFunctions
using Literate

# ! Convert scripts to markdown using Literate
files = ["examples.jl"]

function lit_to_md(file)
    examples_path = "docs/src/examples"
    out_md_path = "docs/src/"
    Literate.markdown(
        joinpath(examples_path, file),
        out_md_path;
        documenter = true
    )
end

map(lit_to_md, files)

# ! Build the full Documentation with Documenter
makedocs(;
    modules = [Newtman, Newtman.TestFunctions],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Guide" => "guide.md",
        "Examples" => "examples.md",
        "Implementations" => "algorithms.md",
        "Benchmark functions" => "benchmarks.md",
        "Reference" => "reference.md",
        "License" => "license.md",
    ],
    sitename = "Newtman.jl",
    authors = "Edwin Bedolla",
)

deploydocs(
    repo = "github.com/edwinb-ai/Newtman.jl.git"
)
