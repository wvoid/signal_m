function pb_mat_deDoppler=noDopplerLos(pb_mat)
fs=1.6e6;
len_01=50;
pb_t=0.001;
pb_samples=fs*pb_t;
[r,~]=size(pb_mat);
pb_mat_deDoppler=zeros(r,pb_samples);
F=(20/(3*10e8))*915e6;
a=(5/(3*10e8))*(2*pi*915e6);
for n=1:r
    pb_current=pb_mat(n,:);
    for k=1:pb_samples
        pb_mat_deDoppler(n,k)=pb_current(k)*exp(-2*pi*j*F*k*(1/fs)*exp(-j*a));
    end
end
end