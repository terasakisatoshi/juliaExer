function xorshift32(seed=UInt32(2463534242))
    y = seed
    inner=function counter() 
    	y = y $ (y << 13) 
    	y = y $ (y >> 17)
    	y = y $ (y << 5)
    	return y
    end
    return inner
end

function uniform(generator,b=0.0,e=1.0)
	inner=function inner()
		value=b+generator()/typemax(UInt32)/(e-b)
		return value
	end
	return inner
end


function u01(generator)
	inner=function inner()
		value=generator()/typemax(UInt32)
		return value
	end
	return inner
end

function main()
	#uniform01=uniform(xorshift32())
	uniform01=u01(xorshift32())
	N=10000000
	count=0
	for i = 1:N
		x=uniform01()
		y=uniform01()
		if x*x+y*y<1.0
			count+=1
		end
	end
	println("Pi=",4.0*count/N)
end

main()