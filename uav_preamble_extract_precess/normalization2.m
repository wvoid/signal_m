function pb_mat_nml=normalization2(pb_mat)
fs=1.6e6;
len_01=50;
pb_t=0.001;
pb_samples=fs*pb_t;
[r,c]=size(pb_mat);
pb_mat_nml=zeros(r,c);
for n=1:r
    pb_current=pb_mat(n,:);
    r=mean(abs(real(pb_current)));
    i=mean(abs(imag(pb_current)));
    pb_current=real(pb_current)/r+1i*imag(pb_current)/i;
    pb_mat_nml(n,:)=pb_current;
end
end