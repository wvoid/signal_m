
%% 

data_complex=read_complex_binary('915_sp10mhz',40e6);
%% 
signal_i=real(data_complex);
signal_q=imag(data_complex);
%% 
subplot(2,1,1)
plot(real(data_complex))
title('I')
xlabel('samples at 10mhz')
ylabel('Amplitude');
subplot(2,1,2)
plot(imag(data_complex))
title('Q')
xlabel('samples at 10mhz')
ylabel('Amplitude')
%% 
figure(2)
spectrogram(data_complex(36.2e6:36.4e6),1000)
%% 
figure(3)
fin_q = fft(signal_q);
fin_i = fft(signal_i);
nnz(isnan(fin_q))         
nnz(isnan(fin_i))          
subplot(1,2,1); plot(abs(fin_q)); title('q');
subplot(1,2,2); plot(abs(fin_i)); title('i');
%% 
prb = signal_i(8.69e5:8.72e5,1);
%% 
prbdet = comm.PreambleDetector(prb,'Input','Symbol','Detections','First','Threshold',100);
pkt=signal_i;
idx=prbdet(pkt);
%% 
a=[1 3 4 5];
b=[1 3 4 5];
corrcoef(a,b)
