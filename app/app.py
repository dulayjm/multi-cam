from flask import Flask, request, Response
import numpy as np
import cv2

# Initialize the Flask application
app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health(): 
    response = {'message': 'health check up'}
    return Response(response=response, status=200, mimetype="application/json")

# route http posts to this method
@app.route('/', methods=['POST'])
def test():
    r = request
    # convert string of image data to uint8
    nparr = np.fromstring(r.data, np.uint8)
    # decode image
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    print("The image is, ", img)
    # do some fancy processing here...

    # build a response dict to send back to client
    response = {'message': 'image received. size={}x{}'.format(img.shape[1], img.shape[0])
                }

    print("the response is: ", response)
    # maybe have to encode the response ...

    return Response(response=response, status=200, mimetype="application/json")


# start flask app
if __name__ == "__main__":
    app.run(host="192.168.1.109", port=5000)