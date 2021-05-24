import numpy as np
import random
import math

def indexCalcuation(cloads ,cix ):
    return np.sum( cloads*cix);

def WSA_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB):

    indiv = 10
    lamda = -0.8
    IterationCount = 10000
    AccError = 0.02
    step = 0.015
    Fi = 0.0001

    HoldCount = len(CargoIndex)
    MaxLoad = sum(CargoUB)
    myrand = np.zeros(HoldCount)
    wgts = np.zeros(indiv)
    RLoad = 0
    myrand_ttl = 0
    bdm  = np.zeros((indiv,HoldCount+4))
    massV = np.zeros(HoldCount)

    for i in range(indiv):
        wgts[i] = (i+1) ** lamda

    for i in range(indiv):
        RLoad = Remaining_Load
        for k in range(HoldCount):
            myrand[k] = random.random() * CargoUB[k]

        myrand_ttl = sum(myrand)

        for k in range(HoldCount):
            myrand[k] = (myrand[k] / myrand_ttl) * Remaining_Load
        # end

        myrand_ttl = sum(myrand)

        for k in range(HoldCount-1):
            bk = sum(CargoUB[k + 1:HoldCount])
            minl = np.max([RLoad - bk, myrand[k]])
            minl = np.min([CargoUB[k], minl])
            tmp_1 = minl
            bdm[i, k] = tmp_1
            RLoad = RLoad - tmp_1
        # end



        bdm[i, HoldCount-1] = RLoad
        bdm[i, HoldCount + 3] = i
        # end

    for iter in range(IterationCount):
        for i in range(indiv):
            bdm[i, HoldCount + 0] = indexCalcuation(bdm[i, 0:HoldCount], CargoIndex )
            bdm[i, HoldCount + 1] = abs(TargetIndex - bdm[i, HoldCount + 0])
            bdm[i, HoldCount + 2] = sum(bdm[i, 0:HoldCount]);
        # end

        for i in range(indiv - 1):
            for j in range(i+1,indiv):
                if abs(bdm[i, HoldCount + 1]) > abs(bdm[j, HoldCount + 1]):
                    tmp_2 = np.copy(bdm[i,: ])
                    bdm[i,: ]  = np.copy( bdm[j,: ])
                    bdm[j,: ] = np.copy( tmp_2)
                # end
            # end
        # end

        if ( AccError > abs(TargetIndex - bdm[0, HoldCount + 0])):
            break;
        # end

        for j in range(HoldCount):
            tmp_3 = 0
            for i in range(indiv):
                tmp_3 = tmp_3 + (bdm[i, j] * wgts[i])
            # end
            massV[j] = tmp_3;
        # end

        # % % EK ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **
        massV_ttl = sum(massV)
        for j in range(HoldCount):
            massV[j] = (Remaining_Load / massV_ttl) * massV[j]
        # end

        # % % ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** **

        massVFit = abs(TargetIndex - indexCalcuation(massV, CargoIndex))

        A_ = iter / (iter + 1)
        B_ = math.exp(-1 * A_ )
        r_ = random.random()

        if r_ <= 0.95:
            step=step-B_ * Fi * step
        else:
            step=step+ B_ * Fi * step
        # end

        dirctns = np.zeros((indiv, HoldCount))

        for i in range(indiv):
            if massVFit <= bdm[i, HoldCount + 1]:
                for k in range(HoldCount):
                    tmp_4 = massV[k] - bdm[i, k]
                    dirctns[i, k] = np.sign(tmp_4) * step
                # end
            elif massVFit > bdm[i, HoldCount + 1]:
                if random.random() < math.exp(bdm[i, HoldCount + 1] - massVFit):
                    for k in range(HoldCount):
                        tmp_4 = massV[k] - bdm[i, k];
                        dirctns[i, k] = np.sign(tmp_4) * step;
                    # end
                else:
                    for k in range(HoldCount):
                        dirctns[i, k] = np.sign(-1 + (1 + 1) * random.random() ) * step
                    # end
                # end
            # end
        # end
        for i in range(indiv):
            for k in range(HoldCount):
                bdm[i, k] = bdm[i, k] + dirctns[i, k] * abs(bdm[i, k])
                if bdm[i, k] < 0:
                    bdm[i, k] = 0
                # end
            # end
        # end


        for i in range(indiv):
            for j in range(HoldCount):
                if bdm[i, j] > CargoUB[j]:
                    bdm[i, j] = CargoUB[j]
                # end
            # end
        # end

        for i in range(indiv):
            bdm_ttl = sum(bdm[i, 0:HoldCount])
            for j in range(HoldCount):
                bdm[i, j] = ( Remaining_Load / bdm_ttl) * bdm[i, j]
            # end
        # end

        # print(sum(bdm[0, 0:17]))
    # end

    for i in range(indiv):
        bdm[i, HoldCount + 0] = indexCalcuation(bdm[i, 0:HoldCount], CargoIndex )
        bdm[i, HoldCount + 1] = abs(TargetIndex - bdm[i, HoldCount + 0])
        bdm[i, HoldCount + 2] = sum(bdm[i, 0:HoldCount])
    # end

    return bdm[0, 0:HoldCount];
