from flask import Flask, request, Response, jsonify
import numpy as np
import os
import cv2
import json
from PIL import Image

# Initialize the Flask application
app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health(): 
    response = {'okay!': 'health check up'}
    return Response(response=response, status=200, mimetype="application/json")

# route http posts to this method
@app.route('/', methods=['POST'])
def test():
    r = request
    # convert string of image data to uint8

    # print("um the request is:", request.data)

    f = request.files
    print("files" , f)
    a = request.args
    print("args", a)
    j = request.json
    print("json", j)


    img = request.args.get('img.jpeg')


    # files = request.files.getlist('file[]')

    # print("files are", files)
    # print('length of files are ', len(files))

    # for file in files: 

    # Read the image via file.stream
    # img = Image.open(file.stream)
    im = np.asarray(img)
    print("the image image array of np of the image is: ", im)

    # write img to file, do some DL function etc ...
    print('here')
    saveImageToFolder(im)

    response = {'message': 'image received. size='}
    return jsonify(response)

def saveImageToFolder(img): 
    save_path = '/Users/justindulay/Downloads/'
    file_name = "img-test.png"
    completeName = os.path.join(save_path, file_name)

    print("the complete name is ", completeName)

    cv2.imwrite(completeName, img)

def doSomeComputerVisionThing(): 
    pass

# # start flask app
if __name__ == "__main__":
    app.run(host="192.168.1.109", port=3000)
