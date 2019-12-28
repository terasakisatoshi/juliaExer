using Weave

#=
weave(
    "goma.jmd",
    out_path=:pwd,
    doctype="md2html",
)
=#

weave(
    "goma.jmd",
    out_path=:pwd,
    doctype="md2pdf",
    template="julia_tex.tpl",
)

#=
weave(
    "goma.jmd",
    out_path=:pwd,
    doctype="pandoc"
)
=#
