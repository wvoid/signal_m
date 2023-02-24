function pb_mat=get_pb_fromfile(filename,preamble_test)
count=100e6;
n=count;
pb_mat=zeros;
f=fopen(filename,'rb');
i=1;
pb_mat=[];
% k=1;
while n==100e6
%     k=k+1;
%     if k>2
%         break;
%     end

    [t,n]=fread(f,[2,count],'float');
    n=n/2;
    v=t(1,:)+t(2,:)*1i;
    clear t;
    x=start_detect(v);
    
    y=self_sync(v,x);
    
    clear x;
    z=finesync(v,y,preamble_test);
    clear y;
%     [idx,x]=CoarseSync(preamble_test,v);
%     [p,y]=Fine_sync(preamble_test,v,idx,0.2,x);
%     clear idx;
%     clear p;
    tic
    pb_mat=[pb_mat;get_raw_pb(v,z)];
    toc
    [r,~]=size(pb_mat);
    r
    if r>500
        break;
    end
    clear z;
    clear v;
end
fclose(f);
end