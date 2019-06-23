import numpy as np


def correct_dimensions(s, targetlength):
    """checks the dimensionality of some numeric argument s, broadcasts it
       to the specified length if possible.

    Args:
        s: None, scalar or 1D array
        targetlength: expected length of s

    Returns:
        None if s is None, else numpy vector of length targetlength
    """
    if s is not None:
        s = np.array(s)
        if s.ndim == 0:
            s = np.array([s] * targetlength)
        elif s.ndim == 1:
            if not len(s) == targetlength:
                raise ValueError("arg must have length " + str(targetlength))
        else:
            raise ValueError("Invalid argument")
    return s


def identity(x):
    return x


class ESN():

    def __init__(self, n_inputs, n_outputs, n_reservoir=200,
                 spectral_radius=0.95, sparsity=0, lam=0.0, random_state=None, silent=True,
                 out_activation=identity, inverse_out_activation=identity):
        """
        Args:
            n_inputs: nr of input dimensions
            n_outputs: nr of output dimensions
            n_reservoir: nr of reservoir neurons
            spectral_radius: spectral radius of the recurrent weight matrix
            sparsity: proportion of recurrent weights set to zero
            random_state: positive integer seed, np.rand.RandomState object,
                          or None to use numpy's builting RandomState.
            silent: supress messages
            out_activation: output activation function (applied to the readout)
            inverse_out_activation: inverse of the output activation function
        """
        # check for proper dimensionality of all arguments and write them down.
        self.n_inputs = n_inputs
        self.n_reservoir = n_reservoir
        self.n_outputs = n_outputs
        self.spectral_radius = spectral_radius
        self.sparsity = sparsity
        self.lam = lam
        self.out_activation = out_activation
        self.inverse_out_activation = inverse_out_activation
        self.random_state = random_state
        # the given random_state might be either an actual RandomState object,
        # a seed or None (in which case we use numpy's builtin RandomState)
        if isinstance(random_state, np.random.RandomState):
            self.random_state_ = random_state
        elif random_state:
            try:
                self.random_state_ = np.random.RandomState(random_state)
            except TypeError as e:
                raise Exception("Invalid seed: " + str(e))
        else:
            self.random_state_ = np.random.mtrand._rand

        self.silent = silent
        self.initweights()

    def initweights(self):
        # initialize recurrent weights:
        # begin with a random matrix centered around zero:
        W = self.random_state_.rand(self.n_reservoir, self.n_reservoir) #- 0.5
        # delete the fraction of connections given by (self.sparsity):
        W[self.random_state_.rand(*W.shape) < self.sparsity] = 0
        # compute the spectral radius of these weights:
        radius = np.max(np.abs(np.linalg.eigvals(W)))
        # rescale them to reach the requested spectral radius:
        self.W = W * (self.spectral_radius / radius)
        # random input weights:
        self.W_in = np.zeros((self.n_reservoir, self.n_inputs), dtype=np.float32)
        self.W_in[0:self.n_reservoir // 6, 0] = 1
        self.W_in[self.n_reservoir // 6:self.n_reservoir * 2 // 6, 1] = 1
        self.W_in[self.n_reservoir * 2 // 6:self.n_reservoir * 3 // 6, 2] = 1
        self.W_in[self.n_reservoir * 3 // 6:self.n_reservoir * 4 // 6, 3] = 1
        self.W_in[self.n_reservoir * 4 // 6:self.n_reservoir * 5 // 6, 4] = 1
        self.W_in[self.n_reservoir * 5 // 6:, 5] = 1
        self.W_in = np.multiply(self.W_in, self.random_state_.rand(self.n_reservoir, self.n_inputs) * 0.2 - 0.1)

        #print("self.W_in: \n" + str(self.W_in))

    def _update(self, state, input_pattern):
        """performs one update step.

        i.e., computes the next network state by applying the recurrent weights
        to the last state & and feeding in the current input and output patterns
        """
        preactivation = (np.dot(self.W, state)
                         + np.dot(self.W_in, input_pattern))
        return np.tanh(preactivation)


    def extendstates(self, states):
        if len(states.shape) == 2:
            return np.hstack((states[:, ::2], np.square(states)[:, 1::2]))
        else:
            return np.hstack((states[::2], np.square(states)[1::2]))


    def fit(self, inputs, outputs, inspect=False):
        """
        Collect the network's reaction to training data, train readout weights.

        Args:
            inputs: array of dimensions (N_training_samples x n_inputs)
            outputs: array of dimension (N_training_samples x n_outputs)
            inspect: show a visualisation of the collected reservoir states

        Returns:
            the network's output on the training data, using the trained weights
        """
        # transform any vectors of shape (x,) into vectors of shape (x,1):
        if inputs.ndim < 2:
            inputs = np.reshape(inputs, (len(inputs), -1))
        if outputs.ndim < 2:
            outputs = np.reshape(outputs, (len(outputs), -1))

        inputs_scaled = inputs
        teachers_scaled = outputs

        if not self.silent:
            print("harvesting states...")
        # step the reservoir through the given input,output pairs:
        states = np.zeros((inputs.shape[0], self.n_reservoir))
        for n in range(0, inputs.shape[0]):
            # 初始时间点(第一个时间点)没有hidden state和output,所以都设置为0
            if n == 0:
                states[n, :] = self._update(np.zeros_like(states[0]), inputs_scaled[n, :])

            # 从第二个时间点开始,x(n) = f(wr * x(n-1) + wu * u(n) + wy * y(n-1))
            else:
                states[n, :] = self._update(states[n - 1], inputs_scaled[n, :])

        # learn the weights, i.e. find the linear combination of collected
        # network states that is closest to the target output
        if not self.silent:
            print("fitting...")
        # we'll disregard the first few states:
        #前1000个瞬态不拿来训练
        transient = min(int(inputs.shape[0] / 10), 1000)
        # include the raw inputs:
        #extended_states = np.hstack((states, np.square(states)))
        extended_states = self.extendstates(states)
        #extended_states = np.hstack((states, np.square(states)))
        extstates_trunc = extended_states[transient:, :]
        # Solve for W_out:
        self.W_out = np.dot(teachers_scaled[transient:, :].T, np.dot(extstates_trunc, np.mat(
            np.dot(extstates_trunc.T, extstates_trunc) + np.eye(extstates_trunc.shape[1]) * self.lam).I))

        # remember the last state for later:
        self.laststate = states[-1, :]
        self.lastinput = inputs[-1, :]
        self.lastoutput = teachers_scaled[-1, :]

        # optionally visualize the collected states
        if inspect:
            from matplotlib import pyplot as plt
            # (^-- we depend on matplotlib only if this option is used)
            plt.figure(
                figsize=(states.shape[0] * 0.025, states.shape[1] * 0.1))
            plt.imshow(extended_states.T, aspect='auto',
                       interpolation='nearest')
            plt.colorbar()
            plt.show()

        if not self.silent:
            print("training error:")
        # apply learned weights to the collected states:
        pred_train = self.out_activation(np.dot(extended_states, self.W_out.T))
        if not self.silent:
            print(np.sqrt(np.mean((pred_train - outputs)**2)))
        return pred_train

    def predict(self, inputs, forcestep, xextrastep=0):
        """
        Apply the learned weights to the network's reactions to new input.

        Args:
            inputs: array of dimensions (N_test_samples x n_inputs)
            forcestep: teacher-force的步数
            xextrastep: 第一维额外的teacher-force步数，即第一维总的teacher-force步数为 （forcestep + xextrastep）

        Returns:
            Array of output activations
        """
        if inputs.ndim < 2:
            inputs = np.reshape(inputs, (len(inputs), -1))
        n_samples = inputs.shape[0]

        inputs_scaled = inputs
        states = np.zeros((n_samples, self.n_reservoir))
        outputs = np.zeros((n_samples, self.n_outputs))

        #x为hidden state, u为input, y为output
        for n in range(n_samples):
            #前forcestep步,用teacher-force来更新状态,teacher-force的值为这一步的输入(即上一步应该输出的准确值)
            if n == 0:
                states[n, :] = self._update(np.zeros_like(states[0]), inputs_scaled[n, :])
                outputs[n, :] = self.out_activation(np.dot(self.W_out, self.extendstates(states[n, :])))

            elif n < forcestep:
                #x(n) = f(wr * x(n-1) + wu * u(n) + wy * y(n-1))
                states[n, :] = self._update(states[n - 1, :], inputs_scaled[n, :])
                #y(n) = W *(x(n), u(n))
                outputs[n, :] = self.out_activation(np.dot(self.W_out, self.extendstates(states[n, :])))
            #######
            elif n < (forcestep + xextrastep):
                states[n, :] = self._update(states[n - 1, :], np.hstack((inputs_scaled[n, 0], outputs[n - 1, 1:])))
                # y(n) = W * (x(n), y(n-1))
                outputs[n, :] = self.out_activation(
                    np.dot(self.W_out, self.extendstates(states[n, :])))
            else:
                # 从第forcestep+1步开始, 使用上一步的实际输出y(n-1)作为这一步的输入,teacher-force的值也是上一步的输出
                # x(n) = f(wr * x(n-1) + wu * y(n-1) + wy * y(n-1))
                states[n, :] = self._update(states[n - 1, :], outputs[n - 1, :])
                #y(n) = W * (x(n), y(n-1))
                outputs[n, :] = self.out_activation(
                    np.dot(self.W_out, self.extendstates(states[n, :])))

        return self.out_activation(outputs)
