close all;
clear;
clc;

% 单纯打印在命令行窗口
fprintf('OFDM信道估计仿真\n');

%% 参数设置 

carrier_count = 64;  % 单个OFDM符号中的载波数目
num_symbol = 50;     % OFDM符号数量，不包括导频
guard = 8;           % 循环前缀 CP, 即每个OFDM的最后8个子载波作为CP加在开头
pilot_inter = 8;     % 导频间隔，即每隔几个OFDM符号插入一个导频
modulation_mode = 16;% 调制方式, QAM调制的order
SNR = 0:2:20;        % 信噪比取值
num_loop = 15;       % 循环次数

% 每种信噪比做15次实验
num_bit_err = zeros(length(SNR), num_loop);
num_bit_err_dft = zeros(length(SNR), num_loop);
num_bit_err_ls = zeros(length(SNR), num_loop);
MSE = zeros(length(SNR), num_loop);
MSE_dft = zeros(length(SNR), num_loop);
MSE_ls = zeros(length(SNR), num_loop);

%% 主程序

for c1 = 1:length(SNR)
    fprintf('\n\n\n仿真信噪比为%f\n\n', SNR(c1));
    for num1 = 1:num_loop
        %---------------产生发送的随机序列-----------------------
        
        bits_len = carrier_count * num_symbol;
        bits_tx = randi([0 1], 1, bits_len); % 1行bits_len列矩阵
        
        %---------------符号调制-----------------------
        
        modulated_sequence = qammod(bits_tx, modulation_mode);
        
        %---------------导频格式-----------------------
        
        pilot_len = carrier_count; % 导频与OFDM符号同级别
        % rand 默认区间（0，1）
        % round 四舍五入
        % 结束后 pilot_symbols只有0和1，是一个1行pilot_len列矩阵
        pilot_symbols = round(rand(1, pilot_len));
        
        % 将导频信号中的0变为-1，所以目前导频有两种，-1和1
        for i = 1:pilot_len
            if pilot_symbols(1, i) == 0
                pilot_symbols(1, i) = pilot_symbols(1, i) - 1;
            else
                pilot_symbols(1, i) = pilot_symbols(1, i);
            end
        end
         
        % 行向量变列向量
        pilot_symbols = pilot_symbols';
        
        %---------------计算导频和数据数目-----------------------
        
        % ceil 向上取整
        num_pilot = ceil(num_symbol / pilot_inter);
        % rem 取余，返回 num_symbol除以pilot_inter后的余数 
        % 每组符号开头一个导频，结尾还要再加一个导频
        if rem(num_symbol, pilot_inter)==0
            num_pilot = num_pilot + 1;
        end
        
        num_data = num_symbol + num_pilot;
        
        %---------------导频位置计算-----------------------
        
        pilot_index = zeros(1, num_pilot);
        % +1 是算上了导频的位置，此时data_index容量大于 num_symbol
        data_index = zeros(1, num_pilot * (pilot_inter + 1));
        for i = 1:num_pilot-1
            pilot_index(1, i) = (i-1) * (pilot_inter + 1) + 1;
        end
        % 最后一个导频的位置从开头数起要看具体情况
        % 但反正是在最后一个
        pilot_index(1, num_pilot) = num_data;
        
        % 为了插入导频，第一个、最后一个以及每隔8个位的索引都空了出来
        % 缺少的索引值在 pilot_index
        for j = 0:num_pilot
            data_index(1, (1 + j * pilot_inter) : (j + 1) * pilot_inter) = (2 + j * (pilot_inter + 1)) : ((j + 1) * (pilot_inter + 1));
        end
        
        % 将多余的容量去掉
        data_index = data_index(1, 1:num_symbol);
        
        %---------------导频插入-----------------------
        
        % 和之前不一样，每一列为一个OFDM调制符号
        piloted_ofdm_syms = zeros(carrier_count, num_data);
       
        % piloted_ofdm_syms 与 modulated_sequence的列数不一样
        % piloted_ofdm_syms 的列数增加了 导频数
        % 而modulated_sequence的列数只有 OFDM符号数
        
        % 先将 modulated_sequence 中应该是 OFDM符号 的列数依次插入 modulated_sequence 的列
        % data_index 和 modulated_sequence 的列数都是 num_symbol
        piloted_ofdm_syms(:, data_index) = reshape(modulated_sequence, carrier_count, num_symbol);
        % 再将 pilot 插入其索引位
        % pilot_symbols 只是一个列向量，横向扩充 num_pilot 倍成为一个数组
        piloted_ofdm_syms(:, pilot_index) = repmat(pilot_symbols, 1, num_pilot);
        
        %---------------IFFT变换-----------------------
        
        % OFDM调制后默认是频域信号
        % 为什么要乘以 sqrt(carrier_count)
        time_signal = sqrt(carrier_count) * ifft(piloted_ofdm_syms);
        
        %---------------加循环前缀-----------------------
        
        % CP 与子载波同级别
        add_cyclic_signal = [time_signal((carrier_count - guard + 1 : carrier_count), :); time_signal];
        % 将矩阵变为一个行向量再传输
        tx_data_trans = reshape(add_cyclic_signal, 1, (carrier_count + guard) * num_data);
        
        %---------------信道处理-----------------------
        
        % AWGN 信道
        
        % 计算信号功率
        tx_signal_power = sum(abs(tx_data_trans(:)) .^ 2) / length(tx_data_trans(:));
        % 为啥这么算？
        noise_var = tx_signal_power / (10 ^ (SNR(c1) / 10));
        rx_data = awgn(tx_data_trans, SNR(c1), 'measured');
        
        %---------------信号接收、去循环前缀、FFT变换-----------------------
        
        % 信号接收
        rx_signal = reshape(rx_data, (carrier_count + guard), num_data);
        % 去除CP
        rx_signal_matrix = zeros(carrier_count, num_data);
        rx_signal_matrix = rx_signal(guard + 1:end, :);
        % FFT变换
        % 因为接下来要提取导频，导频自然得回到频域才能提取
        rx_carriers = fft(rx_signal_matrix) / sqrt(carrier_count);
        
        %---------------导频和数据提取-----------------------
        
        % 提取导频
        rx_pilot = rx_carriers(:, pilot_index);
        % 提取数据(频域)
        rx_fre_data = rx_carriers(:, data_index);
        
        %---------------导频位置信道响应LS估计-----------------------
        
        % pilot_patt 就是发送端插入的 pilot
        pilot_patt = repmat(pilot_symbols, 1, num_pilot);
        % LS算法的 y/x
        pilot_esti = rx_pilot ./ pilot_patt;
        
        %---------------LS估计的线性插值-----------------------
        
        % 使用信道估计，其实就已经默认了rx的data是不可信的
        % 所以需要使用导频来恢复 data
        
        int_len = pilot_index;
        len = 1:num_data;
        channel_H_ls = zeros(carrier_count, num_data);
        
        % 每个符号/导频的子载波数量是固定的
        % 现在是要通过 num_pilot 个 导频来估算 num_data 个导频+data
        % 因此子载波一个一个来
        for ii = 1:carrier_count
            % 在 int_len(pilot_index)这些点（点的数量为 num_pilot）
            % 函数取值分别为 pilot_esti(ii, 1:(num_pilot))
            % 那么同样的函数，将点扩充为 len(num_data)个，各点的估计值是多少？
            channel_H_ls(ii, :) = interp1(int_len, pilot_esti(ii, 1:(num_pilot)), len, 'linear');
        end
        
        channel_H_data_ls = channel_H_ls(:, data_index);
        
        %---------------LS估计中发送数据的估计值-----------------------
        
        % 这个公式从何而来还不懂
        tx_data_estimate_ls = rx_fre_data .* conj(channel_H_data_ls) ./ (abs(channel_H_data_ls) .^ 2);
        
        %---------------DFT估计------------
        
        % DFT估计是为了再ls基础上消除时域噪声
        % 但是以下代码没看懂为什么能达到消除时域噪声的效果
        % 或许是在时域作超过子载波长度点数的FFT能够消除噪声？
        
        % 先将 pilot_esti 换为时域
        % 补充子载波padding后（symbol纬度不变）
        % 再换回频域
        % 加padding 其实就是做了 carrier_count+1024 点 FFT 变换
        tx_pilot_estimate_ifft = ifft(pilot_esti);
        padding_zero = zeros(1024, num_pilot);
        tx_pilot_estimate_ifft_padding_zero = [tx_pilot_estimate_ifft; padding_zero];
        % 对于矩阵来说，fft分别对各列作fft
        tx_pilot_estimate_dft = fft(tx_pilot_estimate_ifft_padding_zero);
        
        %---------------DFT估计的线性插值------------
        
        % 插值操作与 ls 一样
        
        int_len = pilot_index;
        len = 1:num_data;
        channel_H_dft = zeros(carrier_count, num_data);

        for ii = 1:carrier_count
            channel_H_dft(ii, :) = interp1(int_len, tx_pilot_estimate_dft(ii, 1:(num_pilot)), len, 'linear');
        end
        
        channel_H_data_dft = channel_H_dft(:, data_index);
        
        %---------------DFT估计中发送数据的估计值------------
        
        tx_data_estimate_dft = rx_fre_data .* conj(channel_H_data_dft) ./ (abs(channel_H_data_dft) .^ 2);
        
        %---------------DFT符号解调------------
        
        % 原矩阵每一列向量变为行向量
        % 并且按顺序铺成 sequence
        demod_in_dft = tx_data_estimate_dft(:).';
        demod_out_dft = qamdemod(demod_in_dft, modulation_mode);
        
        %---------------LS符号解调------------
        
        demod_in_ls = tx_data_estimate_ls(:).';
        demod_out_ls = qamdemod(demod_in_ls, modulation_mode);
        
        %---------------误码率计算------------
        
        for i = 1:length(bits_tx)
            if demod_out_dft(i) ~= bits_tx(i)
                num_bit_err_dft(c1, num1) = num_bit_err_dft(c1, num1) + 1;
            end
            if demod_out_ls(i) ~= bits_tx(i)
                 num_bit_err_ls(c1, num1) = num_bit_err_ls(c1, num1) + 1;
        
            end
        end
    end
end

% num_bit_err_dft.'表示原来的行变列
% 原先是每行代表一个 SNR 的所有 loop 结果
% 现在变成每列
% 与num_bit_err_dft(:).'展开不同，num_bit_err_dft.'仍是矩阵
% 因为 mean 是按列来算平均值的
BER_dft = mean(num_bit_err_dft.') / length(bits_tx);
BER_ls = mean(num_bit_err_ls.') / length(bits_tx);

%% 绘图
figure
semilogy(SNR, BER_dft, '-mp', SNR, BER_ls, '-k+');
title('OFDM系统的LS和DFT信道估计');
xlabel('SNR');
ylabel('BER');
legend('DFT信道估计','LS信道估计');
