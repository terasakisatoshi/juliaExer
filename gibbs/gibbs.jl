#Reference:http://nbviewer.jupyter.org/gist/genkuroki/b46b0a094ee232302d41780defaffd6e

import PyPlot # Juliaでmatplotlib.pyplotを使うためのパッケージ
plt = PyPlot # as plt の代わり

using PyCall # JuliaからPythonの任意のライブラリを使うためのパッケージ
animation = pyimport("matplotlib.animation") # as animation の代わり

# このノートブックでは imagemagick でGIF動画を作成し, 
# ノートブック内にbase64エンコードして読み込んで表示する.
function displayfile(mimetype, filename)
    open(filename) do f
        base64text = base64encode(f)
        display("text/html", """<img src="data:$mimetype;base64,$base64text">""")
    end
end

fig,ax=plt.subplots()
ax[:set_xlim](-4.5,10.5)
ax[:set_ylim](-4.5,4.5)

b=0.8
x=10.0
y=3.0
times=200 
srand(12345) # np.random.seed(12345) の代わり. 上のセルと同じ結果になるように挿入した.
    
function update(data) # defをfunctionに置き換えて, コロンを消した.
    u1 = rand()
    u2 = rand()
    global x, y
    x_old=x
    x = sqrt(-2*log(u1))*cos(2*pi*u2) + b*y
    ax[:plot]([x_old, x], [y, y], lw=1)
    y_old = y
    y = sqrt(-2*log(u1))*sin(2*pi*u2) + b*x
    ax[:plot]([x, x], [y_old, y], lw=1)
    ax[:set_title]("$data")
end # end を追加した.
ani=animation[:FuncAnimation](fig,update,frames=times,interval=100)
ani[:save]("output.gif", writer="imagemagick") # GIFファイルに出力

plt.clf() # ←必ずしも必要ない. 単に余計な表示を消すためのコード

displayfile("image/gif", "output.gif")