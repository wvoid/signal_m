function [window_info,len_window] = CoarseSync(std_preamble,data)
%% 粗同步
%INPUT:
% std_preamble 标准前导码
% data 信号数据
%OUTPUT:
% window_info 每个窗口相关值数组（相对位置）
% len_window 窗口大小
%%
len_p = length(std_preamble); % 前导码长度
len_d = length(data); % 信号长度
window = len_p; % 初始窗口大小与前导码长度相同
cnt = ceil(len_d/window); % 遍历次数（向上取整）
x = zeros(1,cnt); % 结果数组
head = 1; % 窗口起始位置下标
tail = head+window-1; % 窗口结束位置下标
% 窗口范围为   [head:tail]  左闭右闭区间

for i = 1:cnt
    if tail > len_d
        break;
    end
    R = corrcoef(std_preamble, data(head:tail)); % 计算相关系数
    x(1, i) = abs(R(1, 2));
    head = tail+1;
    tail = head+window-1;
end

window_info = x;
len_window = window;
end
