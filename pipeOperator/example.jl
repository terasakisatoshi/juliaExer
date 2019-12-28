twice(x)=2x
half(x)=x/2
addone(x)=x+1


x=1
y=x |> twice |> addone |> half
@show y

z=begin 
   x |>
   twice |>
   addone |>
   half
end

@show z

