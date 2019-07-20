N=10000000
cnt=0
for i = 1:N
    x=rand()
    y=rand()
    if x^2+y^2<1.0
        cnt+=1
    end
end

@printf "Estimate of PI for %d trials is %8.5f\n" N 4.0*(cnt / N)