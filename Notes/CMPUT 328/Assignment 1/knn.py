'''
Name:Sanad Masannat
ccid:sanad
CMPUT 328 Assignment 1

'''
def knn(x_train, y_train, x_test, n_classes, device):
    """
    x_train: 60000 x 784 matrix: each row is a flattened image of an MNIST digit
    y_train: 60000 vector: label for x_train
    x_test: 1000 x 784 testing images
    n_classes: no. of classes in the classification task
    device: pytorch device on which to run the code
    return: predicted y_test which is a 1000-sized vector
    """
    """
    x_train: 60000 x 784 matrix: each row is a flattened image of an MNIST digit
    y_train: 60000 vector: label for x_train
    x_test: 5000 x 784 testing images
    return: predicted y_test which is a 5000 vector

    """
    k_val = 5
    #Converting Numpy-->Tensor and changing them to type float32 and using the 
    #device passed to set the tensor to said device
    
    tens_x=torch.as_tensor(x_train,device=device,dtype=torch.float32)
    tens_y=torch.as_tensor(y_train,device=device,dtype=torch.float32)
    tens_test=torch.as_tensor(x_test,device=device,dtype=torch.float32)

    #torch.Size([60000, 784]) torch.Size([60000]) torch.Size([1000, 784])
    #Num of images we have are 1000

    numOfImages=tens_test.shape[0]
    y_test=np.zeros(numOfImages) #Create the output np using the num of images

    #Looping through all individual images in test set whose exact number is gotten
    #through using .shape. We then get the distances using the euclidean/normal distance
    #and finds the smallest k distances  which we find using topk. We then gather the 
    #labels of this smallest k-distances
    #We then create a one-hot vector with size k x 10 (in this case 5). And set the values to one
    #Where we found said k labels.  We then sum the columns and get the largest col value
    #And set it to the output np array

    for i in range(0,numOfImages):
      dist=torch.abs(torch.norm(tens_x- tens_test[i],dim=1))
      values,indicies=torch.topk(dist,k_val,largest=False)
      classes=torch.gather(tens_y,index=indicies,dim=0).to(int)
      classes=classes[:,None]
      onehotvec=torch.zeros((k_val,10),device=device,dtype = torch.float32)
      onehotvec.scatter_(1,classes,1)
      y_test[i]=torch.argmax(torch.sum(onehotvec,dim=0))
    return y_test
