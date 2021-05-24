function [KargoLoads] = GA_Optm(Remaining_Load , TargetIndex , KargoIndex,KargoUB,KargoLB )

%% Hedefler

DYuk = Remaining_Load; %Daðýtýlacak Yük;
Hedef_Kindex = TargetIndex; %Hedeflenen index

%% Parametreler
ipk = KargoIndex; % Kargo indexleri
           
UB = KargoUB; % Max Kapasiteler

nvars = length(ipk);  %Deðiþken Sayýsý  

LB = KargoLB;




%% Genetik algoritma parametreleri

ival =[1:1:nvars];
%1:1:nvars; % Integer Deðerler

ObjectiveFunction = @(x)GA_simple_fitness(x,Hedef_Kindex,ipk);  %Fitness Fonksiyon
ConstraintFunction =  @(x)GA_simple_constraint(x,DYuk); %Limitleyici foanksiyon

options = optimoptions('ga');
options = optimoptions(options,'MaxGenerations', 100000);  % Maximum iterasyon sayýsý
options = optimoptions(options,'FunctionTolerance', 0.0050); % Maksimum uygunluk toleransý
options = optimoptions(options,'ConstraintTolerance', 0); % maksimum Limitleyici fonksiyon toleransý
options = optimoptions(options,'MaxStallGenerations', 10000); %
options = optimoptions(options,'Display', 'off');

%%



[x,fval] = ga(ObjectiveFunction,nvars, [],[],[],[],LB,UB, ConstraintFunction,ival,options);

KargoLoads = x;

% KabinIndex = Kindexhesapla(x,ipk)
% ToplamYuk = ToplamYukHesapla(x) 
% 
% MAksimumYuk = ToplamYukHesapla(UB)    
   
   
%%
