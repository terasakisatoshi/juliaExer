inp1=readline()
inp2=readline()

# 文字列を数字として認識させたい
arr1=parse.(split(inp1))
arr2=parse.(split(inp2))
# 何かをする
@show arr1+arr2
