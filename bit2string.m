fid=fopen("915mhz_2","r")
[data,count]=fread(fid,10000,"ubit8")
%% 

a=data(1:4,1)
a(3,1)
b=a(1,1)*8+a(2,1)*4+a(3,1)*2+a(4,1)*1
%% 
i=1
data_hex=zeros(2500,1)
a=zeros(4,1)
while i<2501
    a=data((i-1)*4+1+1:i*4+1,1);
    data_hex(i,1)=a(1,1)*8+a(2,1)*4+a(3,1)*2+a(4,1)*1;
    i=1+i;
end
%% 
data=data.';
data=num2str(data);
data=string(data)
