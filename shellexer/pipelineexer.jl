const file=pwd()*"/file.txt"

function execute(cmd)
    @show cmd
    @show read(cmd)
    @show read(cmd,String)
    println("run(cmd);")
    run(cmd)
end

function main()
    cmd=pipeline(`cat $file`,`sort`,`uniq`)
    execute(cmd)
    cmd = pipeline(`cat $file`,`xargs echo`)
    execute(cmd)
    n=11
    cmd = pipeline(`seq $n`,`sort -nr`)
    execute(cmd)
    cmd = pipeline(`echo hello`, `sort`)
    execute(cmd)
    run(`echo hello '|' sort`)
    run(`echo hello \| sort`)
end

main()
