function [start,pt]=Coarse_sync(txwave,data,nFFT,cpLength,Number,GT,pt)
n=length(data);
cor=zeros(n-nFFT-cpLength-GT,1);
k1=0;
k2=1;
k3=0;
%% ��txwave�����
if k1
x=zeros(1,nFFT+cpLength+GT);
for k = 1:nFFT+cpLength+GT
    numi=k;
    for i = 1:Number-1
        R=corrcoef(txwave(12:1745),data(numi:numi+nFFT+cpLength-1));
        x(k)= x(k)+abs(R(1,2));
        numi = numi+nFFT+cpLength+GT;
        %cor(i)=data(i:i+Ng(1)-1)*(data(i+Nfft:i+Nfft+Ng(1)-1))';% '�ǹ���ת��  .'��ת��
    end
end
%figure(pt);pt=pt+1;plot(abs(cor))
[~,start]=max(x);
end

%% ��CP���
if k2
for i = 1:n-nFFT-cpLength-GT
    R=corrcoef(data(i:i+cpLength-1),data(i+nFFT:i+nFFT+cpLength-1));
    cor(i)=R(1,2);
     %cor(i)=data(i:i+Ng(1)-1)*(data(i+Nfft:i+Nfft+Ng(1)-1))';% '�ǹ���ת��  .'��ת��
end%��160��ͬ�����ҵ���һ��cp��ʼ�ĵ�
%figure(pt);pt=pt+1;plot(real(cor));figure(pt);pt=pt+1;plot(imag(cor));
[~,start]=max(abs(cor(1:2*(cpLength+nFFT+GT))));
end

%% ��GT���ж�
if k3
y=zeros(1,nFFT+cpLength+GT);
for k = 1:nFFT+cpLength+GT
    numi=k;
    for i = 1:2*Number-1        
        y(k)= y(k)+sum(abs(data(numi:numi+GT-1)));
        numi = numi+nFFT+cpLength+GT;
        %cor(i)=data(i:i+Ng(1)-1)*(data(i+Nfft:i+Nfft+Ng(1)-1))';% '�ǹ���ת��  .'��ת��
    end
end
%figure(pt);pt=pt+1;plot(abs(cor))
[~,start]=min(y);
start=start+GT;
end
end

