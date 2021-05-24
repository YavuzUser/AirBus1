import numpy as np
import PsoFunc as pf
import LnrFunc as lf
import WsaFunc as ws
import GaFunc as ga
import time


HoldSeries = np.array([15,20,35,45,55,65,70,80])


CCcount = 10
CSel = 5

def CreateRandIndex(Lowlim,MaxLim,TTLoad,HCount):
    a_ = np.linspace(Lowlim, MaxLim, num=HCount)
    range_ = (MaxLim - Lowlim) / HCount
    r_ = (  np.random.rand(1, HCount) * range_) - (range_ / 2)
    indxs_ = a_ + r_
    r_ = np.random.rand(1, HCount)
    rs_ = np.sum(r_)
    upls = np.round_((r_ / rs_) * TTLoad)
    return np.vstack((indxs_ , upls))




hsresults = np.zeros((len(HoldSeries),9))

for hs in range(len(HoldSeries)):
    ccresults = np.zeros((CCcount,2))
    # hld wgt indx time err time err
    for cc in range(CCcount):

        tmp1 = CreateRandIndex(-0.008, 0.008, 72322, HoldSeries[hs])
        Remaining_Load = 50000
        TargetIndex = 35
        CargoIndex = tmp1[0]

        CargoUB = tmp1[1]

        CargoLB = np.zeros((len(CargoIndex)))


        # PSO
        t = time.time()
        Cloads = pf.PSO_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB)
        CCindex = pf.indexCalcuation(Cloads,CargoIndex)
        ccresults[cc,0] = time.time() - t
        ccresults[cc,1] = abs(TargetIndex-CCindex)

        #Linear
        # t = time.time()
        # Cloads = lf.Lnr_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB)
        # CCindex = lf.indexCalcuation(Cloads,CargoIndex)
        # ccresults[cc,0] = time.time() - t
        # ccresults[cc,1] = abs(TargetIndex - CCindex)

        #WSA
        # t = time.time()
        # Cloads = ws.WSA_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB)
        # CCindex = ws.indexCalcuation(Cloads,CargoIndex)
        # ccresults[cc,0] = time.time() - t
        # ccresults[cc,1] = abs(TargetIndex - CCindex)

        #GA
        # t = time.time()
        # Cloads = ga.GA_Optm(Remaining_Load,TargetIndex,CargoIndex,CargoUB,CargoLB)
        # CCindex = ga.indexCalcuation(Cloads,CargoIndex)
        # ccresults[cc,0] = time.time() - t
        # ccresults[cc,1] = abs(TargetIndex - CCindex)

        print("HoldCount : %g, Calc : %g" % (HoldSeries[hs], cc))


    
    hldrmins = np.amin(ccresults, axis=0)
    hldrmaxs = np.amax(ccresults, axis=0)
    hldravrg = np.average(ccresults, axis=0)

    tmprslt = [HoldSeries[hs], Remaining_Load, TargetIndex \
           , hldrmins[0],hldrmaxs[0],hldravrg[0] \
           , hldrmins[1], hldrmaxs[1], hldravrg[1] ]

    hsresults[hs,:] = tmprslt;


np.savetxt('data.csv', hsresults, delimiter=';')



