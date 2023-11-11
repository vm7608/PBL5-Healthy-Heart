# import the necessary packages
from fastapi import FastAPI
import uvicorn
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import matplotlib.pyplot as plt
from fastapi.responses import HTMLResponse
from fastapi.responses import FileResponse

import matplotlib.pyplot as plt
import numpy as np
import neurokit2 as nk
import os
import os.path as osp
import cv2

from albumentations import Compose, Normalize
from albumentations.pytorch.transforms import ToTensorV2
import numpy as np
import onnxruntime
import cv2
import os
import onnx

from sklearn.preprocessing import scale

# config the firebase
cred = credentials.Certificate("my-second-776e4-firebase-adminsdk-ckvvx-3a1d1ab5ab.json")
app = FastAPI()

firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://my-second-776e4-default-rtdb.europe-west1.firebasedatabase.app/'
})


# check if device is running
@app.get("/isrunning")
async def isrunning():
    ref = db.reference('run')
    dataDict = ref.get()
    if dataDict == 0:
        return {"message": False}
    else:
        return {"message": True}


# save data from firebase to data.npy
def savedata():
    ref = db.reference('data')
    data = ref.get()
    dataDict = data.split(",")
    dataDict = [int(i) for i in dataDict]
    npArray = np.array(dataDict)
    # delete the old data.npy file
    if os.path.exists('model/data.npy'):
        os.remove('model/data.npy')
    # save dataDict to a numpy array file name data.npy
    np.save('model/data.npy', npArray)


# get npy file after measuring
# input folder name and file name
@app.get("/getnpy")
async def getnpy(folder: str, filename: str):
    path = 'testdata/' + folder + '/' + filename + '.npy'
    ref = db.reference('data')
    data = ref.get()
    dataDict = data.split(",")
    dataDict = [int(i) for i in dataDict]
    npArray = np.array(dataDict)
    np.save(path, npArray)
    return {
        "path": path,
        "length": len(npArray),
        "message": "success"}

# count the BPM from data.npy
def countBPM():
    bpm = 0
    sr = 33  # sample freq
    signal = np.load('model/data.npy')
    signal = signal

    _, rpeaks = nk.ecg_peaks(signal, sampling_rate=sr)
    _, waves_peak = nk.ecg_delineate(signal, rpeaks, sampling_rate=sr, method="peak")

    rpeaks = rpeaks['ECG_R_Peaks'].astype(int)
    time = len(signal) / sr
    bpm = len(rpeaks) / time * 60
    bpm = int(bpm)
    return bpm


# get the BPM result from Model
@app.get("/getbpm")
async def getbpm():
    savedata()
    check_valid_data = checkvaliddata()
    if check_valid_data == False:
        return {
            "success": False,
            "bpm": "Invalid BPM"}

    bpm = countBPM()
    min_bpm = 40
    max_bpm = 130
    if (bpm < min_bpm or bpm > max_bpm):
        return {
            "success": False,
            "bpm": "Invalid BPM"}
    else:
        return {
            "success": True,
            "bpm": bpm
        }


def plotIMG(signal, filename, image_size, figsize):
    plt.figure(figsize=figsize, frameon=False)
    plt.axis("off")
    plt.subplots_adjust(top=1, bottom=0, right=1, left=0, hspace=0, wspace=0)
    # plt.margins(0, 0) # use for generation images with no margin
    plt.plot(signal)
    plt.savefig(filename)
    plt.close()
    im_gray = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    im_gray = cv2.resize(im_gray, image_size, interpolation=cv2.INTER_LANCZOS4)
    cv2.imwrite(filename, im_gray)
import shutil

def convert_to_image():
    sr = 33  # sample freq
    signal = np.load('model/data.npy')
    signal = signal
    _, rpeaks = nk.ecg_peaks(signal, sampling_rate=sr)
    _, waves_peak = nk.ecg_delineate(signal, rpeaks, sampling_rate=sr, method="peak")

    rpeaks = rpeaks['ECG_R_Peaks'].astype(int)
    MIN_DIFF = 13
    rpeak_ranges = []
    for peak in rpeaks:
        rpeak_ranges.append(signal[peak:peak + MIN_DIFF])

    rpeak_ranges = np.stack(rpeak_ranges[:-1], axis=0)
    for i in range(len(rpeak_ranges)):
        max_idx_rel = np.argmax(rpeak_ranges[i])
        rpeaks[i] = rpeaks[i] + max_idx_rel

    labels = ['poi'] * len(rpeaks)

    mode = 24
    image_size = 128

    # dpi fix
    fig = plt.figure(frameon=False)
    dpi = fig.dpi

    # fig size / image size
    figsize = (image_size / dpi, image_size / dpi)
    image_size = (image_size, image_size)

    # save to folder
    # delete the old output folder

    shutil.rmtree('model/output')
    if not os.path.exists('model/output'):
        print("Creating output folder")
    os.makedirs('model/output')

    for i, (label, peak) in enumerate(zip(labels, rpeaks)):
        if isinstance(mode, int):
            left, right = peak - mode // 2, peak + mode // 2
        else:
            raise Exception("Wrong mode in script beginning")

        if np.all([left > 0, right < len(signal)]):
            datadir = 'model/output'
            filename = osp.join(datadir, "{}.png".format(peak))
            plotIMG(signal[left:right], filename, image_size, figsize)


def checkvaliddata():
    # load the data.npy file
    signal = np.load('model/data.npy')
    # return number of eachs unique value
    unique, counts = np.unique(signal, return_counts=True)
    # print number of value that bigger than 1000
    up_outlier = np.count_nonzero(signal > 1000)
    # print number of value that smaller than 100
    bot_outlier = np.count_nonzero(signal < 100)

    if (up_outlier + bot_outlier) < 400:
        return True
    else:
        return False

def convert_to_image2(filename):
    sr = 33  # sample freq
    signal = np.load(filename)
    signal = signal
    _, rpeaks = nk.ecg_peaks(signal, sampling_rate=sr)
    _, waves_peak = nk.ecg_delineate(signal, rpeaks, sampling_rate=sr, method="peak")

    rpeaks = rpeaks['ECG_R_Peaks'].astype(int)
    MIN_DIFF = 13
    rpeak_ranges = []
    for peak in rpeaks:
        rpeak_ranges.append(signal[peak:peak + MIN_DIFF])

    rpeak_ranges = np.stack(rpeak_ranges[:-1], axis=0)
    for i in range(len(rpeak_ranges)):
        max_idx_rel = np.argmax(rpeak_ranges[i])
        rpeaks[i] = rpeaks[i] + max_idx_rel

    labels = ['poi'] * len(rpeaks)

    mode = 24
    image_size = 128

    # dpi fix
    fig = plt.figure(frameon=False)
    dpi = fig.dpi

    # fig size / image size
    figsize = (image_size / dpi, image_size / dpi)
    image_size = (image_size, image_size)

    # save to folder
    # delete the old output folder

    shutil.rmtree('model/output2')
    if not os.path.exists('model/output2'):
        print("Creating output2folder")
    os.makedirs('model/output2')

    for i, (label, peak) in enumerate(zip(labels, rpeaks)):
        if isinstance(mode, int):
            left, right = peak - mode // 2, peak + mode // 2
        else:
            raise Exception("Wrong mode in script beginning")

        if np.all([left > 0, right < len(signal)]):
            datadir = 'model/output2'
            filename = osp.join(datadir, "{}.png".format(peak))
            plotIMG(signal[left:right], filename, image_size, figsize)


@app.get("/testreal")
async def testreal():
    # read all npy file in realdata folder then convert to image and save to output folder
    final_rs = {}
    model = load_model('model/modelpbl.h5')
    for filename in os.listdir('model/realdata'):
        result = {}
        convert_to_image2('model/realdata/' + filename)
        # load modelclear

        # change the name of model here

        # load all images in a directory
        loaded_images = list()
        for filename1 in os.listdir('model/output2'):
            # load image
            img = load_img('model/output2/' + filename1, color_mode="grayscale", target_size=(128, 128))
            # convert to array
            img = img_to_array(img)
            # scale pixel values to [0, 1]
            img = img.astype('float32')
            img = img / 255.0
            # store
            loaded_images.append(img)

        # create a numpy array
        loaded_images = np.asarray(loaded_images)

        # predict
        yhat = model.predict(loaded_images)
        labels = np.argmax(yhat, axis=1)
        # 0. N - Normal
        # 1. V - PVC (Premature ventricular contraction)
        # 2. \ - PAB (Paced beat)
        # 3. R - RBB (Right bundle branch)
        # 4. L - LBB (Left bundle branch)
        # 5. A - APB (Atrial premature beat)
        result["NOR"] = round(np.count_nonzero(labels == 0) / len(labels) * 100, 2)
        result["PVC"] = round(np.count_nonzero(labels == 1) / len(labels) * 100, 2)
        result["PAB"] = round(np.count_nonzero(labels == 2) / len(labels) * 100, 2)
        result["RBB"] = round(np.count_nonzero(labels == 3) / len(labels) * 100, 2)
        result["LBB"] = round(np.count_nonzero(labels == 4) / len(labels) * 100, 2)
        result["APB"] = round(np.count_nonzero(labels == 5) / len(labels) * 100, 2)
        final_rs[filename] = result

    return {
        "success": True,
        "result": final_rs
    }





from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.image import load_img, img_to_array
@app.get("/predict")
async def predict():
    try:
        savedata()
        check_valid = checkvaliddata()
        temp = countBPM()
        if check_valid == False or temp < 26:
            print("Invalid Data")
            return {
                "success": False,
                "result": "Invalid Data"
            }

        convert_to_image()

        # load model
        # change the name of model here
        model = load_model('model/modelpbl.h5')

        # load all images in a directory
        loaded_images = list()
        for filename in os.listdir('model/output'):
            # load image
            img = load_img('model/output/' + filename, color_mode="grayscale", target_size=(128, 128))
            # convert to array
            img = img_to_array(img)
            # scale pixel values to [0, 1]
            img = img.astype('float32')
            img = img / 255.0
            # store
            loaded_images.append(img)

        # create a numpy array
        loaded_images = np.asarray(loaded_images)

        # predict
        yhat = model.predict(loaded_images)
        labels = np.argmax(yhat, axis=1)
        # 0. N - Normal
        # 1. V - PVC (Premature ventricular contraction)
        # 2. \ - PAB (Paced beat)
        # 3. R - RBB (Right bundle branch)
        # 4. L - LBB (Left bundle branch)
        # 5. A - APB (Atrial premature beat)

        return {
            "success": True,
            "numberofbeats": len(labels),
            "result": {
                "NOR": round(np.count_nonzero(labels == 0) / len(labels) * 100, 2),
                "PVC": round(np.count_nonzero(labels == 1) / len(labels) * 100, 2),
                "PAB": round(np.count_nonzero(labels == 2) / len(labels) * 100, 2),
                "RBB": round(np.count_nonzero(labels == 3) / len(labels) * 100, 2),
                "LBB": round(np.count_nonzero(labels == 4) / len(labels) * 100, 2),
                "APB": round(np.count_nonzero(labels == 5) / len(labels) * 100, 2),
            },
            "bpm": countBPM()
        }
    except Exception as e:
        print(e)
        return {
            "success": False,
            "result": "Invalid Data"
        }

# make a function that will be start when the server start
import socket
@app.on_event("startup")
async def set_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(0)
    try:
        # doesn't even have to be reachable
        s.connect(('10.254.254.254', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()

    ref = db.reference('ip')
    # set ref to IP
    ref.set(IP)
    ref.set(IP)
    print(IP)

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=80, reload=True)
    # uvicorn main:app --host 0.0.0.0 --port 80
