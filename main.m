
%% 读文件

data_complex=read_complex_binary('915mhz_sp1mhz_preamble',40e6);
%% 
signal_i=real(data_complex);
signal_q=imag(data_complex);
%% 画出iq两路信号波形
subplot(2,1,1)
plot(real(data_complex))
title('I')
xlabel('samples at 2mhz')
ylabel('Amplitude');
subplot(2,1,2)
plot(imag(data_complex))
title('Q')
xlabel('samples at 2mhz')
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
preamble_test=data_complex(3.2479e7:3.2484e7-1,1);
%% 
[idx,x]=CoarseSync(preamble_test,data_complex(10e6:20e6,1));
%% 
[val,i]=sort(x,'descend');
%% 
v=val(1:1000);
idx=i(1:1000)

