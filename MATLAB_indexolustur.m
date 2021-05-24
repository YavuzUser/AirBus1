function [indxs,upls] = indexolustur(low,max,ttlod,cnt)

TL = ttlod;
ilk=low;
son=max;
say = cnt;
a = linspace(ilk,son,say);
range=(son-ilk)/say;
r = (rand(1,say)*range)-(range/2);
indxs = a+r;
r = rand(1,say);
rs = sum(r);
upls = round((r/rs)*72322);
