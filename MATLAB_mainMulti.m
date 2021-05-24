clc;
clear;
%% Yük Parametreler
%Remaining_Load = 28454; %Dağıtılacak Yük;
%TargetIndex = 57.136236543231526; %Hedeflenen index


for i=1:1
    rand();
end

kacsefer = 1;
sonuclar = zeros(kacsefer,10);
 for zz = 1:kacsefer
     clc
fprintf(  '\n--- %g ',zz);
% % KargoIndex = [-0.00696 -0.00605 -0.00515 -0.00424 ...
% %            -0.00334 -0.00244 -0.00153 -0.00063 ...
% %            0.00028 0.00118 0.00209 0.00299 ...
% %            0.00389 0.00496 0.00595 0.00693 0.00792 ]; % Kargo indexleri
% %        
% % KargoUB = [2826 3123 3391 3391 4687 6033 6033 6033 6033 5945 4037 4037 3725 3714 3714 3059 2541]; 

[KargoIndex,KargoUB] = indexolustur(-0.008,0.008,72322,60);
       
%res1 = getindexminmax(KargoIndex,KargoUB);


% Remaining_Load = res1(1);
% TargetIndex = res1(2);

Remaining_Load = 50948;
TargetIndex = 38.888;

       

MAksimumYuk = ToplamYukHesapla(KargoUB);   

KargoLB = zeros(1,length(KargoUB));

%% Genetic Algoritma

GA_KargoLoads = zeros(1,length(KargoUB));
GA_zaman = 0;
GA_KabinIndex = 0;
GA_ToplamYuk = 0;
GA_Hata = 0;

tic
%  GA_KargoLoads = GA_Optm(Remaining_Load,TargetIndex,KargoIndex,KargoUB,KargoLB);
%  GA_zaman = toc ;
%  GA_KabinIndex = Kindexhesapla(GA_KargoLoads,KargoIndex);
%  GA_ToplamYuk = ToplamYukHesapla(GA_KargoLoads);  
%  GA_Hata = abs(  TargetIndex-GA_KabinIndex );

 
%% WSA Algoritma 


WSA_KargoLoads = zeros(1,length(KargoUB));
WSA_zaman = 0;
WSA_KabinIndex = 0;
WSA_ToplamYuk = 0;
WSA_Hata = 0;

 tic;
 WSA_KargoLoads = WSA_Optm(Remaining_Load,TargetIndex,KargoIndex,KargoUB,KargoLB);
 WSA_zaman = toc ;
 WSA_KabinIndex = Kindexhesapla(WSA_KargoLoads,KargoIndex);
 WSA_ToplamYuk = ToplamYukHesapla(WSA_KargoLoads);  
 WSA_Hata = abs(  TargetIndex-WSA_KabinIndex );
 
%% PSO Algoritma


PSO_KargoLoads = zeros(1,length(KargoUB));
PSO_zaman = 0;
PSO_KabinIndex = 0;
PSO_ToplamYuk = 0;
PSO_Hata = 0;

tic;
 PSO_KargoLoads = PSO_Optm(Remaining_Load,TargetIndex,KargoIndex,KargoUB,KargoLB);
PSO_zaman = toc ; 
 PSO_KabinIndex = Kindexhesapla(PSO_KargoLoads,KargoIndex);
 PSO_ToplamYuk = ToplamYukHesapla(PSO_KargoLoads) ;  
 PSO_Hata = abs(  TargetIndex-PSO_KabinIndex );
 %% L,neer Algoritma
 
 
A = [ones(1,size(KargoIndex,2)) ;  KargoIndex*-1 ]; 
b = [72322; TargetIndex*-1 ];
Aeq=ones(1,size(KargoIndex,2));

beq = [ Remaining_Load  ];
lb = zeros(1,size(KargoIndex,2));

tic
[X1 , Z1 ] = linprog(KargoIndex,A,b,Aeq,beq,lb,KargoUB);
tme = toc;

 LNE_KargoLoads = X1;
 LNE_zaman = tme ; 
 LNE_KabinIndex = Kindexhesapla(X1,KargoIndex);
 LNE_ToplamYuk = ToplamYukHesapla(X1) ;  
 LNE_Hata = abs(  TargetIndex-LNE_KabinIndex );
 
%% Sonuçlar
% fprintf( '\n\tTotal load to be distributed \t:%g ',Remaining_Load);
% fprintf(  '\n\tTarget Index \t:%g ',TargetIndex);
% fprintf(  '\n--------------------------------');
% fprintf( '\n\t| ******* \t\t\t| LN Optimization \t| WSA Optimization \t| PSO Optimization');
% fprintf( '\n\t| Time   \t\t\t| %.5f \t\t\t| %.5f \t\t\t| %.5f  ',LNE_zaman,WSA_zaman,PSO_zaman);
% fprintf( '\n\t| Load \t\t\t\t| %g \t\t\t\t| %g \t\t\t| %g  ',LNE_ToplamYuk,WSA_ToplamYuk,PSO_ToplamYuk);
% fprintf( '\n\t| T.Index \t\t\t| %.5f \t\t\t| %.5f \t\t\t| %.5f   ',LNE_KabinIndex,WSA_KabinIndex,PSO_KabinIndex);
% fprintf( '\n\t| Error   \t\t\t| %.5f \t\t\t| %.5f \t\t\t| %.5f   ',LNE_Hata,WSA_Hata,PSO_Hata);
% fprintf(  '\n\n Cargo Distribution\n');
% 
% fprintf( '\n\t| ******* \t\t\t| LN Optimization \t| WSA Optimization \t| PSO Optimization');
% for j=1:length(KargoIndex)
%    fprintf( '\n\t| Cargo %g \t\t\t| %.2f \t\t\t| %.2f \t\t\t| %.2f  ',j,LNE_KargoLoads(j),WSA_KargoLoads(j),PSO_KargoLoads(j)); 
% end
% fprintf( '\n END \n');

  sonuclar(zz,:) = [ TargetIndex ,PSO_KabinIndex, PSO_Hata  , PSO_zaman,WSA_KabinIndex, WSA_Hata  , WSA_zaman, LNE_KabinIndex, LNE_Hata  , LNE_zaman  ];

% 
%  clc 
%  zz
% 
 end
 clc
 fprintf( '\n| T.Index\t| PS CI \t| PS ER \t| PS TM \t| WS CI \t| WS ER\t| WS TM\t| LN CI\t| LN ER\t| LN TM ');
 sonuclar

 Means=mean(sonuclar,1)
 
 fprintf( '\n PSO %.5f ',Means(4));
 fprintf( '\n WSA %.5f ',Means(7));
 fprintf( '\n LNR %.5f ',Means(10));
% clc 
% fprintf( '\nBitti\n');
% 
% ortalamalar = mean(sonuclar);
% 
% fprintf( '\nAverage Error %.17f ',ortalamalar(4));
% fprintf( '\nAverage Time %.17f ',ortalamalar(5));
 fprintf( '\n');


