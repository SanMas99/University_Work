import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.nn.init as init


class Params:
    """
    :ivar use_gpu: use CUDA GPU for running the CNN instead of CPU

    :ivar enable_test: use the (unreleased) test instead of the validation set for evaluation after training is done

    :ivar optim_type: optimizer type: 0: SGD, 1: ADAM

    :ivar load_weights:
        0: train from scratch
        1: load and test
        2: load if it exists and continue training

    :ivar save_criterion:  when to save a new checkpoint
        0: max validation accuracy
        1: min validation loss
        2: max training accuracy
        3: min training loss

    :ivar lr: learning rate
    :ivar eps: term added to the denominator to improve numerical stability in ADAM optimizer

    :ivar valid_ratio: fraction of training data to use for validation
    :ivar valid_gap: no. of training epochs between validations

    :ivar vis: visualize the input and reconstructed images during validation and testing;
        vis=1 will only write these to tensorboard
        vis=2 will display them using opencv as well; only works for offline runs since colab doesn't support cv2.imshow
    """

    def __init__(self):
        self.use_gpu = 1
        self.enable_test = 0

        self.load_weights = 0

        self.train_batch_size = 128

        self.valid_batch_size = 24
        self.test_batch_size = 24

        self.n_workers = 1
        self.optim_type = 1
        self.lr = 1e-3
        self.momentum = 0.9
        self.n_epochs = 1000
        self.eps = 1e-8
        self.weight_decay = 0
        self.save_criterion = 0
        self.valid_gap = 1
        self.valid_ratio = 0.2
        self.weights_path = './checkpoints/model.pt'
        self.vis = 1



class Classifier(nn.Module):
    def __init__(self):
        super(Classifier, self).__init__()
        self.conv1 = nn.Conv2d(3, 10, kernel_size=5)
        self.conv2 = nn.Conv2d(10, 20, kernel_size=5)
        self.conv2_drop = nn.Dropout2d()
        self.fc1 = nn.Linear(320, 50)
        self.fc2 = nn.Linear(50, 10)
    def init_weights(self):
        for m in self.modules():
            if isinstance(m,nn.Conv2d):
                init.kaiming_normal_(m.weight,mode='fan_out')
                if m.bias is not None:
                    init.constant_(m.bias,0)
            elif isinstance(m,nn.BatchNorm2d):
                init.constant_(m.weight,1)
                init.constant_(m.bias,0)
            elif isinstance(m,nn.Linear):
                init.normal_(m.weight,std=1e-3)
                if m.bias is not None:
                    init.constant_(m.bias,0)
                
                

    def forward(self, x):
        h = x.shape[0]
        x = F.relu(F.max_pool2d(self.conv1(x), 2))
        x = F.relu(F.max_pool2d(self.conv2_drop(self.conv2(x)), 2))
        x = x.view(-1, 320)
        x = F.relu(self.fc1(x))
        x = F.dropout(x, training=self.training)
        x = self.fc2(x)
        return F.log_softmax(x)


import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.nn.init as init


class Params:
    """
    :ivar use_gpu: use CUDA GPU for running the CNN instead of CPU

    :ivar enable_test: use the (unreleased) test instead of the validation set for evaluation after training is done

    :ivar optim_type: optimizer type: 0: SGD, 1: ADAM

    :ivar load_weights:
        0: train from scratch
        1: load and test
        2: load if it exists and continue training

    :ivar save_criterion:  when to save a new checkpoint
        0: max validation accuracy
        1: min validation loss
        2: max training accuracy
        3: min training loss

    :ivar lr: learning rate
    :ivar eps: term added to the denominator to improve numerical stability in ADAM optimizer

    :ivar valid_ratio: fraction of training data to use for validation
    :ivar valid_gap: no. of training epochs between validations

    :ivar vis: visualize the input and reconstructed images during validation and testing;
        vis=1 will only write these to tensorboard
        vis=2 will display them using opencv as well; only works for offline runs since colab doesn't support cv2.imshow
    """

    def __init__(self):
        self.use_gpu = 1
        self.enable_test = 0

        self.load_weights = 0

        self.train_batch_size = 128

        self.valid_batch_size = 24
        self.test_batch_size = 24

        self.n_workers = 1
        self.optim_type = 1
        self.lr = 1e-3
        self.momentum = 1.5
        self.n_epochs = 1000
        self.eps = 1e-8
        self.weight_decay = 0
        self.save_criterion = 0
        self.valid_gap = 1
        self.valid_ratio = 0.1
        self.weights_path = './checkpoints/model.pt'
        self.vis = 1


#Test 1 90's
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.nn.init as init


class Params:
    """
    :ivar use_gpu: use CUDA GPU for running the CNN instead of CPU

    :ivar enable_test: use the (unreleased) test instead of the validation set for evaluation after training is done

    :ivar optim_type: optimizer type: 0: SGD, 1: ADAM

    :ivar load_weights:
        0: train from scratch
        1: load and test
        2: load if it exists and continue training

    :ivar save_criterion:  when to save a new checkpoint
        0: max validation accuracy
        1: min validation loss
        2: max training accuracy
        3: min training loss

    :ivar lr: learning rate
    :ivar eps: term added to the denominator to improve numerical stability in ADAM optimizer

    :ivar valid_ratio: fraction of training data to use for validation
    :ivar valid_gap: no. of training epochs between validations

    :ivar vis: visualize the input and reconstructed images during validation and testing;
        vis=1 will only write these to tensorboard
        vis=2 will display them using opencv as well; only works for offline runs since colab doesn't support cv2.imshow
    """

    def __init__(self):
        self.use_gpu = 1
        self.enable_test = 0

        self.load_weights = 0

        self.train_batch_size = 128

        self.valid_batch_size = 24
        self.test_batch_size = 24

        self.n_workers = 1
        self.optim_type = 1
        self.lr = 1e-3
        self.momentum = 1.5
        self.n_epochs = 1000
        self.eps = 1e-8
        self.weight_decay = 0
        self.save_criterion = 0
        self.valid_gap = 1
        self.valid_ratio = 0.1
        self.weights_path = './checkpoints/model.pt'
        self.vis = 1

#95

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.nn.init as init


class Params:
    """
    :ivar use_gpu: use CUDA GPU for running the CNN instead of CPU

    :ivar enable_test: use the (unreleased) test instead of the validation set for evaluation after training is done

    :ivar optim_type: optimizer type: 0: SGD, 1: ADAM

    :ivar load_weights:
        0: train from scratch
        1: load and test
        2: load if it exists and continue training

    :ivar save_criterion:  when to save a new checkpoint
        0: max validation accuracy
        1: min validation loss
        2: max training accuracy
        3: min training loss

    :ivar lr: learning rate
    :ivar eps: term added to the denominator to improve numerical stability in ADAM optimizer

    :ivar valid_ratio: fraction of training data to use for validation
    :ivar valid_gap: no. of training epochs between validations

    :ivar vis: visualize the input and reconstructed images during validation and testing;
        vis=1 will only write these to tensorboard
        vis=2 will display them using opencv as well; only works for offline runs since colab doesn't support cv2.imshow
    """

    def __init__(self):
        self.use_gpu = 1
        self.enable_test = 0

        self.load_weights = 0

        self.train_batch_size = 128

        self.valid_batch_size = 24
        self.test_batch_size = 24

        self.n_workers = 1
        self.optim_type = 1
        self.lr = 1e-3
        self.momentum = 1.5
        self.n_epochs = 1000
        self.eps = 1e-8
        self.weight_decay = 0
        self.save_criterion = 0
        self.valid_gap = 1
        self.valid_ratio = 0.1
        self.weights_path = './checkpoints/model.pt'
        self.vis = 1



class Classifier(nn.Module):
    def __init__(self):
        super(Classifier, self).__init__()
        self.conv1 = nn.Conv2d(3, 20, kernel_size=5,padding=3)
        self.conv2 = nn.Conv2d(20, 30, kernel_size=5,padding=3)
        self.conv2_drop = nn.Dropout2d()
        self.conv3 = nn.Conv2d(30, 20, kernel_size=5,padding=3)
        self.conv4 = nn.Conv2d(20, 20, kernel_size=5,padding=3)
        self.conv4_drop = nn.Dropout2d()
        self.fc1 = nn.Linear(180, 50)
        self.fc2 = nn.Linear(50, 10)
    def init_weights(self):
        for m in self.modules():
            if isinstance(m,nn.Conv2d):
                init.kaiming_normal_(m.weight,mode='fan_out')
                if m.bias is not None:
                    init.constant_(m.bias,0)
            elif isinstance(m,nn.BatchNorm2d):
                init.constant_(m.weight,1)
                init.constant_(m.bias,0)
            elif isinstance(m,nn.Linear):
                init.normal_(m.weight,std=1e-3)
                if m.bias is not None:
                    init.constant_(m.bias,0)
                
                

    def forward(self, x):
        h = x.shape[0]
        x = F.relu(F.max_pool2d(self.conv1(x), 2))
        x = F.relu(F.max_pool2d(self.conv2_drop(self.conv2(x)), 2))
        x = F.relu(F.max_pool2d(self.conv3(x), 2))
        x = F.relu(F.max_pool2d(self.conv4_drop(self.conv4(x)), 2))
        x = x.view(h, 180)
        x = F.relu(self.fc1(x))
        x = F.dropout(x)
        x = self.fc2(x)
  
        return F.log_softmax(x)
