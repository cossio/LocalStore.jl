using Documenter, Literate
import LocalStore

ENV["JULIA_DEBUG"] = "Documenter,Literate,LocalStore"

const literate_dir = joinpath(@__DIR__, "src/literate")

function clear_md_files(dir::String)
    for file in readdir(dir; join=true)
        if endswith(file, ".md")
            rm(file)
        end
    end
end

clear_md_files(literate_dir)

for file in readdir(literate_dir; join=true)
    if endswith(file, ".jl")
        Literate.markdown(file, literate_dir)
    end
end

makedocs(
    modules = [LocalStore],
    sitename = "LocalStore.jl",
    pages = [
        "Home" => "index.md",
        "Examples" => [
            "Save / load" => "literate/io.md",
        ],
        "Reference" => "reference.md"
    ],
    strict = true
)

clear_md_files(literate_dir)

deploydocs(
    repo = "github.com/cossio/LocalStore.jl.git",
    devbranch = "master"
)
