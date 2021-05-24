function f=mypsofnckontrol(x,mx,ttl) 
% clc;
 xttl = sum(x);
 kalan =  0;

       for i=1:length(x)
           x(i) = ttl*(x(i)/xttl);
       end
 
       for i=1:length(x)
           if x(i)>mx(i)
           kalan = kalan + x(i)-mx(i);
           x(i)=mx(i);
           end  
           kalankat(i) = mx(i)-x(i);
       end
       
       for i=1:length(x)
           x(i) = x(i)+ (kalan *  (kalankat(i) /   sum(kalankat) ) );
       end
%        sum(x)
       f = x;