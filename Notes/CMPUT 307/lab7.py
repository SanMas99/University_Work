import numpy as np

def distance(data, centers):
    '''
    Calculate the distances from points to cluster centers.
      parameter:
        data: nparray of shape (n, 2)
        centers: nparray of shape (m, 2)
      return:
        distance: nparray of shape (n, m)

    '''
    #Here we calcluate the Euclidean distance between the centers and data points using a vectorized approach
    distance= np.sqrt(np.sum((data[:, np.newaxis, :] - centers)**2, axis=2))
    return distance


def kmeans(data, n_centers):
    """
    Divide data into n_centers clusters, return the cluster centers and assignments.
    Assignments are the indices of the closest cluster center for the corresponding data point.
      parameter:
        data: nparray of shape (n, 2)
        n_centers: int
      return:
        centers: nparray of shape (n_centers, 2)
        assignments: nparray of shape (n,)
    """
    centers=np.zeros((n_centers,2))
    #Get a list of all possible indies then we generate some random indices without replacement here to get our clusters
    indices=np.arange(data.shape[0])
    random_indices = np.random.choice(indices, size=n_centers, replace=False)
    centers = data[random_indices]
    #The first array will be used as a comparison to know when we cshould should performing k-means
    new_centers=np.zeros((centers.shape))
    #This array will hold the assigments
    assignments=np.zeros(data.shape[0])
  
    while np.allclose(new_centers,centers)==False:
      new_centers=centers
      distances=distance(data,centers)
      #Get counts for each centers then add up all the point values to later get average
      totals=np.zeros((centers.shape))
      count=np.zeros(n_centers)
      assignments=np.argmin(distances, axis=1)
      for i in range(0,data.shape[0]):
          index=int(assignments[i])
          totals[index]+=data[i]
          count[index]+=1

      #THis loop is here to prvent division by zero as if we get a zero count, we need to keep the center as is
      for i in range(0,centers.shape[0]):
        if count[i]!=0:
          centers[i]=totals[i]/ count[i,None]

    return centers, assignments


    

def distortion(data, centers, assignments):
    """
    Calculate the distortion of the clustering.
      parameter:
        data: nparray of shape (n, 2)
        centers: nparray of shape (m, 2)
        assignments: nparray of shape (n,)
      return:
        distortion: float
    """
    distances = distance(data, centers)
    totals=np.zeros(centers.shape[0])
    #Here we get the distances and sum their squared values for each center
    for i in range(0,len(assignments)):
      index=int(assignments[i])
      totals[index]+=np.power(distances[i][index],2)
    #After that, we sum up all of the values to get a singular value 
    distortion=np.sum(totals)
    return distortion

if __name__ == "__main__":
    # test your code here
    
    data_lab=np.load("lab7.npy")
    for i in range(1,data_lab.shape[0]+1):
      centers,assignments = kmeans(data_lab,i)
      dist=distortion(data_lab,centers,assignments)