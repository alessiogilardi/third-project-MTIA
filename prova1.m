clc;
clear;

[dati, date] = xlsread('Fiorenzuola.xls', '2016', 'A2:E43580');
tabella_dati = [array2table(datetime(date, 'Format', 'dd-MM-yyyy'), 'VariableNames',{'Data'}), array2table(dati, 'VariableNames',{'PV', 'GBLU', 'GAS', 'BSP'})];

punti_vendita = unique(dati(:,1));
% count = [punti_vendita, histc(dati(:,1), punti_vendita)];
% gt_1 = find(count(:,2)>3);

rows = tabella_dati.GAS>0;
gas = tabella_dati(rows, {'Data', 'PV', 'GAS'});
count_gas = array2table([unique(gas.PV), histc(gas.PV, unique(gas.PV))], 'VariableNames', {'PV', 'orders_count'});

% Tabella che tiene tutti gli ordini di gas di punti vendita che ne hanno
% fatti almeno 10
gas_gt_10 = gas(ismember(gas.PV, count_gas(count_gas.orders_count>10,{'PV', 'orders_count'}).PV), :);

gas_gt_10 = gas_gt_10(gas_gt_10.PV==1658,:);

figure(1);
stem(gas_gt_10.Data, gas_gt_10.GAS);
% xlim(datetime(2018,[1 12],[1 30]))
% xtickformat('dd-MMM-yyyy')
ft = fft(gas_gt_10.GAS);
m = abs(ft); % Magnitude
p = unwrap(angle(ft)); % Phase

figure(2);
freqs = (0:length(ft)-1)*100/length(ft); % Vettore frequenze
subplot(2,1,1)
plot(freqs,m)
title('Magnitude')
subplot(2,1,2)
plot(freqs,p*180/pi)
title('Phase')

%histogram(t1.GAS);

%t1 = tb(tb.GAS==6, {'Data', 'PV', 'GBLU', 'GAS', 'BSP'});
