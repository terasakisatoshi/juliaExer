# Interaction with Mouse
# Original implementation is here:
# https://simondanisch.github.io/ReferenceImages/gallery/interaction_with_mouse/index.html

using Makie

function main()
    scene = Scene(raw = true, camera = cam2d!, resolution = (500, 500))
    r = LinRange(0, 3, 4)
    the_time = Node(time())
    last_open = false

    @async while true
        global last_open
        the_time[] = time()
        last_open && !isopen(scene) && break
        last_open && isopen(scene)
        sleep(1 / 30)
    end

    pos = lift(scene.events.mouseposition, the_time) do mpos, t
        mouse = to_world(scene, Point2f0(mpos))
        Point2f0.([mouse, mouse])
    end

    scatter!(scene, pos)

    RecordEvents(hbox(scene), "output")
end

main()
