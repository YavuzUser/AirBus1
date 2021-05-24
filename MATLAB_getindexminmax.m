function [iminmax] = getindexminmax(ki,kub)

% KargoIndex = [-0.00696 -0.00605 -0.00515 -0.00424 ...
%            -0.00334 -0.00244 -0.00153 -0.00063 ...
%            0.00028 0.00118 0.00209 0.00299 ...
%            0.00389 0.00496 0.00595 0.00693 0.00792 ]; % Kargo indexleri
       
% KargoUB = [2826 3123 3391 3391 4687 6033 6033 6033 6033 5945 4037 4037 3725 3714 3714 3059 2541];
load =1+ floor(rand()*sum(kub));


kalan = load;
minindx = 0;
i = 0;
    while ((kalan > 0) && (i<18)) 
        i = i+1;
        if kalan > kub(i)
            minindx = minindx + (kub(i)*ki(i));
            kalan = kalan - kub(i);
        else
            minindx = minindx + (kalan*ki(i));
            kalan=0;
        end
    end
    
kalan = load;
maxindx = 0;
i = 18;
    while ((kalan > 0) && (i>0)) 
        i = i-1;
        if kalan > kub(i)
            maxindx = maxindx + (kub(i)*ki(i));
            kalan = kalan - kub(i);
        else
            maxindx = maxindx + (kalan*ki(i));
            kalan=0;
        end
    end

  indxrange = maxindx - minindx;

  tarindx = minindx + (rand()*indxrange);
   iminmax =  [load tarindx];