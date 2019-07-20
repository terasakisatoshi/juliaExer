function producer(c::Channel)
    put!(c, "start")
    for i in 1:4
        put!(c, 2i)
    end
    put!(c, "stop")
end

function example1()
    ch = Channel(producer)
    println(take!(ch))

    println(take!(ch))
    println(take!(ch))
    println(take!(ch))
    println(take!(ch))

    println(take!(ch))
end

function example2()
    for x in Channel(producer)
        println(x)
    end
end

function main()
    example1()
    example2()
end

main()




