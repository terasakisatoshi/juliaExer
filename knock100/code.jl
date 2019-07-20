#%%
using InteractiveUtils

"""
Julia 100-knock
"""

#%%
@show VERSION
versioninfo()
#%%
Z = zeros(10)
Z[5] = 1
@show Z
#%%
Z = [10:100]
#%%
Z = reshape(collect(1:9), (3, 3))
#%%
x=[1, 2, 0, 0, 4, 0]
nonzeroidx = collect(1:length(x))[iszero.(x)]
@show nonzeroidx

#%%

function gomagoma(n)
    for i in 1:n
        @show i
        j = i+1
        k = i-1
    end
end
