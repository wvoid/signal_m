function [preambleIdx,x] = CoarseSync(stdPreamble,data)
%% 粗同步
%INPUT:
% stdPreamble 标准前导码
% data 信号数据
%OUTPUT:
% preambleIdx 前导码下标
%% ----------------- 归一化幅值-----------------
A_data_max=max(abs(real(data)));
data=data/A_data_max;
A_stdP_max=max(abs(real(stdPreamble)));
stdPreamble=stdPreamble/A_stdP_max;
%%

len1 = length(stdPreamble); % 前导码长度
len2 = length(data); % 信号长度
col = len2-len1+1; % 遍历次数
x = zeros(1,col); % 结果数组

for cur = 1:col
    R = corrcoef(stdPreamble, data(cur:cur+len1-1, 1)); % 计算相关系数
    x(cur) = abs(R(1, 2));
end
[~, preambleIdx]= max(x);  % 取最大相关系数对应的结果的下标

end
