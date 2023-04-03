function x=finesync(data,x,preamble,sample_rate)
times=sample_rate/1.6;
[~,index]=findpeaks(x);
len=length(index);
x=zeros(length(data),1);
pb_samples=1600*times;
len_01=50*times;
r=zeros(2,2);
for i=1:len
    R=zeros(len_01,1);
    for k=-len_01/2:len_01/2-1
        r=corrcoef(preamble,data(index(i)+k:index(i)+k+pb_samples-1));
        R(k+(len_01/2+1))=abs(r(1,2));
    end
    [~,idx]=max(R);
    x(index(i)+idx-(len_01/2+1))=1;
end

end