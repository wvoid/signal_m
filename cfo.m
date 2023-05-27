clear all;
close all;

% 信号参数
fc_t = 915e6;           % 载波频率
fs = 1.6e6;          % 采样率
t = 0:1/fs:1e-3-1/fs;    % 时间轴
phi = pi/3;         % 相位偏移
f_delta = 140000+32000;     % 频偏
freqsep=64000; %freq_dev

x=[ 0 1 0 1 0 1 0 1];
x=[x x x x x x x x];
x=fskmod(x,2,freqsep,25,1.6e6);
%% 上变频
x_t =x.*exp(1j*(2*pi*fc_t*t));
%% rician fading +awgn
N=1.6e3;
K_dB=55;
Rayleigh_ch=zeros(1,N); 
Rician_ch=zeros(1,N);
Rayleigh_ch=(randn(1,N)+j*randn(1,N))/sqrt(2);
K=10^(K_dB/10);
Rician_ch(1,:) = sqrt(K/(K+1)) + sqrt(1/(K+1))*Rayleigh_ch;
x_t=x_t.*Rician_ch;
% x_t=awgn(x_t,15,'measured');
%% 下变频
fc_r=fc_t-f_delta;
x_r=x_t.*exp(-1j*(2*pi*fc_r*t));
%% get snr 1
evlp=abs(x_r);
p_s=mean(evlp,2).^2;
p_n=var(evlp,0,2);
snr=10*log10(p_s./p_n)
%% get snr 2 
m_2=mean(x_r.*conj(x_r));
m_4=mean((x_r.*conj(x_r)).^2);
p_s=(abs(2*m_2^2-m_4)^(1/2));
p_n=m_2-p_s;
snr=10*log10(p_s./p_n)
%% get rician k
pb_mat=x_r;
[r,c]=size(pb_mat)
K_mat=zeros(r,1);
for i=1:r
    i
    pd=fitdist(abs(pb_mat(i,:))','rician');
    K=(pd.s)^2/(2*pd.sigma^2);
    K_dB=10*log10(K);
    K_mat(i,1)=K_dB
end
%% 
a=angle(x_r(51+7:100+7).*conj(x_r(1+7:50+7)));
mean(a)
b=mean(a)/(2*pi*50*1/fs);
%% 
new_x_r=zeros(1,1600);
for i=1:1600
    new_x_r(i)=x_r(i)*exp(-2*pi*1j*1/fs*i*b);
end
x_r=new_x_r;
%% 

    pb_current=pb_mat(20,:);
    len_01=50;
    fai=zeros(15,1);
    skip=8;
    for i=skip+1:skip+15
    p1=pb_current((i-1)*len_01+1:(i-1)*len_01+len_01);
    p2=pb_current((i)*len_01+1:(i)*len_01+len_01);
    delta_theta=angle(p2.*conj(p1));
    %fai(i-1)=mean(delta_theta)/(2*pi*len_01*1/fs);
    fai(i-skip)=mean(delta_theta);
    end
    fai
    figure(1)
    plot(fai)

%%pull test