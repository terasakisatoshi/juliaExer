open("data.txt","w") do fp
    for i in 1:10
        write(fp, "$i\n")
    end
end
