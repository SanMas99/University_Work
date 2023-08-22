import numpy as np
#########################
#       Exercise 1      #
#########################

def generateTranslationMatrix(x, y, z):
    '''
    return the homogeneous transformation matrix for the given translation (x, y, z)
      parameter: 
        sx, sy, sz: scaling parameters for x-, y-, z-axis, respectively
      return:
        ndarray of size (4, 4)
    '''
    transMat=np.eye(4)
    #Generate identity matrix and edit third colum
    transMat[0,3]=x
    transMat[1,3]=y
    transMat[2,3]=z
    return transMat
    


def generateScalingMatrix(sx, sy, sz):
    '''
    return the homogeneous transformation matrix for the given scaling parameters (sx, sy, sz)
      parameter:
        sx, sy, sz: scaling parameters for x-, y-, z-axis, respectively
      return:
        ndarray of size (4, 4)
    '''
    #Edit the diagonals with scale factors
    scaleMat=np.zeros((4,4))
    scaleMat[0,0]=sx
    scaleMat[1,1]=sy
    scaleMat[2,2]=sz
    scaleMat[3,3]=1
    return scaleMat

def generateRotationMatrix(rad, axis):
    '''
    return the homogeneous transformation matrix for the given rotation parameters (rad, axis)
      parameter:
        rad: radians for rotation
        axis: axis for rotation, can only be one of ('x', 'y', 'z', 'X', 'Y', 'Z')
      return: 
        ndarray of size (4, 4)
    '''
    rotMat=np.eye(4,4)
    #generate the identity matrix and depending on the axis we rotate around, edit 
    #Respective values
    if axis.lower()=="z":
      rotMat[0,0]=np.cos(rad)
      rotMat[1,1]=np.cos(rad)
      rotMat[0,1]=-1*np.sin(rad)
      rotMat[1,0]=np.sin(rad)
    elif axis.lower()=="y":
      rotMat[0,0]=np.cos(rad)
      rotMat[2,2]=np.cos(rad)
      rotMat[2,0]=-1*np.sin(rad)
      rotMat[0,2]=np.sin(rad)
    else:
      rotMat[2,2]=np.cos(rad)
      rotMat[1,1]=np.cos(rad)
      rotMat[1,2]=-1*np.sin(rad)
      rotMat[2,1]=np.sin(rad)
    return rotMat




# Case 1
def part1Case1():
    # translation matrix
    t = generateTranslationMatrix(2,3,-2)
    # scaling matrix
    s = generateScalingMatrix(0.5,2,2)
    # rotation matrix
    r = generateRotationMatrix(np.pi/180*45,"z")
    # data in homogeneous coordinate
    data = np.array([2, 3, 4, 1]).T
    finalMat=np.matmul(r,np.matmul(s,t))
    data=np.matmul(finalMat,data)
    #print(data)

# Case 2
def part1Case2():
    # translation matrix
    t = generateTranslationMatrix(4,-2,3)
    # scaling matrix
    s = generateScalingMatrix(3,1,3)
    # rotation matrix
    r =  generateRotationMatrix(np.pi/180*-30,"y")
    # data in homogeneous coordinate
    data = np.array([6, 5, 2, 1]).T
    finalMat=np.matmul(r,np.matmul(t,s))
    data=np.matmul(finalMat,data)
    #print(data)

# Case 3
def part1Case3():
    # translation matrix
    t = generateTranslationMatrix(5,2,-3)
    # scaling matrix
    s = generateScalingMatrix(2,2,-2)
    # rotation matrix
    r =  generateRotationMatrix(np.pi/180*15,"x")
    # data in homogeneous coordinate
    data = np.array([3, 2, 5, 1]).T
    finalMat=np.matmul(t,np.matmul(s,r))
    data=np.matmul(finalMat,data)
    #print(data)

#########################
#       Exercise 2      #
#########################

# Part 1
def generateRandomSphere(r, n):
    '''
    generate a point cloud of n points in spherical coordinates (radial distance, polar angle, azimuthal angle)
      parameter:
        r: radius of the sphere
        n: total number of points
    return:
      spherical coordinates, ndarray of size (3, n), where the 3 rows are ordered as (radial distances, polar angles, azimuthal angles)
      
    '''
    coordinates=np.zeros((3,n))
    #Polar angles range from 0 to pi so generate n values from this range 
    #Azimuthal angles range from 0 to2 pi so generate n values from this range 
    coordinates[0,:]=r
    coordinates[1,:]=np.random.rand(n)*(np.pi)
    coordinates[2,:]=np.random.rand(n)*(2*np.pi)
    return coordinates


def sphericalToCatesian(coors):
    '''
    convert n points in spherical coordinates to cartesian coordinates, then add a row of 1s to them to convert
    them to homogeneous coordinates
      parameter:
        coors: ndarray of size (3, n), where the 3 rows are ordered as (radial distances, polar angles, azimuthal angles)
    return:
      catesian coordinates, ndarray of size (4, n), where the 4 rows are ordered as (x, y, z, 1)
    '''
    n=coors.shape[1]
    cartesian=np.ones((4,n))
    #Formula to convert from spherical to catrsian co-ordiantes are:
    #x=radial*sin(azimuthal)*cos(polar)
    #y=radial*sin(polar)*sin(azimuthal)
    #z=radial*cos(azimuthal)
    cartesian[0,:]=coors[0,:]*np.sin(coors[2,:])*np.cos(coors[1,:])
    cartesian[1,:]=coors[0,:]*np.sin(coors[2,:])*np.sin(coors[1,:])
    cartesian[2,:]=coors[0,:]*np.cos(coors[2,:])
    return cartesian

    

# Part 2
def applyRandomTransformation(sphere1):
    '''
    generate two random transformations, one of each (scaling, rotation),
    apply them to the input sphere in random order, then apply a random translation,
    then return the transformed coordinates of the sphere, the composite transformation matrix,
    and the three random transformation matrices you generated
      parameter:
        sphere1: homogeneous coordinates of sphere1, ndarray of size (4, n), 
                 where the 4 rows are ordered as (x, y, z, 1)
      return:
        a tuple (p, m, t, s, r)
        p: transformed homogeneous coordinates, ndarray of size (4, n), 
                 where the 4 rows are ordered as (x, y, z, 1)
        m: composite transformation matrix, ndarray of size (4, 4)
        t: translation matrix, ndarray of size (4, 4)
        s: scaling matrix, ndarray of size (4, 4)
        r: rotation matrix, ndarray of size (4, 4)
    '''
    #Generate a random axis from a list of array possibilities
    axis=np.random.choice(["X","x","Y","y","Z","z"])
    #Choose an order from rotation*scale or scale*rotation
    order=np.random.choice([0,1])
    #Our rad is usually in range from 0 to 2pi so we generate a number from this range
    rad=np.random.uniform(0,2*np.pi)
    #Choose random x,y,z values which range from -100 to 100
    x=np.random.uniform(-100,100)
    y=np.random.uniform(-100,100)
    z=np.random.uniform(-100,100)
    #Generate a positive scale factor
    sx=np.random.uniform(0,100)
    sy=np.random.uniform(0,100)
    sz=np.random.uniform(0,100)
    #Generate the transformation matrices and depending on the order multiply the scale and rotation matrix in a different order
    t=generateTranslationMatrix(x,y,z)
    r=generateRotationMatrix(rad,axis)
    s=generateScalingMatrix(sx,sy,sz)
    if order==0:
      m=np.matmul(t,np.matmul(r,s))
    else:
      m=np.matmul(t,np.matmul(s,r))
    #Using the composite matrix, perform the transformation
    p=np.matmul(m,sphere1)
    return tuple((p,m,t,s,r))

def calculateTransformation(sphere1, sphere2):
    '''
    calculate the composite transformation matrix from sphere1 to sphere2
      parameter:
        sphere1: homogeneous coordinates of sphere1, ndarray of size (4, n), 
                 where the 4 rows are ordered as (x, y, z, 1)
        sphere2: homogeneous coordinates of sphere2, ndarray of size (4, n), 
                 where the 4 rows are ordered as (x, y, z, 1)
    return:
      composite transformation matrix, ndarray of size (4, 4)
    '''
    #Here we aim to get the pseudoinverse of the first sphere. The reason we do this is because
    #The formula to get to sphere 2 from sphere one is Sphere2=Tansformatoin Matrix * Sphere 1
    #Recall that since both Spheres are matrices, to isolate the transformation matrix, we need to remove Sphere 1 from 
    #the RHS. To do this, we use the property that A matrix multiplied by its inverse is the Identity matrix
    # and any matrix multiplied by the identity matrix is itself. 
    #Thus we do Sphere2*SphereOneInverse=TransformationMatrix*(Sphere1*SphereOneInverse)
    #Which is equal to  Sphere2*SphereOneInverse=TransformationMatrix
    sphereinv=np.linalg.pinv(sphere1)
    transmatrix=np.matmul(sphere2,sphereinv)
    return transmatrix


def decomposeTransformation(m):
    '''
    decomposite the transformation and return the translation, scaling, and rotation matrices
      parameter:
        m: homogeneous transformation matrix, ndarray of size (4, 4)

    return:
      tuple of three matrices, (t, s, r)
        t: translation matrix, ndarray of size (4, 4)
        s: scaling matrix, ndarray of size (4, 4)
        r: rotation matrix, ndarray of size (4, 4)
    '''
    #Source:https://math.stackexchange.com/questions/237369/given-this-transformation-matrix-how-do-i-decompose-it-into-translation-rotati
    #The 4th column indicates teh translation
    t=generateTranslationMatrix(m[0,3],m[1,3],m[2,3])
    #Since we are editing the matrix but have need for m later, we make a shallow copy andedit that
    intermediate=np.copy(m)
    #Set the translation values to 0
    intermediate[0,3]=0
    intermediate[1,3]=0
    intermediate[2,3]=0
    #Depending on the order of transfomations, we get the norm for the colums and rows 
    #Then we generate the scalar matrix
    row1=np.linalg.norm(intermediate[:,0])
    row2=np.linalg.norm(intermediate[:,1])
    row3=np.linalg.norm(intermediate[:,2])
    s1=generateScalingMatrix(row1,row2,row3)
    #Since we have two possible scale factors, we have 2 different rotation matrix, so we copy the 
    #intermediate(edited m) matrix twice
    r1=np.copy(intermediate)
    r1[:,0]=intermediate[:,0]/row1
    r1[:,1]=intermediate[:,1]/row2
    r1[:,2]=intermediate[:,2]/row3
    r1[3,3]=1 
    col1=np.linalg.norm(intermediate[0,:])
    col2=np.linalg.norm(intermediate[1,:])
    col3=np.linalg.norm(intermediate[2,:])
    s2=generateScalingMatrix(col1,col2,col3)
    r2=np.copy(intermediate)
    r2[0,:]=intermediate[0,:]/col1
    r2[1,:]=intermediate[1,:]/col2
    r2[2,:]=intermediate[2,:]/col3
    r2[3,3]=1
    #Then we multiple the 2 matrices using the 2 possible combinations
    intermediate1=np.matmul(r1,s1)
    intermediate2=np.matmul(s2,r2)
    #Then we check if the two generated intermediate arrays and see if it is close
    #to the actual intermediate and if it is close to the intermediate return the respective
    #rotation and scale matrices
    if np.allclose(intermediate,intermediate1)==True:
      s=s1
      r=r1
    elif np.allclose(intermediate,intermediate2)==True:
      s=s2
      r=r2
    return tuple((t,s,r))








#########################
#      Main function    #
#########################
def main():
    part1Case1()
    part1Case2()
    part1Case3()
    coords=generateRandomSphere(3,10)
    coorsCart=sphericalToCatesian(coords)
    transtuple=applyRandomTransformation(coorsCart)
    m=calculateTransformation(coorsCart,transtuple[0])
    finaltuple=decomposeTransformation(m)




if __name__ == "__main__":
    main()