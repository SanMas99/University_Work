import sys
import os

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

import numpy as np
import cv2

import matplotlib

font = {'family': 'normal',
        'weight': 'bold',
        'size': 10}

matplotlib.rc('font', **font)
# matplotlib.rc('figure', titlesize=22)

from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure


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
        self.momentum = 0
        self.load = 1
        self.load_dir = ''
        self.plot = 1
        self.show_plot = 0
        self.save_plot = 1
        self.codec = 'MJPG'
        self.ext = 'avi'
        # self.eps = 1e-3
        # self.eps = 1
        self.eps = 10
        self.fps = 30
        self.size = (1920, 1080)


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


def get_plot_image(data_1, col_1, title):
    fig = Figure()
    canvas = FigureCanvas(fig)
    ax = fig.gca()

    ax.plot(data_1, col_1)
    ax.set_title(title)

    ax.title.set_fontsize(20)

    canvas.draw()
    width, height = fig.get_size_inches() * fig.get_dpi()
    plot_img = np.fromstring(canvas.tostring_rgb(), dtype='uint8').reshape(
        int(height), int(width), 3)

    return plot_img


def resize_ar(src_img, width=0, height=0, return_factors=False,
              placement_type=0, resize_factor=0):
    src_height, src_width, n_channels = src_img.shape

    src_aspect_ratio = float(src_width) / float(src_height)

    if isinstance(placement_type, int):
        placement_type = (placement_type, placement_type)

    # print('placement_type: {}'.format(placement_type))

    # print('placement_type: {}'.format(placement_type))

    if resize_factor != 0:
        width, height = int(src_width * resize_factor), int(src_height * resize_factor)

    if width <= 0 and height <= 0:
        if resize_factor == 0:
            raise AssertionError(
                'Both width and height cannot be 0 when resize_factor is 0 too')
    elif height <= 0:
        height = int(width / src_aspect_ratio)
    elif width <= 0:
        width = int(height * src_aspect_ratio)

    aspect_ratio = float(width) / float(height)

    if src_aspect_ratio == aspect_ratio:
        dst_width = src_width
        dst_height = src_height
        start_row = start_col = 0
    elif src_aspect_ratio > aspect_ratio:
        dst_width = src_width
        dst_height = int(src_width / aspect_ratio)
        start_row = int((dst_height - src_height) / 2.0)
        if placement_type[0] == 0:
            start_row = 0
        elif placement_type[0] == 1:
            start_row = int((dst_height - src_height) / 2.0)
        elif placement_type[0] == 2:
            start_row = int(dst_height - src_height)
        start_col = 0
    else:
        dst_height = src_height
        dst_width = int(src_height * aspect_ratio)
        start_col = int((dst_width - src_width) / 2.0)
        if placement_type[1] == 0:
            start_col = 0
        elif placement_type[1] == 1:
            start_col = int((dst_width - src_width) / 2.0)
        elif placement_type[1] == 2:
            start_col = int(dst_width - src_width)
        start_row = 0

    dst_img = np.zeros((dst_height, dst_width, n_channels), dtype=np.uint8)

    dst_img[start_row:start_row + src_height, start_col:start_col + src_width, :] = src_img
    dst_img = cv2.resize(dst_img, (width, height))
    if return_factors:
        resize_factor = float(height) / float(dst_height)
        return dst_img, resize_factor, start_row, start_col
    else:
        return dst_img


def stack_images(img_list, grid_size=None, stack_order=0, borderless=1,
                 preserve_order=0, return_idx=0, annotations=None,
                 ann_fmt=(0, 5, 15, 1, 1, 255, 255, 255, 0, 0, 0), only_height=0, sep_size=0):
    for img_id, img in enumerate(img_list):
        if len(img.shape) == 2:
            img_list[img_id] = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)

    n_images = len(img_list)
    # print('grid_size: {}'.format(grid_size))

    if grid_size is None:
        if n_images < 3:
            n_cols, n_rows = n_images, 1
        else:
            n_cols = n_rows = int(np.ceil(np.sqrt(n_images)))

            if n_rows * (n_cols - 1) >= n_images:
                n_cols -= 1
    else:
        n_rows, n_cols = grid_size
    target_ar = 1920.0 / 1080.0
    if n_cols <= n_rows:
        target_ar /= 2.0
    shape_img_id = 0
    min_ar_diff = np.inf
    img_heights = np.zeros((n_images,), dtype=np.int32)
    for _img_id in range(n_images):
        height, width = img_list[_img_id].shape[:2]
        img_heights[_img_id] = height
        img_ar = float(n_cols * width) / float(n_rows * height)
        ar_diff = abs(img_ar - target_ar)
        if ar_diff < min_ar_diff:
            min_ar_diff = ar_diff
            shape_img_id = _img_id

    img_heights_sort_idx = np.argsort(-img_heights)
    row_start_idx = img_heights_sort_idx[:n_rows]
    img_idx = img_heights_sort_idx[n_rows:]

    img_size = img_list[shape_img_id].shape
    height, width = img_size[:2]

    if only_height:
        width = 0

    # print()
    stacked_img = None
    list_ended = False
    img_idx_id = 0
    inner_axis = 1 - stack_order
    stack_idx = []
    stack_locations = []
    start_row = 0
    curr_ann = ''
    for row_id in range(n_rows):
        start_id = n_cols * row_id
        curr_row = None
        start_col = 0
        for col_id in range(n_cols):
            img_id = start_id + col_id
            if img_id >= n_images:
                curr_img = np.zeros(img_size, dtype=np.uint8)
                list_ended = True
            else:
                if preserve_order:
                    _curr_img_id = img_id
                elif col_id == 0:
                    _curr_img_id = row_start_idx[row_id]
                else:
                    _curr_img_id = img_idx[img_idx_id]
                    img_idx_id += 1

                curr_img = img_list[_curr_img_id]
                if annotations:
                    curr_ann = annotations[_curr_img_id]
                stack_idx.append(_curr_img_id)
                # print(curr_img.shape[:2])

                if not borderless:
                    curr_img = resize_ar(curr_img, width, height)
                if img_id == n_images - 1:
                    list_ended = True
            if curr_row is None:
                curr_row = curr_img
            else:
                if borderless:
                    curr_img = resize_ar(curr_img, 0, curr_row.shape[0])
                # print('curr_row.shape: ', curr_row.shape)
                # print('curr_img.shape: ', curr_img.shape)

                if sep_size:
                    sep_img_shape = list(curr_row.shape)
                    if inner_axis == 1:
                        sep_img_shape[1] = sep_size
                    else:
                        sep_img_shape[0] = sep_size

                    sep_img = np.full(sep_img_shape, 255, dtype=curr_row.dtype)
                    curr_row = np.concatenate((curr_row, sep_img, curr_img), axis=inner_axis)
                else:
                    curr_row = np.concatenate((curr_row, curr_img), axis=inner_axis)

            curr_h, curr_w = curr_img.shape[:2]
            stack_locations.append((start_row, start_col, start_row + curr_h, start_col + curr_w))
            start_col += curr_w

        if stacked_img is None:
            stacked_img = curr_row
        else:
            if borderless:
                resize_factor = float(curr_row.shape[1]) / float(stacked_img.shape[1])
                curr_row = resize_ar(curr_row, stacked_img.shape[1], 0)
                new_start_col = 0
                for _i in range(n_cols):
                    _start_row, _start_col, _end_row, _end_col = stack_locations[_i - n_cols]
                    _w, _h = _end_col - _start_col, _end_row - _start_row
                    w_resized, h_resized = _w / resize_factor, _h / resize_factor
                    stack_locations[_i - n_cols] = (
                        _start_row, new_start_col, _start_row + h_resized, new_start_col + w_resized)
                    new_start_col += w_resized
            # print('curr_row.shape: ', curr_row.shape)
            # print('stacked_img.shape: ', stacked_img.shape)

            if sep_size:
                sep_img_shape = list(curr_row.shape)
                if stack_order == 1:
                    sep_img_shape[1] = sep_size
                else:
                    sep_img_shape[0] = sep_size
                sep_img = np.full(sep_img_shape, 255, dtype=curr_row.dtype)
                stacked_img = np.concatenate((stacked_img, sep_img, curr_row), axis=stack_order)
            else:
                stacked_img = np.concatenate((stacked_img, curr_row), axis=stack_order)

        curr_h, curr_w = curr_row.shape[:2]
        start_row += curr_h

        if list_ended:
            break
    if return_idx:
        return stacked_img, stack_idx, stack_locations
    else:
        return stacked_img


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


def train(net, optimizer, train_loader, epoch, eps, device, load_dir, load,
          param_names, grad_names, diff_norm_dict, show_plot, plot_writer, vid_size):
    """

    :param A4NetManual net:
    :param optimizer:
    :param train_loader:
    :param device:
    :param load_dir:
    :return:
    """

    import torch

    save_plot = plot_writer is not None
    enable_plot = show_plot or save_plot

    # eps = 1e-6
    # eps = 10

    net.train()
    pbar = tqdm(train_loader, ncols=100, position=0, leave=True)
    avg_loss = 0

    init_out_path = os.path.join(load_dir, f'init.pt')
    params, _ = net.params_and_grads()

    epoch_load_dir = os.path.join(load_dir, f'epoch_{epoch}')
    if not load:
        os.makedirs(epoch_load_dir, exist_ok=1)

    if epoch == 0:
        if load:
            init_dict = torch.load(init_out_path)
            init_params = init_dict['params']

            for param, init_param, param_name in zip(params, init_params, param_names):
                param_shape, param_size = param.shape, param.size()
                init_param_shape, init_param_size = init_param.shape, init_param.size()

                if param_shape == init_param_shape:
                    param.data[:] = init_param.data
                elif param_shape == init_param_shape[::-1]:
                    param.data[:] = torch.t(init_param.data)
                else:
                    param.data[:] = torch.reshape(init_param.data, param_shape)
                    # raise AssertionError(f'Mismatching shapes for {param_name}')

        else:
            init_dict = {
                'params': params
            }
            torch.save(init_dict, init_out_path)

    loaded_dict = None

    for batch_idx, (data, target) in enumerate(pbar):
        optimizer.zero_grad()

        load_path = os.path.join(epoch_load_dir, f'batch_{batch_idx}.pt')

        if load:
            loaded_dict = torch.load(load_path)
            data = loaded_dict['data']
            target = loaded_dict['target']

        data = data.to(device)
        target = target.to(device)
        output = net(data)
        loss = net.get_loss(output, target)
        net.backward_pass(loss, data, output, target)
        optimizer.step()

        loss_sc = loss.item()

        params, grads = net.params_and_grads()

        if load:
            loaded_params = loaded_dict['params']
            loaded_grads = loaded_dict['grads']

            imgs = []

            all_params = params + grads
            all_loaded_params = loaded_params + loaded_grads
            all_names = param_names + grad_names

            for param, loaded_param, param_name in zip(all_params, all_loaded_params, all_names):
                if param.shape == loaded_param.shape:
                    pass
                elif param.shape == loaded_param.shape[::-1]:
                    loaded_param = torch.t(loaded_param)
                else:
                    loaded_param = torch.reshape(loaded_param, param.shape)

                diff = param - loaded_param.to(device)

                diff_norm = torch.norm(diff).item()
                assert diff_norm < eps, f"nonzero diff found for {param_name} " \
                    f"in epoch {epoch}, batch {batch_idx}: {diff_norm}"

                diff_norm_dict[param_name].append(diff_norm)

                if enable_plot:
                    diff_norm_img = get_plot_image(diff_norm_dict[param_name], 'green', param_name)

                    imgs.append(diff_norm_img)

            if enable_plot:
                target_names = [
                    'W1', 'dW1', 'b1', 'db1',
                    'W2', 'dW2', 'b2', 'db2',
                    'W3', 'dW3', 'b3', 'db3'
                ]

                target_ids = [all_names.index(k) for k in target_names]

                imgs = [imgs[i] for i in target_ids]

                cmb_img = stack_images(imgs, [3, 4], preserve_order=1)

                if show_plot:
                    cv2.imshow('diff_norm', cmb_img)
                    k = cv2.waitKey(1)
                    if k == 27:
                        return False

                if save_plot:
                    width, height = vid_size
                    vid_img = resize_ar(cmb_img, width=width, height=height, placement_type=1)
                    plot_writer.write(vid_img)
        else:
            # W1, b1, W2, b2, W3, b3 = params
            # dW1, db1, dW2, db2, dW3, db3 = grads

            out_dict = {
                'data': data,
                'target': target,
                'params': params,
                'grads': grads,
                'loss': loss,
            }

            torch.save(out_dict, load_path)

        avg_loss += (loss_sc - avg_loss) / (batch_idx + 1)

        pbar.set_description('train loss: {:.6f} avg loss: {:.6f}'.format(loss_sc, avg_loss))

    return True


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

    load_dir = params.load_dir

    if not load_dir:
        load_dir = f'{params.impl_type}_{params.loss_type}'
    os.makedirs(load_dir, exist_ok=1)

    start = timeit.default_timer()

    param_names = ['W1', 'b1', 'W2', 'b2', 'W3', 'b3']
    grad_names = ['dW1', 'db1', 'dW2', 'db2', 'dW3', 'db3']

    diff_norm_dict = {
        k: [] for k in param_names + grad_names
    }

    if params.load and params.save_plot:
        plot_save_path = os.path.join(load_dir, f'diff_norms.{params.ext}')
        print(f'saving plot video to {plot_save_path}')
        fourcc = cv2.VideoWriter_fourcc(*params.codec)
        video_out = cv2.VideoWriter(plot_save_path, fourcc, params.fps, params.size)
    else:
        video_out = None

    for epoch in range(params.n_epochs):
        print(f'\nepoch {epoch + 1} / {params.n_epochs}\n')
        train_start = timeit.default_timer()

        ret = train(net, optimizer, train_loader, epoch, params.eps, device, load_dir, params.load,
                    param_names, grad_names, diff_norm_dict, params.show_plot, video_out, params.size)

        if not ret:
            break

        train_stop = timeit.default_timer()
        train_runtime = train_stop - train_start
        print(f'\nepoch runtime: {train_runtime:.2f} secs')

    with torch.no_grad():
        test(net, test_loader, device)

    stop = timeit.default_timer()

    runtime = stop - start

    print(f'total runtime: {runtime:.2f} secs')

    if video_out is not None:
        video_out.release()


if __name__ == "__main__":
    main()
