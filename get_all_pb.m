function pb_mat=get_all_pb(data,pb_index)
fs=1.6e6;
len_01=50;
pb_t=0.001;
pb_samples=fs*pb_t;
pb_index(pb_index<0.8)=0;
[~,index]=findpeaks(pb_index);

%L1=length(index) 
for n=1:length(index)
    R=zeros(32,1);
    for i=1:32
        if i==32
            pre=pb_current(1:len_01);
            next=pb_current(pb_samples-len_01+1:pb_samples);
            r=corrcoef(pre,next);
            R(i,1)=abs(r(1,2));
            break;
        end
        pb_current=data(index(n):index(n)+pb_samples-1);
        pre=pb_current((i-1)*len_01+1:(i-1)*len_01+len_01);
        next=pb_current((i)*len_01+1:(i)*len_01+len_01);
        r=corrcoef(pre,next);
        R(i,1)=abs(r(1,2));
        
    end
        if sum(R)<31
            pb_index(index(n))=0;
        end
     sum(R)
end
[~,index]=findpeaks(pb_index);
%L2=length(index)

pb_mat=zeros(length(index),pb_samples);
for n=1:length(index)
    index(n)
    pb_current=data(index(n):index(n)+pb_samples-1);
    fai=zeros(31,1);
    for i=1:31
    p1=pb_current((i-1)*len_01+1:(i-1)*len_01+len_01);
    p2=pb_current((i)*len_01+1:(i)*len_01+len_01);
    delta_theta=angle(p1*p2');
    fai(i)=delta_theta;
    end
    deltaF=sum(fai)/(2*pi*length(fai)*(pb_t/32));
    for k=1:pb_samples
        pb_mat(n,k)=pb_current(k)*exp(-2*pi*j*deltaF*k*(1/fs));
    end
end
end