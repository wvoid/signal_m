function x=self_sync(data,start_index)

[val,peak_index]=findpeaks(start_index);
len=length(peak_index);
len
offset=150;
pb_samples=1600;
len_01=50;
x=zeros(length(data),1);
for m=1:len
    m
    now=peak_index(m);
    R=zeros(offset,16);
    for k=1:offset
        pb_current=data(now+k:now+k+pb_samples-1);
        for i=1:15
            pre=pb_current((i-1)*len_01*2+1:(i-1)*len_01*2+len_01*2);
            next=pb_current((i)*len_01*2+1:(i)*len_01*2+len_01*2);
            r=corrcoef(pre,next);
            R(k,i)=abs(r(1,2));
            
        end
            i=i+1;
            pre=pb_current(1:len_01*2);
            next=pb_current(pb_samples-len_01*2+1:pb_samples);
            r=corrcoef(pre,next);
            R(k,i)=abs(r(1,2));
    end
    sum_R=sum(R,2);
    [max_val,max_index]=max(sum_R);
    max_val
    if max_val>15
        x(now+max_index)=1;
    end
end



end