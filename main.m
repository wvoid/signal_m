
%% -----------------读文件--------------------
data_complex=read_complex_binary('915mhz_sp3.2mhz_outdoor',50e6);
%data_complex=data_complex(32e6:100e6,1);
%% 
%data_complex=data_complex/max(abs(real(data_complex)));
%% -----------------分别取实部(I)与虚部(Q)-----------------
signal_i=real(data_complex);
signal_q=imag(data_complex);
%% -----------------iq信号时域波形-----------------
subplot(2,1,1)
plot(real(data_complex))
title('I')
xlabel('number of samples ')
ylabel('Amplitude');
%scatterplot(data_complex(59.315600e6-10:59.318800e6-1-10,1))
 subplot(2,1,2);
 plot(y);
% subplot(2,1,2)
% plot(imag(data_complex))
% title('Q')
% xlabel('number of samples ')
% ylabel('Amplitude')
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
%preamble_test=data_complex(3.2479e7:3.2481e7-1,1);
preamble_test=data_complex(59.315600e6-10:59.318800e6-1-10,1);
%preamble_test=a.e_fsk;
%% 
preamble_test_1=data_complex(3.2479e7:3.2484e7-1,1);
%% ----------------- 粗同步-----------------
[idx,x]=CoarseSync(preamble_test,data_complex);
%% 细同步
[p,y]=Fine_sync(preamble_test,data_complex,idx,0.2,x);
%% 去频偏
pb_mat=get_all_pb(data_complex,y);
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
fai=zeros(31,1);
for i=1:31
    p1=preamble_test((i-1)*100+1:(i-1)*100+100);
    p2=preamble_test((i)*100+1:(i)*100+100);
    delta_theta=angle(p1'*p2);
    fai(i)=delta_theta;

end
deltaF=sum(fai)/(2*pi*length(fai)*(0.001/32))
y1=zeros(3200,1);
for i=1:3200
    y1(i)=preamble_test(i)*exp(-2*pi*1i*deltaF*i*(1/3.2e6));
end
%% 
a=load('pb.mat');

preamble_test=a.y1;
%preamble_test=preamble_test/max(abs(real(preamble_test)));
plot(real(preamble_test));