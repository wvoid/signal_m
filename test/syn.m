%%相关参数预设
ps=1e6
N=64
fs=3.2e6
len=N*fs/ps
m=3.5
freqsep=63750
fc=915e6
x=[0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 ];
%data_complex=read_complex_binary('915_sp10mhz',40e6);
fsk_data=fskmod(x,2,freqsep,50,3.2e6);
t=0:1/fs:(3200-1)/fs;
f0=cos(2*pi*fc.*t)+sin(2*pi*fc.*t)*sqrt(-1);
C=(fsk_data.*f0);
%% 
figure(1);
plot(real(C));
figure(2);
plot(real(fsk_data));