function pb_mat_nml=normalization(pb_mat)
fs=1.6e6;
len_01=50;
pb_t=0.001;
pb_samples=fs*pb_t;
[r,~]=size(pb_mat);
pb_mat_nml=zeros(r,pb_samples);
for n=1:r
    pb_current=pb_mat(n,:);
    pb_current=pb_current./max(abs(pb_current));
    pb_mat_nml(n,:)=pb_current;
end
end