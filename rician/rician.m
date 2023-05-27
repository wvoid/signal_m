function out=rician(pb,K_dB)
r1 = (6).*rand(1,1)-3;
r2 = (10).*rand(1,1)-5;
N=1600; %采样点数
level=30; %直方图等级
K_dB=17;
Rayleigh_ch=zeros(1,N); 
Rician_ch=zeros(1,N);
Rayleigh_ch=(randn(1,N)+j*randn(1,N))/sqrt(2);

% [temp,x]=hist(abs(Rayleigh_ch(1,:)),level);%绘制直方图的函数 
% plot(x,temp,['r-' marker(1)]), hold on
% Rician model
K=10^(K_dB/10);
Rician_ch(1,:) = sqrt(K/(K+1)) + sqrt(1/(K+1))*Rayleigh_ch;
out=pb.*Rician_ch;

% subplot(2,1,1)
% plot(real(pb))
% title('1')
% subplot(2,1,2)
% plot(real(out))
