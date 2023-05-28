function x = start_detect(data,sample_rate)
times=sample_rate/1.6;
d=abs(data);
len=length(d);
step=1e6*times;
x=zeros(len,1);
for i=1:step:len
    e=i+step-1;
    if e>len
        e=len;
    end
temp=d(i:e);
avg_d=mean(temp);
temp(temp<1.2*avg_d)=0;
temp_var=zeros(length(temp),1);
for k=1:50*times:length(temp)
    e1=k+50*times-1;
    if e1>length(temp)
        e1=length(temp);
    end
    temp_var(k)=var(temp(k:e1));
end
max_x=max(temp_var)
avg_x=mean(temp_var);
temp_var(temp_var<max_x/3)=0;
x(i:e)=temp_var;
end



% x=zeros(len,1);
% for i=1:50:len-2000
%     x(i)=var(d(i:i+50));
% end
% max_x=max(x);
% x(x<max_x/5)=0;
end