/*********************************************
 * OPL 20.1.0.0 Model
 * Author: Yavuz User, Bunyamin Atak
 * Creation Date: 8 Sep 2020 at 09:43:37
 *********************************************/

 int holds = ...;;
 
 range idnt = 1..holds;
 
 float indexs[idnt] = ...;
 float Lmaxs[idnt] = ...;
 
 float TargetLoad = ...;
 float TargetIndex = ...; 
 
 dvar float+ Loads[idnt];
 dvar float zz;
 minimize zz;

 subject to 
 {
   forall( i in idnt )
     Loads[i]>=0;   
       
    forall( i in idnt )
      Loads[i] <= Lmaxs[i]; 
   
   
   sum(i in idnt) Loads[i] == TargetLoad ;   
   TargetIndex - (sum(i in idnt) Loads[i]*indexs[i]) <=zz;   
   (sum(i in idnt) Loads[i]*indexs[i]) - TargetIndex <=zz;   
  
 }
 

 

