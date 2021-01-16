using Literate

# ! Convert scripts to markdown using Literate
files = ["examples.jl", "api.jl"]

function lit_to_md(file)
    examples_path = joinpath("docs", "src", "examples")
    out_md_path = joinpath("docs", "src")
    Literate.markdown(
        joinpath(examples_path, file),
        out_md_path;
        documenter=true,
        execute=true
    )
end

map(lit_to_md, files)
