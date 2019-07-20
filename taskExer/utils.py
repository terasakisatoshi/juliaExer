import os
import six
import tarfile

if six.PY2:
    from urllib import urlretrieve
else:
    from urllib.request import urlretrieve

VERSION = "v2"
SAVEDIR = os.path.join(os.path.dirname(__file__), "checkpoints")


def download_label():
    url = "https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_1.0_224_frozen.tgz"
    if not os.path.exists(SAVEDIR):
        print("mkdir")
        os.makedirs(SAVEDIR)

    tar_path = os.path.join(SAVEDIR, "mobilenet_v1_1.0_224_frozen.tgz")
    if not os.path.exists(tar_path):
        print("Downloading...", url)
        urlretrieve(url, tar_path)
        with tarfile.open(tar_path, mode='r') as tar:
            tar.extract(member=os.path.join("mobilenet_v1_1.0_224", "labels.txt"), path=SAVEDIR)


def load_labels(filename=os.path.join(SAVEDIR, "mobilenet_v1_1.0_224", "labels.txt")):
    download_label()
    labels = []
    input_file = open(filename, 'r')
    for i, line in enumerate(input_file):
        word = line.strip()
        label = word.split(":")[-1]
        labels.append(label)
    return labels


def download_checkpoint(multiplier, input_size):
    modelname = "mobilenet_{}_{}_{}".format(VERSION, multiplier, input_size)
    url = "https://storage.googleapis.com/mobilenet_v2/checkpoints/{}.tgz".format(modelname)
    if not os.path.exists(os.path.join(SAVEDIR, modelname)):
        print("Downloading...", url)
        os.makedirs(os.path.join(SAVEDIR, modelname))
    tar_path = os.path.join(SAVEDIR, modelname, os.path.basename(url))
    if not os.path.exists(tar_path):
        urlretrieve(url, tar_path)
        print("Extract ", tar_path)
        with tarfile.open(tar_path, mode='r') as tar:
            tar.extractall(os.path.join(SAVEDIR, modelname))


def parse_param_from_model(checkpoint):
    basename = os.path.basename(checkpoint)
    name, ext = os.path.splitext(basename)
    model, version, multiplier, input_size = name.split("_")[:4]
    return model, version, float(multiplier), int(input_size)


def clip_image(img):
    H, W, C = img.shape
    clipsize = min(H, W)
    return img[
        (H - clipsize) // 2:(H + clipsize) // 2,
        (W - clipsize) // 2:(W + clipsize) // 2
    ]
