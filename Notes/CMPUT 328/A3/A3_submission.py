# -*- coding: utf-8 -*-
"""Assignment-3 Logistic Regression
CCID:sanad
Name:Sanad Masannat
Student ID: 1626221

"""
import torch
from torchvision import transforms, datasets
import numpy as np
import timeit
from collections import OrderedDict
from pprint import pformat
from tqdm import tqdm
from torch.utils.data import DataLoader
import torch.optim as optim
from torch import nn as nn

torch.multiprocessing.set_sharing_strategy('file_system')

def compute_score(acc, min_thres, max_thres):
    if acc <= min_thres:
        base_score = 0.0
    elif acc >= max_thres:
        base_score = 100.0
    else:
        base_score = float(acc - min_thres) / (max_thres - min_thres) \
                     * 100
    return base_score


      #Load MNIST Datasets
MNIST_training = datasets.MNIST('/MNIST_dataset/', train=True, download=True,
                                transform=transforms.Compose([
                                  transforms.ToTensor(),
                                  transforms.Normalize((0.1307,), (0.3081,))]))

MNIST_test_set = datasets.MNIST('/MNIST_dataset/', train=False, download=True,
                                transform=transforms.Compose([
                                  transforms.ToTensor(),
                                  transforms.Normalize((0.1307,), (0.3081,))]))

    # create a training and a validation set from out MNIST training set
MNIST_training_set, MNIST_validation_set = torch.utils.data.random_split(MNIST_training, [48000, 12000])

    # Create MNIST data loaders
MNIST_train_loader = torch.utils.data.DataLoader(MNIST_training_set,batch_size=124, shuffle=True)

MNIST_validation_loader = torch.utils.data.DataLoader(MNIST_validation_set,batch_size=124, shuffle=True)

MNIST_test_loader = torch.utils.data.DataLoader(MNIST_test_set,batch_size=1, shuffle=True)

    # CIFAR-10 test set loading

CIFAR10_training = datasets.CIFAR10(root='./data', train=True,
                                            download=True, transform=transforms.Compose([transforms.ToTensor(),transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))]))

CIFAR10_test_set = datasets.CIFAR10(root='./data', train=False,
                                          download=True, transform=transforms.Compose([transforms.ToTensor(),transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5))]))

    #Split into training and validation for CIFAR10

CIFAR10_training_set, CIFAR10_validation_set = torch.utils.data.random_split(CIFAR10_training, [38000, 12000])




    # Create data loaders for CIFAR10
CIFAR10_train_loader = torch.utils.data.DataLoader(CIFAR10_training_set,
                                              batch_size=124,
                                              shuffle=True, num_workers=2)

CIFAR10_validation_loader = torch.utils.data.DataLoader(CIFAR10_validation_set,
                                                    batch_size=124,
                                                    shuffle=True, num_workers=2)
CIFAR10_test_loader = torch.utils.data.DataLoader(CIFAR10_test_set,
                                              batch_size=1, 
                                              shuffle=False, num_workers=2)

classes = ('plane', 'car', 'bird', 'cat',
              'deer', 'dog', 'frog', 'horse', 'ship', 'truck')
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

def run(algorithm, dataset_name, filename):
    start = timeit.default_timer()
    predicted_test_labels, gt_labels = algorithm(dataset_name)
    if predicted_test_labels is None or gt_labels is None:
      return (0, 0, 0)
    stop = timeit.default_timer()
    run_time = stop - start
    
    np.savetxt(filename, np.asarray(predicted_test_labels))

    correct = 0
    total = 0
    for label, prediction in zip(gt_labels, predicted_test_labels):
      total += label.size(0)
      correct += (prediction.cpu().numpy() == label.cpu().numpy()).sum().item()   # assuming your model runs on GPU
      
    accuracy = float(correct) / total
    
    print('Accuracy of the network on the 10000 test images: %d %%' % (100 * correct / total))
    return (correct, accuracy, run_time)



# Logistic regression class
class LogisticRegression(nn.Module):
    def __init__(self,dataset_name):
        super(LogisticRegression, self).__init__()
        if dataset_name=="CIFAR10":
          self.fc = nn.Linear(3*32*32, 10)
        else:
          self.fc = nn.Linear(28*28, 10)


    def forward(self, x):
        x = x.view(x.size(0), -1)
        x = self.fc(x)
        
        return x

class One_Hot(nn.Module):
    def __init__(self, depth):
        super(One_Hot,self).__init__()
        self.depth = depth
        self.ones = torch.sparse.torch.eye(depth).to(device)
    def forward(self, X_in):
        X_in = X_in.long()
        return self.ones.index_select(0,X_in.data)
    def __repr__(self):
        return self.__class__.__name__ + "({})".format(self.depth)


def MNIST_train(epoch,logistic_model,device,optimizer):
  logistic_model.train()
  for batch_idx, (data, target) in enumerate(MNIST_train_loader):
    data = data.to(device)
    target = target.to(device)
    optimizer.zero_grad()
    output = logistic_model(data)
    #https://androidkt.com/how-to-add-l1-l2-regularization-in-pytorch-loss-function/
    loss = nn.functional.cross_entropy(output,target)+sum(weights.abs().sum()for weights in logistic_model.parameters())*1.5e-3#Setting up loss
    loss.backward()
    optimizer.step()
    if batch_idx % 100 == 0:
      print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
        epoch, batch_idx * len(data), len(MNIST_train_loader.dataset),
        100. * batch_idx / len(MNIST_train_loader), loss.item()))

def CIFAR10_train(epoch,logistic_model,device,optimizer):
  logistic_model.train()
  for batch_idx, (data, target) in enumerate(CIFAR10_train_loader):
    data = data.to(device)
    target = target.to(device)
    optimizer.zero_grad()
    output = logistic_model(data)
    loss = nn.functional.cross_entropy(output,target)+sum(weights.abs().sum()for weights in logistic_model.parameters())*1.15e-3
    loss.backward()
    optimizer.step()
    if batch_idx % 100 == 0:
      print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
        epoch, batch_idx * len(data), len(CIFAR10_train_loader.dataset),
        100. * batch_idx / len(CIFAR10_train_loader), loss.item()))


def MNIST_validation(logistic_model,device):
  logistic_model.eval()
  validation_loss = 0
  correct = 0
  with torch.no_grad(): # notice the use of no_grad
    for data, target in MNIST_validation_loader:
      data = data.to(device)
      target = target.to(device)
      output = logistic_model(data)
      pred = output.data.max(1, keepdim=True)[1]
      correct += pred.eq(target.data.view_as(pred)).sum()
      validation_loss += (nn.functional.cross_entropy(output,target))
  validation_loss /= len(MNIST_validation_loader.dataset)
  print('\nValidation set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(validation_loss, correct, len(MNIST_validation_loader.dataset), 100. * correct / len(MNIST_validation_loader.dataset)))




def CIFAR10_validation(logistic_model,device):
  logistic_model.eval()
  validation_loss = 0
  correct = 0
  with torch.no_grad(): # notice the use of no_grad
    for data, target in CIFAR10_validation_loader:
      data = data.to(device)
      target = target.to(device)
      output = logistic_model(data)
      pred = output.data.max(1, keepdim=True)[1]
      correct += pred.eq(target.data.view_as(pred)).sum()
      validation_loss += nn.functional.cross_entropy(output,target) #regularization
  validation_loss /= len(MNIST_validation_loader.dataset)
  print('\nValidation set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(validation_loss, correct, len(CIFAR10_validation_loader.dataset), 100. * correct / len(CIFAR10_validation_loader.dataset)))


def MNIST_test(logistic_model,device):
  logistic_model.eval()
  test_loss = 0
  correct = 0
  predict=[]
  labels=[]
  with torch.no_grad():
    for data, target in MNIST_test_loader:
      data = data.to(device)
      target = target.to(device)
      output = logistic_model(data)
      test_loss += nn.functional.cross_entropy(output,target)
      pred = output.data.max(1, keepdim=True)[1]
      correct += pred.eq(target.data.view_as(pred)).sum()
      predict.append(pred.cpu())
      labels.append(target.cpu())
  test_loss /= len(MNIST_test_loader.dataset)
  print('\nTest set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(test_loss, correct, len(MNIST_test_loader.dataset), 100. * correct / len(MNIST_test_loader.dataset)))
  return predict,labels


def CIFAR10_test(logistic_model,device):
  logistic_model.eval()
  test_loss = 0
  correct = 0
  predict=[]
  labels=[]
  with torch.no_grad():
    for data, target in CIFAR10_test_loader:
      data = data.to(device)
      target = target.to(device)
      output = logistic_model(data)
      test_loss += nn.functional.cross_entropy(output,target)
      pred = output.data.max(1, keepdim=True)[1]
      correct += pred.eq(target.data.view_as(pred)).sum()
      predict.append(pred.cpu())
      labels.append(target.cpu())
  test_loss /= len(CIFAR10_test_loader.dataset)
  print('\nTest set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(test_loss, correct, len(CIFAR10_test_loader.dataset), 100. * correct / len(CIFAR10_test_loader.dataset)))
  return predict,labels

def logistic_regression(dataset_name):
    logistic_model = LogisticRegression(dataset_name).to(device)
    optimizer = optim.Adam(logistic_model.parameters(), lr=1e-3)
    one_hot = One_Hot(10).to(device)
    if dataset_name == "MNIST":
      MNIST_validation(logistic_model,device)
      for epoch in range(1, 11):
        MNIST_train(epoch,logistic_model,device,optimizer)
        MNIST_validation(logistic_model,device)
      return1,return2=MNIST_test(logistic_model,device)
      return return1,return2
    else:
      CIFAR10_validation(logistic_model,device)
      for epoch in range(1, 11):
        CIFAR10_train(epoch,logistic_model,device,optimizer)
        CIFAR10_validation(logistic_model,device)
      return1,return2=CIFAR10_test(logistic_model,device)
      return return1,return2

def tune_hyper_parameter():
    # TODO: implement logistic regression hyper-parameter tuning here

    return None, None, None


"""Main loop. Run time and total score will be shown below."""

def run_on_dataset(dataset_name, filename):
    if dataset_name == "MNIST":
        min_thres = 0.82
        max_thres = 0.92

    elif dataset_name == "CIFAR10":
        min_thres = 0.28
        max_thres = 0.38

    correct_predict, accuracy, run_time = run(logistic_regression, dataset_name, filename)

    score = compute_score(accuracy, min_thres, max_thres)
    result = OrderedDict(correct_predict=correct_predict,
                         accuracy=accuracy, score=score,
                         run_time=run_time)
    return result, score


def main():
    filenames = { "MNIST": "predictions_mnist_YourName_IDNumber.txt", "CIFAR10": "predictions_cifar10_YourName_IDNumber.txt"}
    result_all = OrderedDict()
    score_weights = [0.5, 0.5]
    scores = []
    for dataset_name in ["MNIST","CIFAR10"]:
        result_all[dataset_name], this_score = run_on_dataset(dataset_name, filenames[dataset_name])
        scores.append(this_score)
    total_score = [score * weight for score, weight in zip(scores, score_weights)]
    total_score = np.asarray(total_score).sum().item()
    result_all['total_score'] = total_score
    with open('result.txt', 'w') as f:
        f.writelines(pformat(result_all, indent=4))
    print("\nResult:\n", pformat(result_all, indent=4))


main()
