function features_mat=get_PSfeature(pb_mat)
[r,c]=size(pb_mat);
len_1B=c/8;
features_mat=zeros(r,2*len_1B-1);
for i=1:r
    y1=pb_mat(i,2*len_1B+1:3*len_1B);
    x1=pb_mat(i,1*len_1B+1:2*len_1B);
    x2=pb_mat(i,5*len_1B+1:6*len_1B);
    y2=pb_mat(i,6*len_1B+1:7*len_1B);
    c1=xcorr(x1,y1);
    c2=xcorr(x2,y2);
    p1=fft(c1);
    p2=fft(c2);
    re=abs(p1)./abs(p2);
    features_mat(i,:)=re;
end
end