from scipy.optimize import differential_evolution, LinearConstraint
import numpy as np

def indexCalcuation(cloads ,cix ):
    return np.sum( cloads*cix)

def GA_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB):
    def f(X):
        rslt = abs(35 - indexCalcuation(X, CargoIndex))
        return rslt

    varbound = np.vstack((CargoLB, CargoUB)).transpose()


    Aq = np.ones((1,len(CargoIndex)));
    lnc = LinearConstraint(Aq, Remaining_Load, Remaining_Load, keep_feasible=False)

    result = differential_evolution(f, bounds=varbound,constraints=(lnc))

    return result.x
