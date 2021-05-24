import numpy as np
import random

def indexCalcuation(cloads ,cix ):
    return np.sum( cloads*cix);

def CalculationCost(ccix, tix):
    return abs(ccix-tix)

def Limit_Control(x_,mx,ttl):
    x_ttl = np.sum(x_)
    rmng = 0
    rmngmul = np.zeros(len(x_))

    for i in range(len(x_)):
        x_[i] = ttl * (x_[i]/x_ttl)

    for i in range(len(x_)):
        if x_[i]>mx[i] :
            rmng = rmng + (x_[i]-mx[i])
            x_[i] = mx[i]
        rmngmul[i] = mx[i]-x_[i]

    for i in range(len(x_)):
        x_[i] = x_[i] + (rmng * (rmngmul[i] / np.sum(rmngmul)))

    return x_

def PSO_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB):

    m = len(CargoIndex)
    n = 4
    wmax = 0.9
    wmin = 0.4
    c1 = 2
    c2 = 2

    x0 = np.zeros((n, m))
    x = np.zeros((n, m))

    maxiter = 2000
    AccpErr = 0.005

    for i in range(n):
        for j in range(m):
            x0[i, j] = CargoLB[j] + (random.random() * (CargoUB[j] - CargoLB[j]))

        x0[i, :] = Limit_Control(x0[i, :], CargoUB, Remaining_Load)

    x = np.copy(x0);
    v = 0.1 * np.copy(x0)

    t_cal0 = np.zeros((n, 2))

    for i in range(n):
        t_cal0[i, 0] = indexCalcuation(x0[i, :], CargoIndex)
        t_cal0[i, 1] = CalculationCost(t_cal0[i, 0], TargetIndex)

    index0 = np.argmin(t_cal0[:, 1], axis=0)
    fmin0 = t_cal0[index0, 1]

    pbest = np.copy(x0)
    gbest = np.copy(x0[index0, :])

    C_iter = 1
    C_tol = 1

    while (C_iter <= maxiter) and (C_tol > AccpErr):

        w = wmax - (wmax - wmin) * C_iter / maxiter

        for i in range(n):
            for j in range(m):
                v[i, j] = w * v[i, j] + c1 * random.random() * (pbest[i, j] - x[i, j]) \
                          + c2 * random.random() * (gbest[j] - x[i, j])

        for i in range(n):
            for j in range(m):
                x[i, j] = x[i, j] + v[i, j]

        for i in range(n):
            for j in range(m):
                if x[i, j] < CargoLB[j]:
                    x[i, j] = CargoLB[j]
                elif x[i, j] > CargoUB[j]:
                    x[i, j] = CargoUB[j]
        x[i, :] = Limit_Control(x[i, :], CargoUB, Remaining_Load);

        t_cal1 = np.zeros((n, 2))

        for i in range(n):
            t_cal1[i, 0] = indexCalcuation(x[i, :], CargoIndex)
            t_cal1[i, 1] = CalculationCost(t_cal1[i, 0], TargetIndex)

        # print(t_cal0)
        for i in range(n):
            if t_cal1[i, 1] < t_cal0[i, 1]:
                pbest[i, :] = np.copy(x[i, :])
                t_cal0[i, :] = np.copy(t_cal1[i, :])
        # print(t_cal0)

        index = np.argmin(t_cal0[:, 1], axis=0)
        fmin = t_cal0[index0, 1]

        if fmin < fmin0:
            gbest = np.copy(pbest[index, :])
            fmin0 = fmin

        t_indx = indexCalcuation(gbest, CargoIndex)
        C_tol = CalculationCost(t_indx, TargetIndex)
        C_iter = C_iter + 1

    return gbest
