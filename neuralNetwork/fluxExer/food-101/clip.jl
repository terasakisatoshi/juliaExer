using Images

arr=rand(3,512,512)
img=colorview(RGB,arr)

clipped = img[1:224,1:224]
