function ki = Kindexhesapla(kix,ipk)


              
      mtt = 0;
       for j=1:length(ipk)
           mtt =mtt + (kix(j)*ipk(j)); 
       end
       
       ki  = mtt;
