A,B,C=-1,-2,3

ret=map(x->begin 
        if x<0 && iseven(x) 
            return 0 
        elseif x==0 
            return 0 
        else 
            return x 
        end 
    end,[A,B,C])

println(ret)

ret=map([A,B,C]) do x 
    if x<0 && iseven(x) 
        return 0 
    elseif x==0 
        return 0 
    else 
        return x 
    end 
end 

println(ret)