using PyPlot
using PyCall
@pyimport matplotlib.animation as anim

srand(12345)

b = 0.8 # 相関項(Correlation term)
x = 10.0
y = 3.0
times = 200
ims = []

for i = 1:times
    u1 = rand()
    u2 = rand()
    x_old = x
    x = sqrt(-2*log(u1))*cos(2*pi*u2) + b*y
    push!(ims, ([x_old, x], [y, y])) # 表示せずに配列imsに保存
    y_old = y
    y = sqrt(-2*log(u1))*sin(2*pi*u2) + b*x
    push!(ims, ([x, x], [y_old, y])) # 表示せずに配列imsに保存
end

########## display file
function displayfile(mimetype, filename)
    open(filename) do f
        base64text = base64encode(f)
        display("text/html", """<img src="data:$mimetype;base64,$base64text">""")
    end
end

########## initialize the frame
xs = [ims[i][j][1] for j in 1:2, i in 1:length(ims)]
ys = [ims[i][j][2] for j in 1:2, i in 1:length(ims)]
xmin, xmax = minimum(xs)-0.5, maximum(xs)+0.5
ymin, ymax = minimum(ys)-0.5, maximum(ys)+0.5
function initframe()
    xlim(xmin, xmax)
    ylim(ymin, ymax)
    grid(ls=":")
end

########## update the frame
function updateframe(t)
    # clf() #←全部消して書き直す場合にはコメントを外す
    #---------- フレームのアップデート開始
    if t ≥ 1
        X, Y = ims[t]
        plot(X, Y, lw=1.0)
    end
    title("t = $t")
    #---------- フレームのアップデート終了
    # plot() #←念のためのおまじない. []と書いてもよい. いらない場合も多い.
end




########## filename
filename = "gibbs_sampling.gif"

######### Construct Figure and Plot Data
fig = figure(figsize=(6.4, 4.8))

# Create the animation object by anim.FuncAnimaton
frames = collect(0:length(ims))
@time myanim = anim.FuncAnimation(fig, updateframe, init_func=initframe, frames=frames, interval=100)

# Convert it to an animated GIF file by Imagemagick.
@time myanim[:save](filename, writer="imagemagick")

sleep(0.1)

# Display the movie.
displayfile("image/gif", filename)

# Don't display the axes of figure().
clf()