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
%% 
pb_mat=pb_mat(200,:);
% pb_mat=awgn(pb,1,'measured');
%% GET SNR 1
[r,c]=size(pb_mat);
evlp=abs(pb_mat);
p_s=mean(evlp,2).^2;
p_n=var(evlp,0,2);
snr=10*log10(p_s./p_n);
scatter([1:r],snr,'^');
%% GET SNR 2
[r,c]=size(pb_mat);
m_2=mean(pb_mat.*conj(pb_mat),2);
m_4=mean((pb_mat.*conj(pb_mat)).^2,2);
p_s=(abs(2*m_2.^2-m_4).^(1/2));
p_n=m_2-p_s;
snr=10*log10(p_s./p_n);
scatter([1:r],snr,'^');
%% 添加噪声
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    temp=pb_mat;
    for snr=[10,14,18,22,30]
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
%%  Pro
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    pb_mat=deCFO_f(pb_mat,1);
    pb_mat=deCFO_f(pb_mat,0);
    pb_mat=deCFO_f(pb_mat,0);
%     pb_mat=deCFO_i(pb_mat,pb_baseband);
%     pb_mat=deCFO_f(pb_mat);
    pb_mat=pb_mat(:,1+400:1600-400);
    pb_mat=normalization(pb_mat);
%     pb_mat=pb_mat(:,101:1500);
    filename=strcat('preprocess-pro/',filename);
    save(filename,'pb_mat');
end
%%  800-nothing
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    pb_mat=pb_mat(:,1+400:1600-400);
    pb_mat=normalization(pb_mat);
%     pb_mat=pb_mat(:,101:1500);
    filename=strcat('800/',filename);
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
for k=2
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
%% Phase
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    pb_mat=angle(pb_mat);
    filename=strcat('phase/',filename);
    save(filename,'pb_mat');
end
 %%  rician
data=['h1';'h2';'h3';'h4';'v1';'v2'];
k_db=[21,21,21,21,31,31]
for k=1:6
    filename=data(k,:)
    load(filename);
    [r,c]=size(pb_mat);
    pb_mat=deCFO_f(pb_mat,1);
    pb_mat=deCFO_f(pb_mat,0);
    pb_mat=deCFO_f(pb_mat,0);
    temp=pb_mat;
    pb_mat=normalization(pb_mat);
    for i=1:r
        pb_mat(i,:)=rician(pb_mat(i,:),k_db(k));
%         pb_mat(i,:)=awgn(t',12);
    end
    pb_mat=pb_mat(:,1+400:1600-400);
    pb_mat_origin=temp(:,1+400:1600-400);
    pb_mat=normalization(pb_mat);
    pb_mat_origin=normalization(pb_mat_origin);
%     pb_mat=[pb_mat_origin;pb_mat];
    filename=strcat('preprocess-pro/rician-k/',filename);
    save(filename,'pb_mat');
end
%% RICIAN K estimate
[r,c]=size(pb_mat);
K_mat=zeros(r,1);
for i=1:r
    i
    pd=fitdist(abs(pb_mat(i,:))','rician');
    K=(pd.s)^2/(2*pd.sigma^2);
    K_dB=10*log10(K);
    K_mat(i,1)=K_dB;
end
s=scatter([1:r]*60/700,K_mat(:),8,'Marker','*','MarkerEdgeColor',[0.8500 0.3250 0.0980])
ax=gca
ax.Color=[.98,.97,.95];

ax.TickDir='in';
ax.Box='on';
ax.YGrid='on';
ax.XGrid='on';
ax.GridLineStyle='--';
ax.GridColor=[.9,.88,.82];
ax.GridAlpha=.8;
ax.XColor=[.55,.48,.39];
ax.YColor=[.55,.48,.39];
ax.FontSize=8;
xlabel('时间(s)');
ylabel('莱斯因子K(dB)');
%% get phase shift
clear;
data=['h1';'h2';'h3';'h4';'v1';'v2'];
for k=1:6
    filename=data(k,:)
    load(filename);
    [~,fo_mat]=deCFO_f(pb_mat,1);
    fo_mat=fo_mat(1:end,:);
    filename=strcat('eval/',filename);
    save(filename,'fo_mat');
end


