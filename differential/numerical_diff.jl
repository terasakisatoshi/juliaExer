# Algorithm for Optimization

diff_forward(f,x;h=sqrt(eps(Float64))) = (f(x+h)-f(x))/h
diff_central(f,x;h=sqrt(eps(Float64))) = (f(x+h/2)-f(x-h/2))/h
diff_backward(f,x;h=sqrt(eps(Float64))) = (f(x)-f(x-h))/2
diff_complex(f,x;h=1e-20) = imag(f(x+h*im))/h

f=x->sin(x^2);
v = f(π/2+0.001im);
@show real(v) #f(x)
@show imag(v)/0.001 #f'(x)
@show sin(pi/2*pi/2), π*cos(π^2/4)
