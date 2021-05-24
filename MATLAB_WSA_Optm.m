function [KargoLoads] = WSA_Optm(Remaining_Load , TargetIndex , KargoIndex,KargoUB,KargoLB )
prnt=1 ;
grfk = 0;
HedefIndex = TargetIndex;
Tload = Remaining_Load; 

%% WSA Parametreleri
 indiv = 10   ;
 lamda = -0.8;
 iterasyonsayisi=5000;
 kabulpayi=0.02;
    
 step = 0.015; 	%Kullanýcý tanýmlý adým mesagesi baþlangýç parametresi
 Fi = 0.0001;  %	Kullanýcý tanýmlý adým mesagesi sabit parametresi

%% 
ipk = KargoIndex;
 mpmd = KargoUB;  
 
mdcount = size(ipk,2);

if prnt==1
 file=fopen('WSAoptm.txt','w');   
end
     


  MaxLoad = sum(mpmd) ;

   

    

    RLoad=Tload;
    
    % satýr aðýrlýklarý
    for i=1:indiv
        wgts(i) = i ^ lamda;

    end
    
    if prnt==1
     fprintf(file,'\r\n Sýra aðýrlýklarý   \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(wgts', 2)) '\r\n'], wgts);    
    end 
 %baslangic icin random degerler


     %random matris
    for i=1:indiv
        
        RLoad=Tload;
        for k=1:mdcount
            myrand(k)=rand()*mpmd(k);
        end
        myrand_ttl=sum(myrand);
        
        for k=1:mdcount
            myrand(k)= ( myrand(k)/  myrand_ttl)* Tload;
        end        
        myrand;
        myrand_ttl=sum(myrand);
        
        for k=1:mdcount-1

            bk = sum(mpmd(k+1:mdcount));
            minl = max (RLoad - bk , myrand(k));
            minl = min (  mpmd(k) , minl );

            tmp_1 = minl;
             bdm(i,k) = tmp_1;
            RLoad =  RLoad- tmp_1;
        end    
         bdm(i,mdcount) = RLoad;

        
         
         
         bdm(i,mdcount+4) = i;

    end

    for iter=1:iterasyonsayisi

        if prnt==1
         fprintf(file,'\r\n %g Ýterasyon   ',iter);
         fprintf(file,'\r\n ');
        end
  
        %fit value hesapla
    for i=1:indiv    
       bdm(i,mdcount+1) = Kindexhesapla( bdm(i,1:mdcount) , ipk );                                          
        bdm(i,mdcount+2)   =abs (  HedefIndex - bdm(i,mdcount+1)  ); 
        bdm(i,mdcount+3)   = sum(   bdm(i,1:mdcount)  );      
    end
    
    
    if prnt==1
     fprintf(file,'\r\n bdm sýrasýz   \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(bdm, 2)) '\r\n'], bdm');    
    end
     %sýralama islemi
    for i=1:indiv-1
        for j =i+1:indiv
            if abs( bdm(i,mdcount+2) )> abs( bdm(j,mdcount+2))
                tmp_2 = bdm(i , : );
               bdm(i , : )  =  bdm(j , : );
               bdm(j , : ) = tmp_2;
            end
        end
    end
    
    for z =1:indiv 
        sonuc1( bdm(z,mdcount+4) ,iter)=bdm(z,mdcount+1) ;
    end
 
   if prnt==1 
     fprintf(file,'\r\n bdm sýralý  \r\n ');
     fprintf(file,[repmat('%g\t', 1, size(bdm, 2)) '\r\n'], bdm');
   end
   
   if( kabulpayi > abs (  HedefIndex - bdm(1,mdcount+1)  ))
        
        break;
    end

    %küme vektörü
    for j = 1:mdcount
        tmp_3 = 0;
        
            for i=1:indiv

                tmp_3 = tmp_3+ (bdm(i,j) *  wgts(i));

                
            end
            
            massV(j)=tmp_3;
    end
    
   %% EK ****************************************
      massV_ttl = sum(massV);
       for j = 1:mdcount
           massV(j) = (Tload/massV_ttl)* massV(j);
       end    
  %%  ********************************************
    
    massVFit=abs( HedefIndex-Kindexhesapla(massV,ipk));
  
    if prnt==1
     fprintf(file,'\r\n Küme vektörü   ');
     fprintf(file,[repmat('%g\t', 1, size(massV, 2)) '\r\n'], massV');
     fprintf(file,'\r\n Küme vektörü   Fit = %g',massVFit);
     fprintf(file,'\r\n ');
    end
    
   A=iter/(iter+1);  
    B=exp(-A); % Iterasyon Katsayisi  
    r=rand();
    
        if r<=0.95 % yuzde 95 olasilikla gerceklesir
            step=step-B*Fi*step; % step azalir
        else
            step=step+B*Fi*step; % step artar
        end
 
    %Yönlerin Belirlenmesi

    
    
    yonler = zeros(indiv,mdcount);
    for i = 1:indiv
        
        if massVFit<=bdm(i,mdcount+2)
            
            for k = 1:mdcount
                tmp_4 = massV(k)  -     bdm(i,k);
                yonler(i,k)=sign(tmp_4)*step;
            end
            
            if prnt==1
             fprintf(file,'\r\n Hedefe Uzak Yon');   
            end
            
        elseif massVFit>bdm(i,mdcount+2) %küme vektörün uygunluðu eleman uygunluðundan büyükse

       
             if rand()<exp(bdm(i,mdcount+2) - massVFit ) 
    
                 if prnt==1
                     fprintf(file,'\r\n Hedefe Yakýn Yon');
                 end
                 
                 for k = 1:mdcount
                        tmp_4 = massV(k)  -     bdm(i,k);
                        yonler(i,k)=sign(tmp_4)*step;
                 end                                  
           
            else % yukarýdaki þartlar gerçekleþmez ise yön random belirlenir

                if prnt==1
                      fprintf(file,'\r\n Random Yon');
                end
                
                    for k = 1:mdcount
                        yonler(i,k)=sign(-1 + (1+1)*rand())*step;                       
                    end   
             end
        end                     
    end
    
    if prnt==1
     fprintf(file,'\r\n ');
     fprintf(file,'\r\n Yönler');   
     fprintf(file,'\r\n ');
     fprintf(file,[repmat('%g\t', 1, size(yonler, 2)) '\r\n'], yonler');
    end


        for i = 1:indiv
                    for k = 1:mdcount
                        bdm(i,k)=bdm(i,k)+  yonler(i,k) *abs(bdm(i,k));
                        
                        if bdm(i,k)<0
                            bdm(i,k) = 0;
                        end
                        
                    end                          
        end


        
        for i = 1:indiv            
                   for j = 1:mdcount
                          if bdm(i,j)>mpmd(j)
                            bdm(i,j) = mpmd(j);
                        end
                   end    
                    
        end  
        
         for i = 1:indiv
            
                  bdm_ttl = sum(bdm(i,1:mdcount));
                   for j = 1:mdcount
                       bdm(i,j) = (Tload/bdm_ttl)* bdm(i,j);
                   end    
                    
        end 
        
        %sum(bdm(1, 1:17))
        
        

    end   


    for i=1:indiv    
         bdm(i,mdcount+1) = Kindexhesapla( bdm(i,1:mdcount),ipk );                                          
         bdm(i,mdcount+2)   = abs(  HedefIndex - bdm(i,mdcount+1)  ); 
         bdm(i,mdcount+3)   = sum(   bdm(i,1:mdcount)  );      
    end
    

    for z =1:indiv 
        sonuc1( bdm(z,mdcount+4) ,iter+1)=bdm(z,mdcount+1) ;
    end    
if prnt==1    
      fprintf(file,'\r\n ');
     fprintf(file,'\r\n BDM Son');   
     fprintf(file,'\r\n ');
   fprintf(file,[repmat('%g\t', 1, size(bdm, 2)) '\r\n'], bdm');
end

%% Grafik 

if grfk == 1
    
        sncl=size(sonuc1,2);
        figure(1)
        plot(1:250,sonuc1(:,1:250)); 
        xlim([0 250])  
          
        grid on;
        hline = line( [0 iter+1],[HedefIndex HedefIndex]);
        %hline.LineWidth = 2;
        hline.Color = 'r';

        xlabel('First 250 Iteration' );
        ylabel( 'Cargo Index' );
%          figure(2)
%          
%         plot(iter-250:iter-1,sonuc1(:,sncl-249:sncl));  
%         xlim([iter-250 iter-1])  
%         ylim([HedefIndex-10 HedefIndex+10]) 
%         grid on;
%         hline = line( [0 iter+1],[HedefIndex HedefIndex]);
%         
%         %hline.LineWidth = 2;
%         hline.Color = 'r';
      
end

%%

%ylim([HedefIndex-3 HedefIndex+3])

KargoLoads = bdm(1,1:mdcount);
% fprintf('\r\n************************** %g',iter);
        if prnt==1
         fclose(file);
        end
        
    end