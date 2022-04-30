import cv2 as cv
import mediapipe as mp
import numpy as np
import time
import matplotlib.pyplot as plt
import seaborn as sns
import mapping
import csv
import imageio

class poseDetector():
    # def __init__(self, mode=False, upBody = False, smooth = True, detectionCon = 0.5, trackCon = 0.5):
    def __init__(self,
                 mode=False,
                 model_complexity=1,
                 smooth=True,
                 enable_segmentation=False,
                 smooth_segmentation=True,
                 detectionCon=0.5,
                 trackCon=0.5):
        '''
        Initialize the poseDetector
        '''
        self.mode = mode
        self.model_complexity = model_complexity
        # self.upBody = upBody
        self.smooth = smooth
        self.enable_segmentation = enable_segmentation
        self.smooth_segmentation = smooth_segmentation
        self.detectionCon = detectionCon
        self.trackCon = trackCon

        self.mpDraw = mp.solutions.drawing_utils
        self.mpPose = mp.solutions.pose
        # self.pose = self.mpPose.Pose(self.mode, self.upBody, self.smooth, self.detectionCon, self.trackCon)
        self.pose = self.mpPose.Pose(self.mode, self.model_complexity, self.smooth, self.enable_segmentation, self.smooth_segmentation, self.detectionCon, self.trackCon)


    def findPose(self, img, draw = True):
        '''
        findPose takes in the img you want to find the pose in, and whether or not you
        want to draw the pose (True by default).
        '''
        imgRGB = cv.cvtColor(img, cv.COLOR_BGR2RGB) #convert BGR --> RGB as openCV uses BGR but mediapipe uses RGB
        imgRGB.flags.writeable = False
        self.results = self.pose.process(imgRGB) # store our results to the results object
        if self.results.pose_landmarks and draw: # if there are pose landmarks in our results object and draw was set to True
            self.mpDraw.draw_landmarks(img, self.results.pose_landmarks, self.mpPose.POSE_CONNECTIONS, self.mpDraw.DrawingSpec(color = (255, 255, 255), thickness = 2, circle_radius = 2), self.mpDraw.DrawingSpec(color = (35, 176, 247), thickness = 2, circle_radius = 2)) #draw them

        return img #returns the image

    
    def findPosition(self, img, draw=True):
        '''
        Takes in the image and returns a list of the landmarks
        '''
        lmList = []
        if self.results.pose_landmarks:
            for id, lm in enumerate(self.results.pose_landmarks.landmark): #for each landmark
                h, w, c = img.shape #grab the image shape
                cx, cy = int(lm.x * w), int(lm.y * h) # set cx and cy to the landmark coordinates
                # lmList.append([id, cx, cy]) #append the landmark id, the x coord and the y coord
                lmList.append(cx) # just looking for x coordinate
                if draw:
                    cv.circle(img, (cx,cy), 5, (0, 0, 255), cv.FILLED) #if we want to draw, then draw
        return lmList #returns the list of landmarks


    def findAngle(self, p1, p2, p3):
        '''
        takes in three points and returns the angle between them
        '''
        self.p1 = np.array(p1) # start point
        self.p2 = np.array(p2) # mid point
        self.p3 = np.array(p3) # end point
        
        radians = np.arctan2(self.p3[2]-self.p2[2], self.p3[1]-self.p2[1]) - np.arctan2(self.p1[2]-self.p2[2], self.p1[1]-self.p2[1]) #trig
        angle = np.abs(radians*180.0/np.pi) 
        
        if angle >180.0:
            angle = 360-angle
            
        return angle



def main():
    saveCSV = False
    vid = cv.VideoCapture('videos/small_run.MOV') #open up the video
    detector = poseDetector() #create new detector object
    pTime = 0 #set our start time (this is for the fps counter)

    timeSeries = []
    # angleSeries = []
    leftAnkle = []
    rightAnkle = []
    image_lst = []
    frame = 0
    while True: #infinite loop
        frame += 1
        success, img = vid.read() #read the image
        try:
            img = detector.findPose(img) #update image with findPose
        except:
            break
        
        lmList = detector.findPosition(img, True) #get the landmarks list

        if lmList:
            leftAnkle.append(lmList[mapping.landmarks["left_ankle"]])
            rightAnkle.append(lmList[mapping.landmarks["right_ankle"]])
        else:
            leftAnkle.append(-1)
            rightAnkle.append(-1)
        # angle = detector.findAngle(
        #     lmList[mapping.landmarks["right_hip"]],
        #      lmList[mapping.landmarks["right_knee"]],
        #       lmList[mapping.landmarks["right_ankle"]]
        #     ) #calculate the angle between three points
            #not the best way to call the landmarks, but not the highest priority to deal with rn

        timeSeries.append(frame * (1/ 30))
        # angleSeries.append(angle)
        


        cTime = time.time() # update 2nd time
        fps = 1 / (cTime - pTime) #calculate the fps
        pTime = cTime #update the first time

        # if angle > 90: #this just writes the knee angle to the screen
        #     cv.putText(img, "Left Elbow Angle:", (10, 100), cv.FONT_HERSHEY_PLAIN, 2, (255,255,255), 2)
        #     cv.putText(img, str(np.round(angle)), (10, 150), cv.FONT_HERSHEY_PLAIN, 2, (255,255,255), 2)
        # else:
        #     cv.putText(img, "Left Elbow Angle:", (10, 100), cv.FONT_HERSHEY_PLAIN, 2, (21, 26, 171), 2)
        #     cv.putText(img, str(np.round(angle)), (10, 150), cv.FONT_HERSHEY_PLAIN, 2, (21, 26, 171), 2)

        cv.putText(img, "Time: ", (10, 50), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        cv.putText(img, str(np.round(frame * (1/30), 2)), (100, 50), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        cv.putText(img, "Frame: ", (10, 100), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)
        cv.putText(img, str(int(frame)), (120, 100), cv.FONT_HERSHEY_PLAIN, 2, (0, 0, 255), 2)

        cv.imshow("Skating", img) #display our image
        image_lst.append(img)
        key = cv.waitKey(1)
        if key == ord('q') or key == ord(' '):
            break
        if key == ord('p'):
            cv.waitKey(-1) #wait until any key is pressed


    cv.destroyAllWindows()

    with imageio.get_writer("skate.gif", mode="I") as writer:
        for idx, frame in enumerate(image_lst):
            print("Adding frame to GIF file: ", idx + 1)
            writer.append_data(frame)
    if saveCSV:
        with open('smallRun.csv', 'w', newline='') as myfile:
            wr = csv.writer(myfile, quoting=csv.QUOTE_ALL)
            wr.writerow(leftAnkle)
            wr.writerow(rightAnkle)
            wr.writerow(timeSeries)

    # sns.lineplot(timeSeries, leftAnkle)
    # plt.show()

    # print(lmList.NOSE)

if __name__ == "__main__":
    main()