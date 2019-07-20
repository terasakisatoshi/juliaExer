"""
1000 class object classification
base code is taken from...
https://github.com/tensorflow/tensorflow/blob/master/tensorflow/lite/examples/python/label_image.py
"""
import os
import time

import cv2
import numpy as np
from PIL import Image, ImageDraw
# version 1.13.*
import tensorflow as tf
from tensorflow.contrib.lite.python import interpreter as ip
from utils import download_label, download_checkpoint
from utils import load_labels, parse_param_from_model, clip_image
from utils import VERSION, SAVEDIR


class TFModel:

    def __init__(self, checkpoint):
        models, version, multiplier, input_size = parse_param_from_model(
            checkpoint)
        self.title = "_".join([models, version, str(multiplier), str(input_size)])
        self.prepare_model(checkpoint)

    def prepare_model(self, checkpoint):
        print(checkpoint)
        self.floating_model = False
        self.interpreter = ip.Interpreter(model_path=checkpoint)
        self.interpreter.allocate_tensors()
        input_details = self.interpreter.get_input_details()
        output_details = self.interpreter.get_output_details()
        if input_details[0]['dtype'] == np.float32:
            self.floating_model = True
        # NxHxWxC, H:1, W:2
        self.height = input_details[0]['shape'][1]
        self.width = input_details[0]['shape'][2]
        self.input_index = input_details[0]['index']
        self.output_index = output_details[0]['index']

    def __call__(self, img):
        """
        input image `img` and then output top ten probablities and its label indices
        we will assume img format should be HWC with RGB color
        """
        pilImg = Image.fromarray(img)
        pilImg = pilImg.resize((self.width, self.height))
        input_image = np.asarray(pilImg)
        input_image = np.expand_dims(input_image, axis=0)
        if self.floating_model:
            input_image = (np.float32(input_image) - 127.5) / 127.5
        self.interpreter.set_tensor(self.input_index, input_image)
        self.interpreter.invoke()
        prediction = self.interpreter.get_tensor(self.output_index)
        prediction = np.squeeze(prediction)
        top_ten = np.argsort(-prediction)[:10]
        return top_ten, prediction


def create_canvas(labels, top_k, prediction, height, elapsed):
    canvas = Image.new("RGB", (2 * height // 3, height), (0, 0, 0))
    drawer = ImageDraw.Draw(canvas)
    for rank, label_idx in enumerate(top_k):
        score = prediction[label_idx]
        label = labels[label_idx]
        text = '{:>3d} {:>6.2f}% {}'.format(
            rank + 1,
            prediction[label_idx] * 100,
            labels[label_idx]
        )
        drawer.text((10, 60 + rank * 50), text, fill=(0, 255, 0))
    drawer.text((10, 10), "FPS: %f" % (1.0 / elapsed), fill=(0, 255, 0))
    canvas = np.array(canvas)
    return canvas


def predict_using_tflite(checkpoint, labels):
    model = TFModel(checkpoint)
    cap = cv2.VideoCapture(0)
    if cap.isOpened() is False:
        print("Error opening video stream or file")
    fps_time = 0
    use_cv2 = True
    display_size = (640, 640)  # w, h
    start = time.time()
    while cap.isOpened():
        ret_val, img = cap.read()
        img = clip_image(img)
        top_k, prediction = model(img)
        img = cv2.resize(img, display_size)
        elapsed = time.time() - start
        canvas = create_canvas(labels, top_k, prediction, display_size, elapsed)
        start = time.time()
        cv2.imshow(model.title, cv2.hconcat([img, canvas]))

        if cv2.waitKey(1) == 27:
            break


def main():
    multiplier = 1.0
    input_size = 224
    modelname = "mobilenet_{}_{}_{}".format(VERSION, multiplier, input_size)
    labels = load_labels()

    download_checkpoint(multiplier, input_size)
    checkpoint = os.path.join(SAVEDIR, modelname, "mobilenet_v2_1.0_224.tflite")
    print("checkpoint", checkpoint)
    predict_using_tflite(checkpoint, labels)


if __name__ == '__main__':
    main()
