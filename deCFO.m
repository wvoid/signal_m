function [pb_mat_decfo,pb_CFO]=deCFO(pb_mat)
fs=1.6e6;
len_01=50;
pb_t=0.001;

[r,c]=size(pb_mat);
pb_samples=c;


pb_mat_decfo=zeros(r,pb_samples);
pb_CFO=zeros(1,r);
for n=1:r
    pb_current=pb_mat(n,:);
    fai=zeros(16,1);
    for i=8:23
    p1=pb_current((i-1)*len_01+1:(i-1)*len_01+len_01);
    p2=pb_current((i)*len_01+1:(i)*len_01+len_01);
    delta_theta=angle(p1.*conj(p2));
    fai(i-7)=mean(delta_theta)/(2*pi*len_01*1/fs);
    end
    deltaF=sum(fai)/length(fai);
    pb_CFO(1,n)=deltaF;
    for k=1:pb_samples
        pb_mat_decfo(n,k)=pb_current(k)*exp(2*pi*j*deltaF*k*(1/fs));
    end
end
end