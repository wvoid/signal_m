function pb_mat=get_pb_fromfile(filename,preamble_test)
count=120e6;
n=count;
pb_mat=zeros;
f=fopen(filename,'rb');
i=1;
pb_mat=[];
sample_rate=1.6;
% k=1;
while n==120e6
%     k=k+1;
%     if k>2
%         break;
%     end

    [t,n]=fread(f,[2,count],'float');
    n=n/2;
    v=t(1,:)+t(2,:)*1i;
    clear t;
    x=start_detect(v,sample_rate);
    
    y=self_sync(v,x,sample_rate);
    
%     pb_mat
    clear x;
    z=finesync(v,y,preamble_test,sample_rate);
    clear y;
    tic
    pb_mat=[pb_mat;get_raw_pb(v,z,sample_rate)];
    toc
    [r,~]=size(pb_mat);
    r
    if r>1000
        break;
    end
    clear z;
    clear v;
end
fclose(f);
end