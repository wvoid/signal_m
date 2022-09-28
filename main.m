
%% -----------------读文件--------------------
data_complex=read_complex_binary('915mhz_sp1mhz_preamble',40e6);
%% -----------------分别取实部(I)与虚部(Q)-----------------
signal_i=real(data_complex);
signal_q=imag(data_complex);
%% -----------------iq信号时域波形-----------------
subplot(2,1,1)
plot(real(data_complex))
title('I')
xlabel('number of samples ')
ylabel('Amplitude');
subplot(2,1,2)
plot(imag(data_complex))
title('Q')
xlabel('number of samples ')
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
%% -----------------参考前导码-----------------
preamble_test=data_complex(3.2479e7:3.2481e7-1,1);
%% 
preamble_test_1=data_complex(3.2479e7:3.2484e7-1,1);
%% ----------------- 粗同步-----------------
[idx,x]=CoarseSync(preamble_test,data_complex(10e6:15e6,1));
%% 细同步
y=Fine_sync(preamble_test_1,data_complex(10e6:15e6,1),idx,0.2,x);
%% 
[val,i]=sort(x,'descend');
v=val(1:1000);
idx=i(1:1000);
%% 
a=x;
%% 
figure(4)
plot(a)
xlabel('samples')
ylabel('Correlation coefficient')
%% 
b=[1 2 3 2 1 0 1 1 1 1]
%b(b<1.5)=0
[a1,i]=findpeaks(b)

