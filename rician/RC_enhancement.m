function out= RC_enhancement(pb)
% channel define
r1 = (5).*rand(4,1)-25;
r2=(3).*rand(4,1)-1.5;
r1(1)=0;
pathDelays = ([0 20 80 120 ]+r1')*1e-7;
avgPathGains = [14 -0.9 -4.9 -8 ]+r2';
rician_channel = comm.RicianChannel( ...
    'SampleRate',1.6e6, ...
    'PathDelays',pathDelays, ...
    'AveragePathGains',avgPathGains, ...
    'KFactor',10, ...
    'MaximumDopplerShift',30,...
    'PathGainsOutputPort',true);
%% input
[out]=rician_channel(pb')';
% out=awgn(out,35);
subplot(2,1,1)
% plot(abs(fft(pb,160000)));
plot(real(pb));
subplot(2,1,2)
% plot(abs(fft(out,160000)));
plot(real(out));
%% 
% ch_fft=fft(pb_fly)./fft(pb);
% ch=ifft(ch_fft);
% out_fly=conv(pb,ch,'same');
% plot(abs(ch_fft));
%% 瑞利分布
