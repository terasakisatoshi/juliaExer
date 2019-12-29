using Weave

# weave("docs.jmd",out_path=:pwd,doctype="md2html")
weave(
    "docs.jmd",
    out_path=:pwd,
    doctype="md2pdf",
    template="julia_tex.tpl",
)
