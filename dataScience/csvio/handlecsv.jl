using CSV
using InteractiveUtils

function main()
    dataframe = CSV.read("sample.csv", header=false, delim=',')
    @show dataframe
    row,col=size(dataframe)
    for  c =1:col
        dataframe[c] *= c
    end
    dataframe |> CSV.write("output.csv",delim=',',writeheader=false)
    run(pipeline(`cat output.tsv`))
end

main()
