function parasum(n)
    ret =0
    @parallel for x in range(0,n)
        s=0 
        for y in range(0,n)
            s += 3x - 5y 
        end 
        ret+=s
    end 
    return ret 
end 

function main()
    n=10
    ret=parasum(n) 
    println(ret)
end 

main()