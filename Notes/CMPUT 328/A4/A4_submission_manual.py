
class A4NetManual:
    def __init__(self, loss_type, num_classes, torch_fns, device):
        self.tensor, self.zeros, \
        self.mm, self.mul, self.sum, self.mean, self.log, \
        self.sin, self.cos, self.transpose, \
        self.tanh, self.softmax, self.one_hot = torch_fns

        self.num_classes = num_classes
        self.loss_type = loss_type
        self.device = device

        self.W, self.b = self.init_weights()
        self.dW = [None, None, None]
        self.db = [None, None, None]

        self.Z=None
        self.Z1=None
        self.Z2=None
        self.Z3=None
        self.Z4=None


    # allow an object of this class to be called like a function to perform forward pass
    def __call__(self, x):
        return self.forward(x)

    def grads(self):
        return self.dW, self.db

    def parameters(self):
        return self.W, self.b

    def params_and_grads(self):
        W1, W2, W3 = self.W
        b1, b2, b3 = self.b

        dW1, dW2, dW3 = self.dW
        db1, db2, db3 = self.db

        params = [W1, b1, W2, b2, W3, b3]
        grads = [dW1, db1, dW2, db2, dW3, db3]

        return params, grads

    def init_weights(self):
        import math

        r = 0.5

        W1 = self.zeros((28 * 28, 64), device=self.device).uniform_(-r, r) / math.sqrt(28 * 28)
        b1 = self.zeros((1, 64), device=self.device)

        W2 = self.zeros((64, 32), device=self.device).uniform_(-r, r) / math.sqrt(64)
        b2 = self.zeros([1, 32], device=self.device)

        W3 = self.zeros((32, 10), device=self.device).uniform_(-r, r) / math.sqrt(32)
        b3 = self.zeros([1, 10], device=self.device)

        W = [W1, W2, W3]
        b = [b1, b2, b3]

        return W, b

    def train(self):
        pass

    def eval(self):
        pass

    def get_loss(self, output, target):
      if self.loss_type=="ce":
        loss=0
        for i in range(0,(output.size(1)-1)):
          inner_sum=0
          for j in range(0,(target.size(0)-1)):
            inner_sum+=self.mul(self.one_hot(target)[i,j],self.log(output[i,j]))
          loss+=inner_sum
        loss=(-1/target.size(0))*loss
      else:
        loss=0
        for i in range(0,output.size(1)):
          inner_sum=0
          for j in range(0,output.size(0)):
            inner_sum+=self.mul(self.one_hot(target)[i][j]-output[i][j],self.one_hot(target)[i][j]-output[i][j])
          loss+=inner_sum
        loss=(1/self.num_classes)*loss
      return loss
    def forward(self, x):
        W1, W2, W3 = self.W
        b1, b2, b3 = self.b

        X = x.view(x.size(0), -1)
        self.Z=self.mm(X,W1)+b1
        self.Z1=self.tanh(self.Z)
        self.Z2=self.mm(self.Z1,W2)+b2
        self.Z3=self.Z2-self.mul(0.2,self.sin(self.Z2))
        self.Z4=self.mm(self.Z3,W3)+b3
        output=self.softmax(self.Z4)
        return output
    def backward_pass(self, loss, x, output, target):
        '''
        self.tensor, self.zeros, \
        self.mm, self.mul, self.sum, self.mean, self.log, \
        self.sin, self.cos, self.transpose, \
        self.tanh, self.softmax, self.one_hot = torch_fns
        '''
        #Yp=output
        #Y=target
        #no onehot needed
        W1, W2, W3 = self.W
        b1, b2, b3 = self.b


        dz5=output-target
        dz4=self.mm(dz5,self.transpose(W3,0,1))
        dz3=dz4+self.mul(5,self.cos(dz4))
        dz2=self.mm(dz3,self.transpose(W2,0,1))
        dz1=1-self.mm(self.tanh(dz2),self.tanh(dz2))
        dz0=self.mm(dz1,self.transpose(W1,0,1))



        dW1 = dW2 = dW3 = None
        db1 = db2 = db3 = None

        """add your code here to compute dW1, dW2, dW3 and db1, db2, db3 so
         as to update dW and db in-place"""

         #



        self.dW[:] = dW1, dW2, dW3
        self.db[:] = db1, db2, db3
