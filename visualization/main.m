%% scatter frequency point shift with time
data=['h1';'h2';'h3';'h4';'v1';'v2'];
% s=['s','s','s','s','s','s'];
s=['^','^','^','^','^','^'];
% s=['*','*','*','*','*','*'];
color=[[.94,.66,.43];[.66,.35,.36];[.6,.54,.46];[.46,.74,.16];[.16,.24,.66];[.36,.74,.26]];
for k=1:6
filename=data(k,:)
load(filename);
[r,~]=size(pb_mat);
y=zeros(1,r);
j=1;
for i=1:20:r
    a=abs(fft(pb_mat(i,:),160000));
    [val,peaks]=findpeaks(a,'SortStr','descend');
    y(j)=min(peaks(1),peaks(2));
    j=j+1;
end
plot([1:j-1]*10,y(1:j-1)*10,'LineWidth',0.5,'Color',color(k,:),'Marker',s(k),'MarkerSize',4,'MarkerFaceColor',color(k,:));
hold on
end
%整数倍
plot([0,500],10*[1.6e4,1.6e4],'LineWidth',0.25,'Color','k','LineStyle','--')
plot([0,500],10*[1.6e4-2*3.2e3,1.6e4-2*3.2e3],'LineWidth',0.25,'Color','k','LineStyle','--')
plot([0,500],10*[1.6e4-3.2e3,1.6e4-3.2e3],'LineWidth',0.25,'Color','k','LineStyle','--')
%title('各数传开机后频点随时间变化')
xlabel('时间(s)')
ylabel('hz')
lgd=legend(data(1:6,:))
lgd.Location='best';
lgd.Box='on';
lgd.FontSize=8;
lgd.TextColor=[.55,.48,.39];
%title(lgd,"▲=室内静止，■=室外悬停",'Color','k');
%%%%%%%%%%%%%%
ax=gca
ax.Color=[.98,.97,.95];
ax.TickLength=[.002,.02];
ax.TickDir='out';
ax.Box='on';
ax.YGrid='on';
ax.XGrid='on';
ax.GridLineStyle='--';
ax.GridColor=[.9,.88,.82];
ax.GridAlpha=.8;
ax.XColor=[.55,.48,.39];
ax.YColor=[.55,.48,.39];
ax.FontSize=8;
% hold off;


%%%%%%%%%%%%%%%
%%  preamble display
ax=gca
ax.Color=[.98,.97,.95];
ax.TickLength=[.002,.02];
ax.TickDir='out';
ax.Box='on';
ax.YGrid='on';
ax.XGrid='on';
ax.GridLineStyle='--';
ax.GridColor=[.9,.88,.82];
ax.GridAlpha=.8;
ax.XColor=[.55,.48,.39];
ax.YColor=[.55,.48,.39];
ax.FontSize=8;
%% stft
pb=pb_mat(23,:);
stft(pb,1.6e6,"Window",hann(25),"OverlapLength",0,'FFTLength',500)
%%  对比柱状图
figure('position',[150,100,900,550]);
D6_test=[0.5807,0.8197,0.9030]
y=[0.9386,0.9817,0.9544; 0.8769,0.9496,0.9559; 0.6709,0.9263,0.9344; 0.842,0.9264,0.9301;D6_test];
%y=[0.9386,0.956,0.9494; 0.8769,0.951,0.9523; 0.6709,0.921,0.9163; 0.842,0.9194,0.9301];
x=1:5;
grid on;
b=bar(x,y,1);
legend('raw IQ','仅频点对齐','频点对齐+Rician信道增强')
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',8)
xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',8)
xtips3 = b(3).XEndPoints;
ytips3 = b(3).YEndPoints;
labels3 = string(b(3).YData);
text(xtips3,ytips3,labels3,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom','FontSize',8)
set(gca,'XTick',1:5,'XTickLabel',{'D1 Test','D2 Test','D4 Test','D5 Test','D6 Test'})
%% RICIAN K estimate and visualization
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