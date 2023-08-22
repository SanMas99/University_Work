import sys

from A4_submission_manual import A4NetManual

modules = sys.modules

assert 'torch' not in modules.keys(), "pytorch cannot be imported in A4_submission_manual"

a4_submission_manual_lines = open('A4_submission_manual.py', 'r').readlines()
invalid_strings = ['import torch', 'from torch', 'importlib', 'torch.']
invalid_lines = [line for line in a4_submission_manual_lines if any(k for k in invalid_strings
                                                                    if k in a4_submission_manual_lines)]
if invalid_lines:
    invalid_lines_str = ''.join(invalid_lines)
    raise AssertionError(f'invalid_strings found in a4_submission_manual_lines:\n{invalid_lines_str}')

from A4_submission_builtin import A4NetBuiltin

from tqdm import tqdm


class Params:
    class BatchSize:
        train = 128
        val = 128
        test = 1000

    def __init__(self):
        self.device = 'gpu'
        self.impl_type = "builtin"
        self.loss_type = "l2"
        self.batch_size = Params.BatchSize()
        self.log_interval = 100
        self.n_epochs = 10
        self.learning_rate = 1e-1
        self.momentum = 0.5


class SGDManual:
    def __init__(self, W, b, dW, db, learning_rate):
        self.W = W
        self.b = b

        self.dW = dW
        self.db = db

        self.learning_rate = learning_rate

    def zero_grad(self):
        pass

    def step(self):
        self.W[0] = self.W[0] - self.learning_rate * self.dW[0]
        self.W[1] = self.W[1] - self.learning_rate * self.dW[1]
        self.W[2] = self.W[2] - self.learning_rate * self.dW[2]

        self.b[0] = self.b[0] - self.learning_rate * self.db[0]
        self.b[1] = self.b[1] - self.learning_rate * self.db[1]
        self.b[2] = self.b[2] - self.learning_rate * self.db[2]


def get_dataloaders(batch_size):
    """

    :param Params.BatchSize batch_size:
    :return:
    """
    import torch
    from torch.utils.data import random_split
    import torchvision

    MNIST_training = torchvision.datasets.MNIST('.', train=True, download=True,
                                                transform=torchvision.transforms.Compose([
                                                    torchvision.transforms.ToTensor(),
                                                    torchvision.transforms.Normalize((0.1307,), (0.3081,))]))

    MNIST_test_set = torchvision.datasets.MNIST('.', train=False, download=True,
                                                transform=torchvision.transforms.Compose([
                                                    torchvision.transforms.ToTensor(),
                                                    torchvision.transforms.Normalize((0.1307,), (0.3081,))]))

    # create a training and a validation set
    MNIST_train_set, MNIST_val_set = random_split(MNIST_training, [55000, 5000])

    train_loader = torch.utils.data.DataLoader(MNIST_train_set, batch_size=batch_size.train, shuffle=True)

    val_loader = torch.utils.data.DataLoader(MNIST_val_set, batch_size=batch_size.val, shuffle=True)

    test_loader = torch.utils.data.DataLoader(MNIST_test_set,
                                              batch_size=batch_size.test, shuffle=True)

    return train_loader, val_loader, test_loader


def train(net, optimizer, train_loader, device):
    net.train()
    pbar = tqdm(train_loader, ncols=100, position=0, leave=True)
    avg_loss = 0
    for batch_idx, (data, target) in enumerate(pbar):
        optimizer.zero_grad()
        data = data.to(device)
        target = target.to(device)
        output = net(data)
        loss = net.get_loss(output, target)
        net.backward_pass(loss, data, output, target)
        optimizer.step()

        loss_sc = loss.item()

        avg_loss += (loss_sc - avg_loss) / (batch_idx + 1)

        pbar.set_description('train loss: {:.6f} avg loss: {:.6f}'.format(loss_sc, avg_loss))


def validation(net, validation_loader, device):
    net.eval()
    validation_loss = 0
    correct = 0
    for data, target in validation_loader:
        data = data.to(device)
        target = target.to(device)
        output = net(data)
        loss = net.get_loss(output, target)
        validation_loss += loss.item()
        pred = output.data.max(1, keepdim=True)[1]
        correct += pred.eq(target.data.view_as(pred)).sum()

    validation_loss /= len(validation_loader.dataset)
    print('\nValidation set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.2f}%)\n'.format(
        validation_loss, correct, len(validation_loader.dataset),
        100. * correct / len(validation_loader.dataset)))


def test(net, test_loader, device):
    net.eval()
    test_loss = 0
    correct = 0
    for data, target in test_loader:
        data = data.to(device)
        target = target.to(device)

        output = net(data)
        loss = net.get_loss(output, target)

        test_loss += loss.item()
        pred = output.data.max(1, keepdim=True)[1]
        correct += pred.eq(target.data.view_as(pred)).sum()

    test_loss /= len(test_loader.dataset)
    print('\nTest set: Avg. loss: {:.4f}, Accuracy: {}/{} ({:.2f}%)\n'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))


def main():
    params = Params()

    try:
        import paramparse
    except ImportError:
        print("paramparse is unavailable so commandline arguments will not work")
    else:
        paramparse.process(params)

    import torch
    import torch.optim as optim
    import torch.nn.functional as F

    import timeit

    random_seed = 1
    torch.manual_seed(random_seed)

    if params.device != 'cpu' and torch.cuda.is_available():
        device = torch.device("cuda")
        print('Running on GPU: {}'.format(torch.cuda.get_device_name(0)))
    else:
        device = torch.device("cpu")
        print('Running on CPU')

    train_loader, val_loader, test_loader = get_dataloaders(params.batch_size)

    if params.loss_type == 'l2':
        loss_str = 'L2'
    elif params.loss_type == 'ce':
        loss_str = 'cross entropy'
    else:
        raise AssertionError(f'invalid loss type: {params.loss_type}')

    if params.impl_type == "manual":
        torch_fns = [
            torch.tensor, torch.zeros,
            torch.mm, torch.mul, torch.sum, torch.mean, torch.log,
            torch.sin, torch.cos, torch.transpose,
            F.tanh, F.softmax, F.one_hot
        ]

        net = A4NetManual(params.loss_type, 10, torch_fns, device)
        W, b = net.parameters()
        dW, db = net.grads()

        optimizer = SGDManual(W, b, dW, db, params.learning_rate)
    elif params.impl_type == "builtin":
        net = A4NetBuiltin(params.loss_type, 10).to(device)
        optimizer = optim.SGD(net.parameters(), lr=params.learning_rate,
                              momentum=params.momentum)
    else:
        raise AssertionError(f'invalid implementation type: {params.impl_type}')

    print(f'\nusing {params.impl_type} implementation with {loss_str} loss\n')

    start = timeit.default_timer()

    with torch.no_grad():
        validation(net, val_loader, device)
    for epoch in range(params.n_epochs):
        print(f'\nepoch {epoch + 1} / {params.n_epochs}\n')
        train_start = timeit.default_timer()

        train(net, optimizer, train_loader, device)

        train_stop = timeit.default_timer()
        train_runtime = train_stop - train_start
        print(f'\ntrain runtime: {train_runtime:.2f} secs')

        with torch.no_grad():
            validation(net, val_loader, device)
    with torch.no_grad():
        test(net, test_loader, device)

    stop = timeit.default_timer()

    runtime = stop - start

    print(f'total runtime: {runtime:.2f} secs')


if __name__ == "__main__":
    main()
