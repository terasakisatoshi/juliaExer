#solve eq x=cos(x)
function main()
    x=0.0
    xnext = cos(x)
    iter=0
    eps=1e-7
    iteration=1000000
    is_convergence=false

    for n in 1:iteration
        xnext = cos(x)
        if(abs(xnext-x)<eps)
            is_convergence=true
            iter=n
            break 
        end
        x=xnext
    end

    if is_convergence
        println("X=",xnext,", iter=",iter)
        println("X-cos(X)=",xnext-cos(xnext))
    else 
        print("No Convergence")
    end 
end 

main()
