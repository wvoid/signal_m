function pb_mat=get_pb_fromfile(filename,preamble_test)
count=100e6;
n=count;
pb_mat=zeros;
f=fopen(filename,'rb');
i=1;
pb_mat=[];

while n==100e6
    [t,n]=fread(f,[2,count],'float');
    n=n/2;
    v=t(1,:)+t(2,:)*1i;
    clear t;
    [idx,x]=CoarseSync(preamble_test,v);
    [p,y]=Fine_sync(preamble_test,v,idx,0.1,x);
    clear idx;
    clear p;
    pb_mat=[pb_mat;get_all_pb(v,y)];
    clear y;
    clear v;
end
fclose(f);
end