function x=finesync(data,x,preamble)

[~,index]=findpeaks(x);
len=length(index);
x=zeros(length(data),1);
pb_samples=1600;
r=zeros(2,2);
for i=1:len
    R=zeros(50,1);
    for k=-25:24
        r=corrcoef(preamble,data(index(i)+k:index(i)+k+pb_samples-1));
        R(k+26)=abs(r(1,2));
    end
    [~,idx]=max(R);
    x(index(i)+idx-26)=1;
end

end