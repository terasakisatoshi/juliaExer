using Makie

scene = Scene(raw = true, camera = cam2d!, resolution = (300, 300))

center!(scene)

b1 = button("<-  ", textsize = 90, position = (50, 50))
b2 = button("->", textsize = 90, position = (50, 50))

current_status = 0

on(b1[end][:clicks]) do c
    global current_status
    current_status -= c
    @show current_status
end

on(b2[end][:clicks]) do c
    global current_status
    current_status += c
    @show current_status
end

RecordEvents(hbox(b1, b2, scene), "output")
