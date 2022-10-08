function [preamble_index,x] = Fine_sync(std_preamble,data,corr_index,threshold,window)
%% 细同步
%INPUT:
% std_preamble 标准前导码
% data 信号数据
% corr_index 粗同步相关系数下标
% threshold 门限值
% window 窗口大小
%OUTPUT:
% preamble_index 前导码起始下标
%%
samp_rate = 3.2e6;  % 采样率
preamble_time = 0.001;  % 前导码持续时间(s)
len_p = length(std_preamble);  % 前导码长度
preamble_samples_pts = samp_rate*preamble_time;  % 前导码采样点数
corr_index(corr_index<threshold) = 0;  % 小于门限值的位置忽略
[~,peaks_index] = findpeaks(corr_index);% 寻找极大值
x = zeros(1,length(data));

for i = 1:length(peaks_index)  % 遍历每一个极值
    head = (peaks_index(i)-1)*window+1-preamble_samples_pts;  % 窗口起始
    tail = head+len_p-1; % 窗口结束
%     s=head;
%     e=head+2*preamble_samples_pts-1
    for k = 1:2*preamble_samples_pts  % 在对应极值附近遍历次数
        if head<1
            head = 1;
        end
        if tail>length(data)
            break;
        end
        R = corrcoef(std_preamble, data(head:tail, 1)); % 计算相关系数
        x(1,head) = abs(R(1, 2));
        head = head+1;
        tail = head+len_p-1;
        
    end
%     temp=x(1,s:e);
%     temp(temp<max(temp))=0;
%     x(1,s:e)=temp;

end

len_01=100;
preamble_index = x;

preamble_index(preamble_index<0.9)=0;
x = zeros(1,length(data));
R=zeros(1,32);
[~,peaks_index1] = findpeaks(preamble_index);
for i=1:length(peaks_index1)
    head=peaks_index1(i)-2*len_01;
    tail=head+len_01-1;
    temp_head=head;
    temp_tail=tail;
    s=head;
    e=head+4*len_01;
    for k=1:4*len_01
        if head<1
            head = 1;
        end
        if tail+31*len_01>length(data)
            break;
        end
        for i=1:32
            

            r=corrcoef(data(temp_head:temp_tail,1),data(head:tail,1));
            R(1,i)=r(1,2);
            head=head+len_01;
            tail=head+len_01-1;
            
        end
        x(1,temp_head)=sum(abs(R));
        temp_head=temp_head+1;
        temp_tail=temp_head+len_01-1;
        head=temp_head;
        tail=temp_tail;
    end
    temp=x(1,s:e);
    temp(temp<max(temp))=0;
    x(1,s:e)=temp;
end
end