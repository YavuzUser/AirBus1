function f=mypsofnc(x,indxs,tcg)  
% objective function (minimization)
 
mtt = Kindexhesapla(x,indxs);


f=[abs( mtt-tcg) mtt];