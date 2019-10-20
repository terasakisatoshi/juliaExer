using PyCall
using BenchmarkTools

py"""
import cv2
import numpy as np

cap = cv2.VideoCapture(0)
if cap.isOpened() is False:
    raise Exception("Error opening video stream of file")
goma=None

def capture(canvas):
    global goma
    ret_val, image = cap.read()
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    H,W,_=image.shape
    oH,oW,_ = canvas.shape
    if oH > H or oW > W:
        raise ValueError('shape of image needs to be larger than size')
    y_offset = int(round((H - oH) / 2.))
    x_offset = int(round((W - oW) / 2.))
    y_slice = slice(y_offset, y_offset + oH)
    x_slice = slice(x_offset, x_offset + oW)
    canvas[:]=image[y_slice,x_slice]
    goma = image

def captureraw():
    ret_val, image = cap.read()
    return image

def savecanvas(canvas):
    cv2.imwrite("goma.png", canvas)
"""

function capture!(canvas)
    pycall(py"capture",Nothing,canvas)
end

function capture()
    canvas=py"captureraw"()
    return canvas
end
