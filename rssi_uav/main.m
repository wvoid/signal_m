%%Preprocess
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for i=1:6
    f=data(i,:);
    load(f);
    pb_mat=pb_mat(:,1+100:1600-100);
    pb_mat=deCFO(pb_mat);
    pb_mat=normalization(pb_mat);
    filename=strcat('preprocess/',f);
    save(filename,'pb_mat');
end
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
%% 归一化
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2']
%for i=[5,6,7,8,9,10,11,12,13,14,16,18,20,25,30,35,40]
for k=1:6
    filename=strcat(data(k,:))
    load(filename);
    pb_mat=normalization(pb_mat);
    filename=strcat('normal/',filename);
    save(filename,'pb_mat');
%end
end
%% 添加噪声
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=5:6
    snr=10;
    filename=data(k,:)
    load(filename);
    pb_mat=awgn(pb_mat,snr);
    filename=strcat('snr/',filename,'_',num2str(snr));
    save(filename,'pb_mat');
end
%% 去载波频偏
data=['h1';'h2';'h3';'h4';'v1';'v2']
for k=2
    snr=70;
    filename=data(k,:)
    load(filename);
    pb_mat=deCFO(pb_mat);
    filename=strcat('noCFO/',filename);
    save(filename,'pb_mat');
end
%% 去多普勒+相位补偿
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    pb_mat=noDopplerLos(pb_mat);
    pb_mat=deCFO(pb_mat);
    pb_mat=normalization(pb_mat);
    filename=strcat('test/',filename);
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

