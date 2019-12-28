using Base64
struct Viewer
    fn::String
end
"""
visualize gif result at Plots pane
See https://discourse.julialang.org/t/base-show-and-plotpane/17835/3
"""
function Base.show(io::IO, b::Viewer)
    mime = "image/png"
    suffix = ";base64,"
    str = stringmime(mime, read(b.fn))
    str = string("<img src=\"data:", mime, suffix, str, "\">")
    Juno.render(Juno.PlotPane(), HTML(str))
end
