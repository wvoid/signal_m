function [pb_mat_decfo,y]=deCFO_i(pb_mat,pb_baseband)
fs=1.6e6;
len_01=50;
pb_t=0.001;
[r,c]=size(pb_mat);
pb_samples=c;
pb_mat_decfo=zeros(r,pb_samples);
for n=1:r
    pb_current=pb_mat(n,:);
    b=abs(corrcoef(pb_current,pb_baseband));
    if b(1,2)>0.3
        cfo_f=0;
    else
        cfo_f=32e3;
    end
    for k=1:pb_samples
        pb_mat_decfo(n,k)=pb_current(k)*exp(2*pi*1i*cfo_f*k*(1/fs));
    end
end
    y=zeros(1,r);
    for i=1:r
    a=abs(fft(pb_mat_decfo(i,:),1600));
    [val,peaks]=findpeaks(a,'SortStr','descend');
    y(i)=min(peaks(1),peaks(2));
    end
    
    pb_mat_decfo=pb_mat_decfo(find((mean(y)-16)<y&y<(mean(y)+0.5)),:);
  
end