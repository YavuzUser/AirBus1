from scipy.optimize import linprog
import numpy as np
import time

def indexCalcuation(cloads ,cix ):
    return np.sum( cloads*cix);

def Lnr_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB):
    MaxLoad = np.sum(CargoUB)

    A = np.vstack((np.ones((1,len(CargoIndex))),CargoIndex*-1))
    b = np.array([MaxLoad, TargetIndex*-1 ])
    Aq = np.ones((1,len(CargoIndex)));
    bq = np.array([Remaining_Load]);

    bnd = (np.vstack((np.zeros((1,len(CargoIndex))),CargoUB))).transpose()

    res = linprog(CargoIndex, A_ub=A, b_ub=b, A_eq=Aq, b_eq=bq, bounds=bnd, options=None)


    return res.x