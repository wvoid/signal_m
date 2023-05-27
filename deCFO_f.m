function [pb_mat_decfo,fai]=deCFO_f(pb_mat,flag)
fs=1.6e6;
len_01=50;
pb_t=0.001;

[r,c]=size(pb_mat);
pb_samples=c;


pb_mat_decfo=zeros(r,pb_samples);
pb_CFO=zeros(1,r);
fai=zeros(r,16);
for n=1:r
    pb_current=pb_mat(n,:);
    
    for i=8:23
    p1=pb_current((i-1)*len_01+1:(i-1)*len_01+len_01);
    p2=pb_current((i)*len_01+1:(i)*len_01+len_01);
    delta_theta=angle(p2.*conj(p1));
%     delta_theta(delta_theta<0)=2*pi-abs(delta_theta(delta_theta<0));
    fai(n,i-7)=(0+mean(delta_theta))/(2*pi*len_01*1/fs);
    end
    deltaF=sum(fai(n,:))/16;
    pb_CFO(1,n)=deltaF;
if deltaF>0&&flag==1
    deltaF=deltaF-32000
end
    for k=1:pb_samples
        pb_mat_decfo(n,k)=pb_current(k)*exp(-2*pi*j*deltaF*k*(1/fs));
    end
end
fai(fai>0)=fai(fai>0)-32000;
end