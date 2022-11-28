%%
features_mat=get_PSfeature(pb_mat);
%% 
for k=1:6
    filename=strcat('pb_mat_',num2str(k));
    load(filename);
    [r,~]=size(pb_mat);
    pb_stft_mat=zeros(r,1600);
    for i=1:r
        pb_stft_mat(i,:)=10*log10(abs(reshape(stft((pb_mat(i,:)),1.6e6,"Window",hann(25),"OverlapLength",0),1,1600)));
    end
    filename=strcat('stft/',filename,'_stft');
    save(filename,'pb_stft_mat');
end
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
%% 
[r,~]=size(pb_stft_mat);
for i=1:10
    figure(i)
    mesh(reshape(pb_stft_mat(i,:),25,64))
end
%% 
C_stft=stft(C',1.6e6,"Window",hann(25),"OverlapLength",0);
%% 
for k=1:2
    
    filename=strcat('pb_mat_',num2str(k));
    load(filename);
    [r,~]=size(pb_mat);

    pb_removeH_mat=zeros(r,1600);
    for i=1:r
        pb_removeH_mat(i,:)=abs(fft(real(pb_mat(i,:)))./fft(imag(pb_mat(i,:))));
    end
    filename=strcat('remove_csi/',filename,'removeH');
    save(filename,'pb_removeH_mat');
end

