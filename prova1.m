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



%histogram(t1.GAS);

%t1 = tb(tb.GAS==6, {'Data', 'PV', 'GBLU', 'GAS', 'BSP'});
