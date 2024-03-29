# using NewickTree

using Phylo
using Plots
# using FastaIO
# using FASTX

path = "C:\\Users\\nicom\\Desktop\\SOPHYSM\\SOPHYSM\\WS\\ESEMPIO\\SlideExample_mini_1\\SlideExample_mini_1_Files_JSpace\\formatNewick"
# fasta_path = "C:\\Users\\nicom\\Desktop\\SOPHYSM\\SOPHYSM\\WS\\ESEMPIO\\SlideExample_mini_1\\SlideExample_mini_1_Files_JSpace\\Fasta output\\reference.fasta"

# fasta_dict = Dict{String, String}()
# for (name, seq) in FastaReader(fasta_path)
#    s = seq
# end

# open(FASTA.Reader, fasta_path) do reader
#    record = FASTA.Record()
#    while !eof(reader)
#        read!(reader, record)
#        show(FASTX.sequence(String, record))
#    end
# end



filepath_phylo = replace(path, r"$" => "_phylo_tree.png")
# default(linecolor = :black, size = (400, 400))
hummers = Phylo.open(parsenewick, Phylo.path(path))

# plot(hummers, treetype = :fan)

# evolve(tree) = map_depthfirst((val, node) -> val + randn(), 0., tree, Float64)
# trait = evolve(hummers)
# plot(hummers, treetype = :fan, line_z = trait, linecolor = :RdYlBu, linewidth = 5, showtips = false)

# brownsampler = BrownianTrait(hummers, "Trait")
# plot(hummers,
#     showtips = false, marker_z = rand(fasta_dict),
#     linewidth = 2, markercolor = :RdYlBu, size = (400, 600))

phyloTree = Plots.plot(hummers,
    size = (800, 600), showtips = true,
    linecolor = :steelblue, linewidth = 2,
    markersize = 10, markercolor = :orange, markerstrokecolor = :black,
    series_annotations = Plots.text.(1:Phylo.nnodes(hummers), 7, :center, :center, :black)
)
Plots.savefig(phyloTree, filepath_phylo)
