#=
Metaprogramming: Julia Cookbook
=#

function new_struct(fields::Vector{Tuple{String,DataType}})
    name = "A" * string(hash(fields), base = 16)
    code = "begin\nstruct $name\n"
    for f in fields
        code *= f[1] * "::" * string(f[2]) * "\n"
    end
    code *= "end\n$name\nend"
    eval(Meta.parse(code))
end

function parse_data(data::AbstractString)
    lines = filter(x -> length(x) > 0, strip.(split(data, ('\n', '\r'))))
    colnames = string.(split(lines[1], ','))
    row1 = split.(lines[2], ',')
    coltypes = [occursin(r"^-?\d+$", val) ? Int64 : String for val in row1]
    (lines[2:end], new_struct(collect(zip(colnames, coltypes))))
end

function parse_text(data::AbstractString)
    lines, MyStruct = parse_data(data)
    res = MyStruct[]
    for line in lines
        colvals = split(line, ',')
        f = (t, v) -> t <: Int ? parse(Int, v) : string(v)
        vals = f.(MyStruct.types, colvals)
        push!(res, Base.invokelatest(MyStruct, vals...))
    end
    res
end

MyS = new_struct([("a", Int), ("b", String), ("c", Int)])
#repr(dump(MyS))
#repr(dump(parse_data("col1,col2,col3\nabc,123,123.5")[2]))
data = """
id,val,class
1,4,A
2,39,B
3,44,C
"""
#print(parse_text(data))

code = "begin\n
      struct Goma\n
          x::Int\n
          y::Int\n
      end\n
      Goma\n
  end"

g = eval(Meta.parse(code))(1, 2)
print(g) # should be Goma(1,2)
