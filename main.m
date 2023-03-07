
%% -----------------读文件--------------------
data_complex=read_complex_binary('h2',100e6);
% data_complex=data_complex(60e6:70e6,1);
%% 
data_complex=data_complex(150e6:200e6);
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
%  subplot(2,1,2);
%  plot(idx);
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
%preamble_test=data_complex(52623800+20:52623800-1+1600+20,1);
%preamble_test=data_complex(59.315600e6-10:59.318800e6-1-10,1);
preamble_test=data_complex(7633726:7633726+1600-1);
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
clear;
load pb_h1.mat;
f='h2'
pb_mat=get_pb_fromfile(f,preamble_test);
%% 
clear;
filename=['h1'];
for i=1
load pb_h1.mat;
f=filename(i,:)
pb_mat=get_pb_fromfile(f,preamble_test);
% pb_mat=pb_mat(1:1200,:);
f=strcat('pb_mat/',f,'_1');
save(f,'pb_mat');
end
%% 频偏获取
[r,~]=size(pb_mat);
[pb_mat_noCFO,CFO]=deCFO(pb_mat);
plot([1:r],CFO);
%% 频点漂移
[r,~]=size(pb_mat);
y=zeros(1,r);
for i=1:r
    %figure(i); 
    %plot(abs(fft(pb_mat(i,:),160000)))
    a=abs(fft(pb_mat(i,:),160000));
    [val,peaks]=findpeaks(a,'SortStr','descend');
    
    y(i)=min(peaks(1),peaks(2));
end
plot([1:r],y)
%% 
[r,~]=size(pb_mat);
for i=1:r
    figure(i);
    plot(real(pb_mat(i,:)))
end
%% 手动
tic
x=start_detect(data_complex(8303940:44047900));
y=self_sync(data_complex,x);
toc1
z=finesync(data_complex,y,preamble_test);
% 
pb_mat=get_raw_pb(data_complex,z);