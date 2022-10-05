%%相关参数预设
ps=1e6
N=100
fs=32e6
len=N*fs/ps
m=3.5
freqsep=m*ps
fc=6e6
x=randi([0 1],1,N);
%data_complex=read_complex_binary('915_sp10mhz',40e6);
fsk_data=fskmod(x,2,freqsep,32,fs);
t=0:1/fs:(len-1)/fs;
f0=cos(2*pi*fc.*t)+sin(2*pi*fc.*t)*sqrt(-1);
C=real(fsk_data.*f0);
%% 

plot(C)