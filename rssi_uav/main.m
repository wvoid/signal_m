%%
features_mat=get_PSfeature(pb_mat);
%% 
stft(preamble_test,1.6e6,"Window",hann(25),"OverlapLength",0);

%% 
for k=1:6
    snr=40;
    filename=strcat('pb_mat_',num2str(k));
    load(filename);
    pb_mat=awgn(pb_mat,snr);
    filename=strcat('snr/',filename,'_',num2str(snr));
    save(filename,'pb_mat');
end