function pb_mat_decfo=deCFO(pb_mat)
fs=1.6e6;
len_01=50;
pb_t=0.001;
pb_samples=fs*pb_t;
[r,~]=size(pb_mat);


pb_mat_decfo=zeros(r,pb_samples);
for n=1:r
    
    pb_current=pb_mat(n,:);
    fai=zeros(31,1);
    for i=1:31
    p1=pb_current((i-1)*len_01+1:(i-1)*len_01+len_01);
    p2=pb_current((i)*len_01+1:(i)*len_01+len_01);
    delta_theta=angle(p1.*conj(p2));
    fai(i)=mean(delta_theta)/(2*pi*len_01*1/fs);
    end
    deltaF=sum(fai)/length(fai);
    for k=1:pb_samples
        pb_mat_decfo(n,k)=pb_current(k)*exp(-2*pi*j*deltaF*k*(1/fs));
    end
end
end