arr = [1,3,5,7,9,11]
@show typeof(arr)

arr = [[1,2,3],[4,5],[6,7,8,9,10]]
@show typeof(arr)

arr = [[1 2 3];[4 5 6];[7 8 9]]
@show typeof(arr)

arr = [1 2 3;4 5 6;7 8 9]
@show typeof(arr)

arr_1 = arr

arr_1[1]=0
@show arr_1,arr
copyarr=copy(arr)
copyarr[1]=-1
@show copyarr,arr
