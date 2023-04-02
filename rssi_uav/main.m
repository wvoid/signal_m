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
    for snr=[8,10,12,14,16,18,20,22,24,26,28,30]
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
for k=1:6
    filename=data(k,:)
    load(filename);
    load(strcat('pb_baseband_',filename));
    pb_mat=deCFO_f(pb_mat);
    pb_mat=deCFO_f(pb_mat);
    pb_mat=deCFO_f(pb_mat);
    pb_mat=deCFO_i(pb_mat,pb_baseband);
    pb_mat=deCFO_f(pb_mat);
    pb_mat=pb_mat(:,1+400:1600-400);
    pb_mat=normalization(pb_mat);
%     pb_mat=pb_mat(:,101:1500);
    filename=strcat('preprocess-pro/',filename);
    save(filename,'pb_mat');
end
%% cutoff
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    temp=[];
    filename=data(k,:)
    load(filename);
    [r,c]=size(pb_mat);
    for a=[0.3,0.4,0.5,0.6,0.7,0.8,0.9]
        a
        pb_mat_new=zeros(r,c);
    for i=1:r
        pb_now=pb_mat(i,:);
        pb_hilbert=hilbert(real(pb_now));
        r1=real(pb_now);
        i1=imag(pb_now);
        edge=a*(mean(abs(pb_hilbert)));
        r1(r1>edge)=edge;
        r1(r1<-edge)=-edge;
        i1(i1>edge)=edge;
        i1(i1<-edge)=-edge;
        p=r1+i1*j;
        pb_mat_new(i,:)=p;
    end
    temp=[temp;pb_mat_new;];
    end
    pb_mat=temp;
    pb_mat=pb_mat(:,1+400:1600-400);
    filename=strcat('cutoff/',filename);
    save(filename,'pb_mat');
end
%% avg_cutoff
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    [r,c]=size(pb_mat);
    for i=1:r
        pb_now=pb_mat(i,:);
        pb_hilbert=hilbert(real(pb_now));
        r1=real(pb_now);
        i1=imag(pb_now);
        edge=0.8*(mean(abs(pb_hilbert)));
        r1(r1>edge)=edge;
        r1(r1<-edge)=-edge;
        i1(i1>edge)=edge;
        i1(i1<-edge)=-edge;
        temp=r1+i1*j;
        pb_mat(i,:)=temp;
    end
    pb_mat=normalization2(pb_mat);
    filename=strcat('cutoff/',filename);
    save(filename,'pb_mat');
end
%% 800
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    pb_mat=pb_mat(:,1+400:1600-400);
    filename=strcat('800/',filename);
    save(filename,'pb_mat');
end
%% 
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    
    filename=data(k,:)
    load(filename);
    [r,c]=size(pb_mat);
    pb_mat_f=zeros(r,c-50);
    for i=1:15
        pb_mat_f(:,(i-1)*50+1:(i-1)*50+50)=fft(pb_mat(:,(i-1)*50+1:(i-1)*50+50))./fft(pb_mat(:,(i)*50+1:(i)*50+50));
    end
    pb_mat=abs(pb_mat_f);
    filename=strcat('feature1/',filename);
    save(filename,'pb_mat');
end
        
        


