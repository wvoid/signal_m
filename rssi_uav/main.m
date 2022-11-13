%%
features_mat=get_PSfeature(pb_mat);
%% 
t=stft(preamble_test,1.6e6,"Window",hann(25),"OverlapLength",0);

%% 
for k=1:6
    snr=20;
    filename=strcat('pb_mat_',num2str(k),'_deCFO');
    load(filename);
    pb_mat=awgn(pb_mat,snr);
    filename=strcat('snr/',filename,'_',num2str(snr));
    save(filename,'pb_mat');
end
%% 去载波频偏
for k=1:6
    filename=strcat('pb_mat_',num2str(k));
    load(filename);
    pb_mat=deCFO(pb_mat);
    filename=strcat('deCFO/',filename,'_deCFO');
    save(filename,'pb_mat');
end
