import torch.nn as nn
import torch
import torch.nn.functional as F


class A4NetBuiltin(nn.Module):
    def __init__(self, loss_type, num_classes):
        super(A4NetBuiltin, self).__init__()

        self.loss_type = loss_type
        self.num_classes = num_classes
        self.fc1 = nn.Linear(28*28, 100)
        self.fc2 = nn.Linear(100, 50)
        self.fc3 = nn.Linear(50, 10)

    def params_and_grads(self):
        params = list(self.parameters())

        grads = [param.grad for param in params]

        return params, grads

    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = torch.tanh(self.fc1(x))
        x=self.fc2(x)
        x = x- 0.2*torch.sin(x)
        x = self.fc3(x)

        return x

    def get_loss(self, output, target):
      if self.loss_type=="ce":
        loss = nn.functional.cross_entropy(output,target.float())
      else:
        loss = nn.functional.mse_loss(output,F.one_hot(target,self.num_classes).float())
      return loss

    def backward_pass(self, loss, x, output, target):
        loss.backward()
