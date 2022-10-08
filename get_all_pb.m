function pb_mat=get_all_pb(data,pb_index)
fs=3.2e6;
pb_t=0.001;
pb_samples=fs*pb_t;
[~,index]=findpeaks(pb_index);
pb_mat=zeros(length(index),pb_samples);
for n=1:length(index)
    pb_current=data(index(n):index(n)+pb_samples-1,1);
    fai=zeros(31,1);
    for i=1:31
    p1=pb_current((i-1)*100+1:(i-1)*100+100);
    p2=pb_current((i)*100+1:(i)*100+100);
    delta_theta=angle(p1'*p2);
    fai(i)=delta_theta;
    end
    deltaF=sum(fai)/(2*pi*length(fai)*(pb_t/32));
    for k=1:pb_samples
        pb_mat(n,k)=pb_current(k)*exp(-2*pi*j*deltaF*k*(1/fs));
    end
end
end