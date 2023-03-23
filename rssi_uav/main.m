%%17756400
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
%% 归一化
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2']
%for i=[5,6,7,8,9,10,11,12,13,14,16,18,20,25,30,35,40]
for k=1:6
    filename=strcat(data(k,:))
    load(filename);
    pb_mat=normalization(pb_mat);
    filename=strcat('nml/',filename);
    save(filename,'pb_mat');
%end
end
%% 添加噪声
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    temp=pb_mat;
    for snr=[12,14,16,18]
        pb_mat=[pb_mat;awgn(temp,snr)];
    end
    filename=strcat('snr/',filename);
    save(filename,'pb_mat');
end
%% 去载波频偏
data=['h1';'h2';'h3';'h4';'v1';'v2']
for k=1:6
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
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=2
    filename=data(k,:)
    load(filename);
    pb_mat=deCFO(pb_mat);
    pb_mat=deCFO(pb_mat);
%     pb_mat=deCFO(pb_mat);
    pb_mat=normalization(pb_mat);
    
%     pb_mat=pb_mat(:,101:1500);
    filename=strcat('preprocess/',filename);
    save(filename,'pb_mat');
end
%% cutoff
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=2
    temp=[];
    for edge=[0.4]
    filename=data(k,:)
    load(filename);
    pb_mat=pb_mat(:,1+400:1600-400);
    r1=real(pb_mat);
    i1=imag(pb_mat);
    r1(r1>edge)=edge;
    r1(r1<-edge)=-edge;
    i1(i1>edge)=edge;
    i1(i1<-edge)=-edge;
    pb_mat=r1+i1*j;
    temp=[pb_mat;temp];
    end
    pb_mat=temp;
    filename=strcat('cutoff/',filename);
    save(filename,'pb_mat');
end
%% 
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=2
    filename=data(k,:)
    load(filename);
    pb_mat=pb_mat(:,1+400:1600-400);
    filename=strcat('800/',filename);
    save(filename,'pb_mat');
end
