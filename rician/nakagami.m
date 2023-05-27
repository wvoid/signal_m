k=5;
m=((k+1)^2)/(2*k+1);
pd=makedist('Nakagami','mu',m);
hl=(random(pd,1,1000)+j*random(pd,1,1000)).*sqrt(0.5)
hist(abs(hl),100)