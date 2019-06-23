# -*- coding: utf-8 -*-
"""
Created on Tue Jun 11 14:26:17 2019

@author: chunzhang
"""

import numpy as np
from PRL_ESN2 import ESN
from matplotlib import pyplot as plt
import random

# matplotlib inline
random.seed()
n_random_state_range = range(5)
for find, fn in enumerate(n_random_state_range):
    #train,选择一个数据文件作为训练数据
    datatrain = np.load('filename10.npy')
    random_state = random.randint(0, 100000)
    esn = ESN(n_inputs=6,   #输入和输出维度，改成3维
            n_outputs=6,
            n_reservoir=1500,
            spectral_radius=0.02,
            sparsity=0.97,        #connectivity 1/50
            #random_state=fn,
            random_state=random_state,
            lam=1e-4)

    #print(random_state)
    pred_training = esn.fit(datatrain[:-1], datatrain[1:])

    #预测其中一个文件的数据
    datapredict= np.load('filename5.npy')
    print(datapredict.shape)

    # predicttotallen:预测数据的总长度,
    # predictforcestep:使用teacher-force的步数,
    # 即预测数据的前1000步用teacher-force update,之后1000步就run freely
    predicttotallen = 5000
    predictforcestep = 10
    predictxextrastep = 0
    prediction = esn.predict(datapredict[:predicttotallen], forcestep=predictforcestep, xextrastep=predictxextrastep)

    print("test error: \n" + str(np.sqrt(np.mean((prediction[predictforcestep:] - datapredict[predictforcestep + 1:predicttotallen + 1])**2))))

    from scipy.io import savemat
    savemat("prediction.mat", {"prediction": prediction})

    ylabellist = ["x1", "y1", "z1", "x2", "y2", "z2"]
    for figi in range(datapredict.shape[1]):
        plt.figure(figsize=(12, 8))
        xgrid = np.array(range(0, predicttotallen))
        plt.plot(xgrid * 0.02, datapredict[0:predicttotallen, figi], 'b', linewidth=2.0, linestyle='--', label="target system")
        plt.plot(xgrid * 0.02, prediction[0:, figi], 'r', linewidth=2.0, linestyle='-', label="free running ESN")
        lo, hi = plt.ylim()
        plt.legend(loc='best', fontsize='x-large')
        plt.xticks(fontsize='xx-large')
        plt.yticks(fontsize='xx-large')
        #plt.xlim((20, 60))
        #new_ticks = np.linspace(20, 60, 21)
        #print(new_ticks)
        #plt.xticks(new_ticks)
        plt.xlabel("t", fontsize=30)
        plt.ylabel(ylabellist[figi], fontsize=30)
        plt.savefig("result" + str(figi) + ".png")
        plt.show()
