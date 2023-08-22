import numpy as np
import torch
import cv2
import torchvision



def classify_and_detect(images):
    """

    :param np.ndarray images: N x 12288 array containing N 64x64x3 images flattened into vectors
    :return: np.ndarray, np.ndarray
    """
    #Used Yolov5. Followed this guide here https://medium.com/mlearning-ai/training-yolov5-custom-dataset-with-ease-e4f6272148ad
    N = images.shape[0]

      
      


    

    # pred_class: Your predicted labels for the 2 digits, shape [N, 2]
    pred_class = np.empty((N, 2), dtype=np.int32)
    # pred_bboxes: Your predicted bboxes for 2 digits, shape [N, 2, 4]
    pred_bboxes = np.empty((N, 2, 4), dtype=np.float64)

    # add your code here to fill in pred_class and pred_bboxes
    images=np.reshape(images,(N,64,64,3))
    model=torch.hub.load('ultralytics/yolov5','custom', "model.pt")

    #[ymin,xmin,ymax,xmax]
    for i in range(0,N):
      output=model(images[i])
      if output.xyxy[0].shape[0]>=2:
        if output.xyxy[0][0][5]<output.xyxy[0][1][5]:
          pred_class[i][0]=(output.xyxy[0][0][5])
          pred_class[i][1]=(output.xyxy[0][1][5])
          pred_bboxes[i][0][0]=np.rint(output.xyxy[0][0][1].cpu())
          pred_bboxes[i][0][1]=np.rint(output.xyxy[0][0][0].cpu())
          pred_bboxes[i][0][2]=np.rint(output.xyxy[0][0][3].cpu())
          pred_bboxes[i][0][3]=np.rint(output.xyxy[0][0][2].cpu())
          pred_bboxes[i][1][0]=np.rint(output.xyxy[0][1][1].cpu())
          pred_bboxes[i][1][1]=np.rint(output.xyxy[0][1][0].cpu())
          pred_bboxes[i][1][2]=np.rint(output.xyxy[0][1][3].cpu())
          pred_bboxes[i][1][3]=np.rint(output.xyxy[0][1][2].cpu())
        else: 
          pred_class[i][0]=(output.xyxy[0][1][5])
          pred_class[i][1]=(output.xyxy[0][0][5])
          pred_bboxes[i][0][0]=np.rint(output.xyxy[0][1][1].cpu())
          pred_bboxes[i][0][1]=np.rint(output.xyxy[0][1][0].cpu())
          pred_bboxes[i][0][2]=np.rint(output.xyxy[0][1][3].cpu())
          pred_bboxes[i][0][3]=np.rint(output.xyxy[0][1][2].cpu())
          pred_bboxes[i][1][0]=np.rint(output.xyxy[0][0][1].cpu())
          pred_bboxes[i][1][1]=np.rint(output.xyxy[0][0][0].cpu())
          pred_bboxes[i][1][2]=np.rint(output.xyxy[0][0][3].cpu())
          pred_bboxes[i][1][3]=np.rint(output.xyxy[0][0][2].cpu())    
      elif output.xyxy[0].shape[0]==1:
        pred_class[i][0]=(output.xyxy[0][0][5])
        pred_class[i][1]=(output.xyxy[0][0][5])
        pred_bboxes[i][0][0]=np.rint(output.xyxy[0][0][1].cpu())
        pred_bboxes[i][0][1]=np.rint(output.xyxy[0][0][0].cpu())
        pred_bboxes[i][0][2]=np.rint(output.xyxy[0][0][3].cpu())
        pred_bboxes[i][0][3]=np.rint(output.xyxy[0][0][2].cpu())
        pred_bboxes[i][1][0]=np.rint(output.xyxy[0][0][1].cpu())
        pred_bboxes[i][1][1]=np.rint(output.xyxy[0][0][0].cpu())
        pred_bboxes[i][1][2]=np.rint(output.xyxy[0][0][3].cpu())
        pred_bboxes[i][1][3]=np.rint(output.xyxy[0][0][2].cpu())
      else:#If not classified
        pred_class[i][0]=0
        pred_class[i][1]=0
        pred_bboxes[i][0][0]=0
        pred_bboxes[i][0][1]=0
        pred_bboxes[i][0][2]=28
        pred_bboxes[i][0][3]=28
        pred_bboxes[i][1][0]=0
        pred_bboxes[i][1][1]=0
        pred_bboxes[i][1][2]=28
        pred_bboxes[i][1][3]=28




    return pred_class, pred_bboxes
