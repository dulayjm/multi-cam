# multi-cam

Hi there. This the official repository for the multi-cam app. It is a multi-purpose comoputer vision iOS application that takes advangtage of the multiple cameras and sensors, specifically on the iPhone 12 pro (and greater, eventually, *hopefully*.).

This repository is setup in two parts: 
- `multi-cam`, which primarily deals with front-end, Swift and Objective-C code. 
- `server`, which entails a work-in-progress set of server code that acts as an API with the app
# iOS Setup 

### System Capabilities 
macOS: 
- 10 or greater
- simulator **will work for everything except for LiDAR portion**
- iPhone 11 or greater *12 pro or greater for LiDAR portion*

### Running the Program 
Below are the steps to running this. It is a bit abnormal than running other types of programs, 
so please bear with us! This works assuming you are running on macOS. 

1. Clone the [repository](https://github.com/dulayjm/multi-cam)
2. > cd multi-cam 
3. > xed .
4. click the run button at the top left

Now, XCode should load the application. 

5. To make changes and to run on different devices, you will need an [apple developer account](https://developer.apple.com/). 
6. Once you have this, you'll have to double click the blue app developer logo with 'multi-cam' next to it in the ribbon. 
7. From there, add a team and sign in to your developer account. 

# iOS Features

- multi-cam capture. When the user presses the main capture button in the camera window, the phone will collect three different users. The user can save or discard any of them to both the local memory collection and to their local device.
- Timed Capture. This side button to the camera operates the previous, but on timed intervals of one-second increments. In addition to this, it also can request data to be sent to WIP server code. 
- Top-k Colors Extractor. In every photo taken, the app calculates the top colors within an image based upon average hue in HSV-space and above a brightness threshold
- LiDAR Depth Estimator. The app uses a native LiDAR-enabled depth estimator to capture landscapes. In addition, it has a customable exportable format that uses a point-cloud estimation based upon the mesh generated from the program. 

# Server Setup

1. > cd <to original directory>
2. > python -m venv env
3. > source env/bin/activate
4. > pip install requirements.txt
5. > python server.py

# Server Features

- REST API towards client application
- Download and categorize the received image
- Easy potential for ML models, etc, to implement