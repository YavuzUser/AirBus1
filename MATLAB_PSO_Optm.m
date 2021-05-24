function [KargoLoads] = PSO_Optm(Remaining_Load , TargetIndex , KargoIndex,KargoUB,KargoLB )
prnt=0 ;
grfk = 0;
Tload = Remaining_Load ;%*************************
Tcg =TargetIndex;

ipk = KargoIndex; %indexler
LB=KargoLB;         %lower bounds of variables 
UB=KargoUB;      %upper bounds of variables   


%% pso parameters values
m= length(KargoIndex) ;   % number of variables 
n=10; %100;          % population size 
%n=100;          % population size 
wmax=0.9;       % inertia weight 
wmin=0.4;       % inertia weight 
c1=2;           % acceleration factor
c2=2;           % acceleration factor   

maxite=10000 ; % set maximum number of iteration
Hatakabul = 0.001;
grppionts=[];

maxrun=1;      % set maximum number of runs need to be 
say=0;
if prnt==1
 file=fopen('PSOoptm.txt','w');   
end
%%


      
        
    for i=1:n         
        for j=1:m             
            x0(i,j)=round(LB(j)+rand()*(UB(j)-LB(j)));         
        end
       x0(i,:) =  mypsofnckontrol(x0(i,:) , UB ,Tload);      
    end

    x=x0 ;    
    % Rastgele baþlangýç deðerleri belirlendi
    
    if prnt==1
     fprintf(file,'\r\n Baþlangýç sürüsü   \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(x', 2)) '\r\n'], x);    
    end     

    v=0.1*x0;    
    % Rastgele baþlangýç hýzlarýnýn belirlendi
    for i=1:n  
        tsnc =  mypsofnc(x0(i,:),ipk,Tcg);
        f0(i,1) =tsnc(1); % Elemanlarýn uygunluk deðerleri   
    end
    [fmin0,index0]=min(f0);         
    pbest=x0  ;             % En iyi sürü    
    gbest=x0(index0,:) ;    % en iyi sürü elemaný    
    
    if prnt==1
     fprintf(file,'\r\n En iyi sürü  \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(pbest', 2)) '\r\n'], pbest);
     fprintf(file,'\r\n En iyi sürü uygunluk  \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(f0(:,1)', 2)) '\r\n'], f0(:,1));
     fprintf(file,'\r\n En iyi sürü elemaný  \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(gbest', 2)) '\r\n'], gbest);      
    end       
    % pso initialization------------------------------------------------end   
  
 % pso algorithm---------------------------------------------------start     
    ite=1;        
    tolerance=1;     
    while ite<=maxite && tolerance>Hatakabul

        w=wmax-(wmax-wmin)*ite/maxite; % Haraketsizlik aðýrlýðýnýn hesaplanmasý          
        % pso hýzlarýn güncellenmesi     
        for i=1:n             
            for j=1:m                
                v(i,j)=w*v(i,j)+c1*rand()*(pbest(i,j)-x(i,j))...
                    +c2*rand()*(gbest(1,j)-x(i,j));             
            end
        end
        
        % Sürü elemanlarýnýn pozisyonlarýnýn güncellenmesi   
        for i=1:n            
            for j=1:m                 
                x(i,j)=x(i,j)+v(i,j);            
            end
        end
         

        % Limitlerin kontrolü     
        for i=1:n             
            for j=1:m                
                if x(i,j)<LB(j)                    
                    x(i,j)=LB(j);                
                elseif x(i,j)>UB(j)                    
                    x(i,j)=UB(j);                
                end
            end

           x(i,:) =  mypsofnckontrol(x(i,:) , UB ,Tload);      
 
        end
        
%         x        
        
        % Uygunluk deðerlerinin hesaplanmasý     
        for i=1:n            
            
             tsnc =  mypsofnc(x(i,:),ipk,Tcg);
             f(i,1) =tsnc(1);      
        end
        
        % updating pbest and fitness        
        for i=1:n            
            if f(i,1)<f0(i,1)
                pbest(i,:)=x(i,:);                
                f0(i,1)=f(i,1);             
            end
        end
        [fmin,index]=min(f0);   % finding out the best particle        
%         ffmin(ite,run)=fmin;    % storing best fitness         
%         ffite(run)=ite;         % storing iteration count    
        
        % updating gbest and best fitness         
        if fmin<fmin0             
            gbest=pbest(index,:);  
            fmin0=fmin;         
        end
        
            if prnt==1 && ite==250 
                fprintf(file,'\r\n %g. Ýterasyon \r\n ',ite);
             fprintf(file,'\r\n En iyi sürü  \r\n ');
             fprintf(file,[repmat('%g\t', 1, size(pbest', 2)) '\r\n'], pbest);
             fprintf(file,'\r\n En iyi sürü uygunluk  \r\n ');
             fprintf(file,[repmat('%g\t', 1, size(f0(:,1)', 2)) '\r\n'], f0(:,1));
             fprintf(file,'\r\n En iyi sürü elemaný  \r\n ');
             fprintf(file,[repmat('%g\t', 1, size(gbest', 2)) '\r\n'], gbest);      
            end  
        
        % calculating tolerance 
       
%          if ite>100;  
%             tolerance=abs(ffmin(ite-100,run)-fmin0);         
%          end
         % displaying iterative results
%         if ite==1             
%             fprintf('Iteration    Best particle    Objective fun\n');         
%         end
        tsnc =  mypsofnc(gbest,ipk,Tcg);
%         fprintf('%g  %g          %g   %g \r\n  ',ite,index,fmin0,tsnc(2));     
tolerance = tsnc(1);
%             tsnc =  mypsofnc(gbest,Tcg)
         mysnc(ite) = tsnc(2);

        ite=ite+1;    
    end
    % pso algorithm-----------------------------------------------------end     
%     gbest ;
%  fprintf('PSO Hata Kabul Iter:%g tol:%g hatapay:%g',ite,tolerance,Hatakabul); 
%     if tolerance>Hatakabul
%        fprintf('PSO Hata Kabul Iter:%g',ite);  
%     end
     
%     fvalue=10*(gbest(1)-1)^2+20*(gbest(2)-2)^2+30*(gbest(3)-3)^2;    
%     fff(run)=fvalue;    
%     rgbest(run,:)=gbest;   
%     fprintf('--------------------------------------\n'); 


            if prnt==1 
                fprintf(file,'\r\n Sonuç %g. Ýterasyon\r\n ',ite);
             fprintf(file,'\r\n En iyi sürü  \r\n ');
             fprintf(file,[repmat('%g\t', 1, size(pbest', 2)) '\r\n'], pbest);
             fprintf(file,'\r\n En iyi sürü uygunluk  \r\n ');
             fprintf(file,[repmat('%g\t', 1, size(f0(:,1)', 2)) '\r\n'], f0(:,1));
             fprintf(file,'\r\n En iyi sürü elemaný  \r\n ');
             fprintf(file,[repmat('%g\t', 1, size(gbest', 2)) '\r\n'], gbest);      
            end  
            
        if prnt==1
         fclose(file);
        end
        
if grfk == 1
    
        figure(1)
        plot(1:250,mysnc(1,1:250)); 
        xlim([0 250])  
          
        grid on;
        hline = line( [0 250],[TargetIndex TargetIndex]);
        %hline.LineWidth = 2;
        hline.Color = 'r';

        xlabel('Iteration' );
        ylabel( 'Cargo Index' );

      
end
% [bestfun,bestrun]=min(fff) ;
% best_variables=rgbest(bestrun,:) ;


KargoLoads = gbest;

 
    
    