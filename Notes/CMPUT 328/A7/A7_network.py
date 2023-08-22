import numpy as np
import tensorflow as tf
from keras.layers import Input, Flatten
import tensorflow.compat.v1 as tf1
#Reference: https://github.com/cdamore/Object-Detection-on-2-digit-MNIST/blob/f1c07ad1ebcbe6b15830eb5cfab879fd30259788/src/net.py#L284
class DatasetIterator(object):

  def __init__(self, batch_size=64):
    self.batch_size = batch_size
    self.num_samples = 55000
    self.next_batch_pointer = 0
    self.b1 = None
    self.b2 = None
    self.b3 = None
    self.b4 = None
    # load data
    self.train_bboxes = np.load('../data/train_bboxes.npy')
    self.train_X = np.load('../data/train_X.npy').reshape((55000, 64, 64, 3))
    self.train_Y = np.load('../data/train_Y.npy')
    self.labels_Y = self.convert_to_labels(self.train_Y, self.num_samples)
    # shuffle data
    self.shuffle()

  # shuffle samples
  def shuffle(self):
    image_indices = np.random.permutation(np.arange(self.num_samples))
    self.train_X = self.train_X[image_indices]
    self.train_Y = self.train_Y[image_indices]
    self.labels_Y = self.labels_Y[image_indices]
    self.train_bboxes = self.train_bboxes[image_indices]

  # convert image classification [x,y] to an integer between 0 and 55
  # 55 possible 2 digit combinations
  def convert_to_labels(self, Y, size):
    labels = np.zeros(size)
    for i in range(size):
      start_index = 0
      cur_value = 10
      for j in range(Y[i][0]):
        start_index += cur_value
        cur_value =  cur_value - 1
      labels[i] = start_index + Y[i][1] - Y[i][0]
    return labels

  # get next batch
  def get_next_batch(self):
    num_samples_left = self.num_samples - self.next_batch_pointer
    if num_samples_left >= self.batch_size:
      x_batch = self.train_X[self.next_batch_pointer:self.next_batch_pointer + self.batch_size]
      y_batch = self.labels_Y[self.next_batch_pointer:self.next_batch_pointer + self.batch_size]
      z_batch = self.train_bboxes[self.next_batch_pointer:self.next_batch_pointer + self.batch_size]
      self.next_batch_pointer += self.batch_size
    else:
      self.next_batch_pointer = 0
      x_batch, y_batch, z_batch = self.get_next_batch()

    return x_batch, y_batch.reshape((self.batch_size, 1)), z_batch

def covert_from_labels(labels, size):
    Y = np.zeros((size, 2))
    # all possible 2-digit combinations
    inx = [[0,0], [0,1], [0,2], [0,3], [0,4], [0,5], [0,6], [0,7], [0,8], [0,9],
           [1,1], [1,2], [1,3], [1,4], [1,5], [1,6], [1,7], [1,8], [1,9],
           [2,2], [2,3], [2,4], [2,5], [2,6], [2,7], [2,8], [2,9],
           [3,3], [3,4], [3,5], [3,6], [3,7], [3,8], [3,9],
           [4,4], [4,5], [4,6], [4,7], [4,8], [4,9],
           [5,5], [5,6], [5,7], [5,8], [5,9],
           [6,6], [6,7], [6,8], [6,9],
           [7,7], [7,8], [7,9],
           [8,8], [8,8],
           [9,9]]
    for i in range(size):
      Y[i] = inx[labels[i]]
    return Y

def net(input, is_training):
  # Hyperparameters
  mu = 0
  sigma = 0.01

  # Layer 1: Convolutional. Input = 64x64x3. Output = 32x32x6.
  conv1_W = tf.Variable(tf.random.truncated_normal(shape=(5, 5, 1, 6), mean = mu, stddev = sigma), name='conv1_W')
  conv1_b = tf.Variable(tf.zeros(6), name='conv1_b')
  conv1   = tf.nn.conv2d(input, conv1_W, strides=[1, 1, 1, 1], padding='SAME') + conv1_b

  # Relu Activation.
  conv1 = tf.nn.relu(conv1)

  # Densenet-like connection: Convolutional. Input = 64x64x6. Output = 64x64x16.
  convs_W = tf.Variable(tf.random.truncated_normal(shape=(5, 5, 7, 16), mean = mu, stddev = sigma), name='convs_W')
  convs_b = tf.Variable(tf.zeros(16), name='conv2_s')
  convs   = tf.nn.conv2d(tf.concat([input,conv1],axis=3), convs_W, strides=[1, 1, 1, 1], padding='SAME') + convs_b

  # Activation.
  convs = tf.nn.relu(convs)

  # Pooling. Input = 64x64x16. Output = 32x32x16.
  convs = tf.nn.max_pool(convs, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='VALID')

  # Layer 3: Convolutional. Output = 28x28x36.
  conv2_W = tf.Variable(tf.random.truncated_normal(shape=(5, 5, 16, 36), mean = mu, stddev = sigma), name='conv2_W')
  conv2_b = tf.Variable(tf.zeros(36), name='conv2_b')
  conv2   = tf.nn.conv2d(convs, conv2_W, strides=[1, 1, 1, 1], padding='VALID') + conv2_b

  # Batch normalization Output = 28x28x36.
  conv2 = tf1.layers.batch_normalization(conv2,training=is_training)

  # Activation.
  conv2 = tf.nn.relu(conv2)

  # Pooling. Input = 28x28x36. Output = 14x14x36.
  conv2 = tf.nn.max_pool(conv2, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='VALID')

  # Layer 4: Convolutional. Input = 14x14x36. Output = 14x14x72.
  conv3_W = tf.Variable(tf.random.truncated_normal(shape=(5, 5, 36, 72), mean = mu, stddev = sigma), name='conv3_W')
  conv3_b = tf.Variable(tf.zeros(72), name='conv3_b')
  conv3   = tf.nn.conv2d(conv2, conv3_W, strides=[1, 1, 1, 1], padding='SAME') + conv3_b

  # Batch normalization Output = 14x14x72.
  conv3 = tf1.layers.batch_normalization(conv3,training=is_training)

  # Activation.
  conv3 = tf.nn.relu(conv3)

  # Pooling. Input = 14x14x72. Output = 7x7x72.
  conv3 = tf.nn.max_pool(conv3, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='VALID')

  # Layer 5: Convolutional. Input = 7x7x72. Output = 7x7x148.
  conv4_W = tf.Variable(tf.random.truncated_normal(shape=(5, 5, 72, 148), mean = mu, stddev = sigma), name='conv4_W')
  conv4_b = tf.Variable(tf.zeros(148), name='conv4_b')
  conv4   = tf.nn.conv2d(conv3, conv4_W, strides=[1, 1, 1, 1], padding='SAME') + conv4_b

  # Batch normalization Output = 7x7x148.
  conv4 = tf1.layers.batch_normalization(conv4,training=is_training)

  # Activation.
  conv4 = tf.nn.relu(conv4)

  # Pooling. Input = 7x7x148. Output = 3x3x148.
  conv4 = tf.nn.max_pool(conv4, ksize=[1, 2, 2, 1], strides=[1, 2, 2, 1], padding='VALID')

  # Flatten. Input =  3x3x148. Output = 1332.
  fc0 = Flatten()(conv4)

  ######################### LABELS (l1) #############################

  # Layer 4: Fully Connected. Input = 1332. Output = 660.
  fc1_W = tf.Variable(tf.random.truncated_normal(shape=(1332, 660), mean = mu, stddev = sigma), name='fc1_W')
  fc1_b = tf.Variable(tf.zeros(660), name='fc1_b')
  fc1   = tf.matmul(fc0, fc1_W) + fc1_b

  # Activation.
  fc1 = tf.nn.relu(fc1)

  # Layer 5: Fully Connected. Input = 660. Output = 196.
  fc2_W  = tf.Variable(tf.random.truncated_normal(shape=(660, 196), mean = mu, stddev = sigma), name='fc2_W')
  fc2_b  = tf.Variable(tf.zeros(196), name='fc2_b')
  fc2    = tf.matmul(fc1, fc2_W) + fc2_b

  # Activation.
  fc2    = tf.nn.relu(fc2)

  # Layer 6: Fully Connected. Input = 196. Output = 55.
  fc3_W  = tf.Variable(tf.random.truncated_normal(shape=(196, 55), mean = mu, stddev = sigma), name='fc3_W')
  fc3_b  = tf.Variable(tf.zeros(55), name='fc3_b')
  l1 = tf.matmul(fc2, fc3_W) + fc3_b

  ######################### BBOX 1 (l2) #############################

  # Layer 4: Fully Connected. Input = 1332. Output = 660.
  fc1_W = tf.Variable(tf.random.truncated_normal(shape=(1332, 660), mean = mu, stddev = sigma), name='fc1_W')
  fc1_b = tf.Variable(tf.zeros(660), name='fc1_b')
  fc1   = tf.matmul(fc0, fc1_W) + fc1_b

  # Activation.
  fc1 = tf.nn.relu(fc1)

  # Layer 5: Fully Connected. Input = 660. Output = 196.
  fc2_W  = tf.Variable(tf.random.truncated_normal(shape=(660, 196), mean = mu, stddev = sigma), name='fc2_W')
  fc2_b  = tf.Variable(tf.zeros(196), name='fc2_b')
  fc2    = tf.matmul(fc1, fc2_W) + fc2_b

  # Activation.
  fc2    = tf.nn.relu(fc2)

  # Layer 6: Fully Connected. Input = 196. Output = 55.
  fc3_W  = tf.Variable(tf.random.truncated_normal(shape=(196, 37), mean = mu, stddev = sigma), name='fc3_W')
  fc3_b  = tf.Variable(tf.zeros(37), name='fc3_b')
  l2 = tf.matmul(fc2, fc3_W) + fc3_b

  ######################### BBOX 2 (l3) #############################

  # Layer 4: Fully Connected. Input = 1332. Output = 660.
  fc1_W = tf.Variable(tf.random.truncated_normal(shape=(1332, 660), mean = mu, stddev = sigma), name='fc1_W')
  fc1_b = tf.Variable(tf.zeros(660), name='fc1_b')
  fc1   = tf.matmul(fc0, fc1_W) + fc1_b

  # Activation.
  fc1 = tf.nn.relu(fc1)

  # Layer 5: Fully Connected. Input = 660. Output = 196.
  fc2_W  = tf.Variable(tf.random.truncated_normal(shape=(660, 196), mean = mu, stddev = sigma), name='fc2_W')
  fc2_b  = tf.Variable(tf.zeros(196), name='fc2_b')
  fc2    = tf.matmul(fc1, fc2_W) + fc2_b

  # Activation.
  fc2    = tf.nn.relu(fc2)

  # Layer 6: Fully Connected. Input = 196. Output = 55.
  fc3_W  = tf.Variable(tf.random.truncated_normal(shape=(196, 37), mean = mu, stddev = sigma), name='fc3_W')
  fc3_b  = tf.Variable(tf.zeros(37), name='fc3_b')
  l3 = tf.matmul(fc2, fc3_W) + fc3_b

  ######################### BBOX 3 (l4) #############################

  # Layer 4: Fully Connected. Input = 1332. Output = 660.
  fc1_W = tf.Variable(tf.random.truncated_normal(shape=(1332, 660), mean = mu, stddev = sigma), name='fc1_W')
  fc1_b = tf.Variable(tf.zeros(660), name='fc1_b')
  fc1   = tf.matmul(fc0, fc1_W) + fc1_b

  # Activation.
  fc1 = tf.nn.relu(fc1)

  # Layer 5: Fully Connected. Input = 660. Output = 196.
  fc2_W  = tf.Variable(tf.random.truncated_normal(shape=(660, 196), mean = mu, stddev = sigma), name='fc2_W')
  fc2_b  = tf.Variable(tf.zeros(196), name='fc2_b')
  fc2    = tf.matmul(fc1, fc2_W) + fc2_b

  # Activation.
  fc2    = tf.nn.relu(fc2)

  # Layer 6: Fully Connected. Input = 196. Output = 55.
  fc3_W  = tf.Variable(tf.random.truncated_normal(shape=(196, 37), mean = mu, stddev = sigma), name='fc3_W')
  fc3_b  = tf.Variable(tf.zeros(37), name='fc3_b')
  l4 = tf.matmul(fc2, fc3_W) + fc3_b

  ######################### BBOX 4 (l5) #############################

  # Layer 4: Fully Connected. Input = 1332. Output = 660.
  fc1_W = tf.Variable(tf.random.truncated_normal(shape=(1332, 660), mean = mu, stddev = sigma), name='fc1_W')
  fc1_b = tf.Variable(tf.zeros(660), name='fc1_b')
  fc1   = tf.matmul(fc0, fc1_W) + fc1_b

  # Activation.
  fc1 = tf.nn.relu(fc1)

  # Layer 5: Fully Connected. Input = 660. Output = 196.
  fc2_W  = tf.Variable(tf.random.truncated_normal(shape=(660, 196), mean = mu, stddev = sigma), name='fc2_W')
  fc2_b  = tf.Variable(tf.zeros(196), name='fc2_b')
  fc2    = tf.matmul(fc1, fc2_W) + fc2_b

  # Activation.
  fc2    = tf.nn.relu(fc2)

  # Layer 6: Fully Connected. Input = 196. Output = 55.
  fc3_W  = tf.Variable(tf.random.truncated_normal(shape=(196, 37), mean = mu, stddev = sigma), name='fc3_W')
  fc3_b  = tf.Variable(tf.zeros(37), name='fc3_b')
  l5 = tf.matmul(fc2, fc3_W) + fc3_b

  return l1, l2, l3, l4, l5


def classify_and_detect(images):
  """

  :param np.ndarray images: N x 12288 array containing N 64x64x3 images flattened into vectors
    :return: np.ndarray, np.ndarray
  """
  N = images.shape[0]

    # pred_class: Your predicted labels for the 2 digits, shape [N, 2]
    # Always use tf.reset_default_graph() to avoid error
  #tf.reset_default_graph()

  EPOCHS = 100
  N_BATCHES = 275 # 55,000 / 200
  BATCH_SIZE = 200
  prefix="train"
  train=True
  tf1.disable_eager_execution()

  # placeholders for images (x) and labels (y,b1,b2,b3,b4)
  x = tf1.placeholder(tf.float32, (None, 64, 64, 1))
  y = tf1.placeholder(tf.int32, (None))
  b1 = tf1.placeholder(tf.int32, (None))
  b2 = tf1.placeholder(tf.int32, (None))
  b3 = tf1.placeholder(tf.int32, (None))
  b4 = tf1.placeholder(tf.int32, (None))

  # one-hot conversion
  one_hot_y = tf.one_hot(y, 55)
  one_hot_b1 = tf.one_hot(b1, 37)
  one_hot_b2 = tf.one_hot(b2, 37)
  one_hot_b3 = tf.one_hot(b3, 37)
  one_hot_b4 = tf.one_hot(b4, 37)

  rate = 0.0002

  is_training = True

  l1, l2, l3, l4, l5 = net(x, is_training)

  saver = tf1.train.Saver(max_to_keep=0)

  # optimizer
  optimizer = tf1.train.AdamOptimizer(learning_rate = rate)

  #L1
  cross_entropy_l1 = tf.nn.softmax_cross_entropy_with_logits(logits=l1, labels=one_hot_y)
  loss_operation_l1 = tf.reduce_mean(cross_entropy_l1)
  grads_and_vars_l1 = optimizer.compute_gradients(loss_operation_l1, tf1.get_collection(tf1.GraphKeys.TRAINABLE_VARIABLES))
  training_operation_l1 = optimizer.apply_gradients(grads_and_vars_l1)

  #L2
  cross_entropy_l2 = tf.nn.softmax_cross_entropy_with_logits(logits=l2, labels=one_hot_b1)
  loss_operation_l2 = tf.reduce_mean(cross_entropy_l2)
  grads_and_vars_l2 = optimizer.compute_gradients(loss_operation_l2, tf1.get_collection(tf1.GraphKeys.TRAINABLE_VARIABLES))
  training_operation_l2 = optimizer.apply_gradients(grads_and_vars_l2)

  #L3
  cross_entropy_l3 = tf.nn.softmax_cross_entropy_with_logits(logits=l3, labels=one_hot_b2)
  loss_operation_l3 = tf.reduce_mean(cross_entropy_l3)
  grads_and_vars_l3 = optimizer.compute_gradients(loss_operation_l3, tf1.get_collection(tf1.GraphKeys.TRAINABLE_VARIABLES))
  training_operation_l3 = optimizer.apply_gradients(grads_and_vars_l3)

  #L4
  cross_entropy_l4 = tf.nn.softmax_cross_entropy_with_logits(logits=l4, labels=one_hot_b3)
  loss_operation_l4 = tf.reduce_mean(cross_entropy_l4)
  grads_and_vars_l4 = optimizer.compute_gradients(loss_operation_l4, tf1.get_collection(tf1.GraphKeys.TRAINABLE_VARIABLES))
  training_operation_l4 = optimizer.apply_gradients(grads_and_vars_l4)

  #L5
  cross_entropy_l5 = tf.nn.softmax_cross_entropy_with_logits(logits=l5, labels=one_hot_b4)
  loss_operation_l5 = tf.reduce_mean(cross_entropy_l5)
  grads_and_vars_l5 = optimizer.compute_gradients(loss_operation_l5, tf1.get_collection(tf1.GraphKeys.TRAINABLE_VARIABLES))
  training_operation_l5 = optimizer.apply_gradients(grads_and_vars_l5)

  training_operation = [training_operation_l1,training_operation_l2,training_operation_l3,training_operation_l4,training_operation_l5]

  # Training

  mnistdd_train = DatasetIterator(batch_size=BATCH_SIZE)

  if train:
    with tf.Session() as sess:
      sess.run(tf.global_variables_initializer())

      print("Training...")
      global_step = 0
      for i in range(EPOCHS):
          for iteration in range(N_BATCHES):
              batch_x, batch_y, batch_z = mnistdd_train.get_next_batch() # get the next batch
              _ = sess.run(training_operation, feed_dict={x: batch_x, y: batch_y, b1: batch_z[:,0][:,0], b2: batch_z[:,0][:,1], b3: batch_z[:,1][:,0], b4: batch_z[:,1][:,1]})
              global_step += 1
              print("iteration {} ...".format(iteration))

          print("EPOCH {} ...".format(i+1))

      saver.save(sess, '../ckpt/net', global_step=1)
      print("Model saved")

  # Testing
  print("testing...")
  test_data = np.load("../data/" + prefix + "_X.npy")
  num_images = len(test_data)
  test_data = test_data.reshape((num_images, 64, 64, 1))

  with tf.Session() as sess:
    # load model
    saver.restore(sess, tf.train.latest_checkpoint('../ckpt'))

    # l1 Accuracy - predicts the two digits in the image
    l1_test = sess.run(tf.argmax(l1, axis=1), feed_dict={x:  test_data})
    # l2 Accuracy - predicts x-coord of first digit
    l2_test = sess.run(tf.argmax(l2, axis=1), feed_dict={x:  test_data})
    # l3 Accuracy - predicts y-coord of first digit
    l3_test = sess.run(tf.argmax(l3, axis=1), feed_dict={x:  test_data})
    # l4 Accuracy - predicts x-coord of second digit
    l4_test = sess.run(tf.argmax(l4, axis=1), feed_dict={x:  test_data})
    # l5 Accuracy - predicts y-coord of second digit
    l5_test = sess.run(tf.argmax(l5, axis=1), feed_dict={x:  test_data})

    # get labels back to orginal format
    pred_class = covert_from_labels(l1_test, num_images)

    # init space for predicted bboxes
    pred_bboxes = np.zeros((num_images,2,4))

    # assign coordinates back to original format
    pred_bboxes[:,0][:,0] = l2_test
    pred_bboxes[:,0][:,1] = l3_test
    pred_bboxes[:,1][:,0] = l4_test
    pred_bboxes[:,1][:,1] = l5_test
    pred_bboxes[:,0][:,2] = l2_test + 28
    pred_bboxes[:,0][:,3] = l3_test + 28
    pred_bboxes[:,1][:,2] = l4_test + 28
    pred_bboxes[:,1][:,3] = l5_test + 28

    return np.array(pred_class), np.array(pred_bboxes)
