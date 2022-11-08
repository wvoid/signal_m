function pb_mat=get_raw_pb(data,x)
[~,pb_start_idx]=findpeaks(x);
len=length(pb_start_idx);
samples=1600;
pb_mat=zeros(len-1,samples);
for i=1:len-1
    now=pb_start_idx(i)
    pb_mat(i,:)=data(now:now+samples-1);
end
end