import darknet
import numpy as np
import array as array
import cv2
import np_opencv_module as npcv




if __name__ == "__main__":

	A = cv2.imread("./health_check.png");
	net = darknet.Net("./yolo.net", "./yolo.weights")
	print net.process(A,0.5)

