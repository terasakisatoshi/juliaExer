using Makie

function main()
    ts = Node(0.001)
    scene = Scene()
    v = range(0, stop=4pi, length=50)
    f(v, t) = sin(v + t) # some function
    s = lines!(
        scene,
        lift(t -> f.(v, t), ts),
    )[end];

    for i = 1:length(v)
        push!(ts, i)
        sleep(1/24)
    end

    r = 1:100
    for i = 1:length(r)
        scene[:markersize] = r[i]
        force_update!()
        sleep(1/24)
    end
end

main()

