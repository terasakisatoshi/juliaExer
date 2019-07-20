
function func(x)
    return x-cos(x)
end

function bisection(func,xleft,xright,eps)  
    y_left = func(xleft)
    y_right = func(xright)
    num_iter = 0
    iteration = 100000000
    if y_left == 0
        return xleft, num_iter
    elseif y_right == 0
        return xright, num_iter
    elseif y_left*y_right > 0
        return nothing, nothing
    else
        for n in 1:iteration
            x_mid = (xleft+xright)/2
            y_mid = func(x_mid)
            if y_mid == 0
                num_iter = n
                return x_mid, num_iter
            end
            if y_left*y_mid < 0
                xright = x_mid
            else
                xleft = x_mid
            end
            if(abs(xright-xleft) < eps)
                num_iter = n
                return x_mid, num_iter
            end
        end
        return nothing, num_iter
    end
end


function main()
    xleft, xright = 0, 3.14
    eps = 1e-7
    solution, num_iter = bisection(func, xleft, xright, eps)
    if solution != nothing
        print("X=$(solution) $(func(solution)), $(num_iter)")
    elseif num_iter == nothing
        print("f(x1)*f(x2) must be less than 0")
    else
        print("No Convergence")
    end
end

main()
