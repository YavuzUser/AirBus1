function [c, ceq] = GA_simple_constraint(x , tlpyk)

   tyuk = ToplamYukHesapla(x);
   
   c = [ tlpyk- tyuk ; tyuk - tlpyk ];
   ceq=[];
