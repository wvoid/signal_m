function x = start_detect(data)
d=abs(data);
avg_d=mean(d);
d(d<avg_d)=0;
len=length(d);
x=zeros(len,1);
for i=1:50:len-2000
    x(i)=var(d(i:i+50));
end
max_x=max(x);
x(x<max_x/5)=0;
end