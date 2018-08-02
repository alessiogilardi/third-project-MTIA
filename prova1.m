clc;
clear;

% Carico i dati sui punti vendita
tabella_dati = load_data('Fiorenzuola.xls', '2016', 'A2:E43580');

% Estraggo i dati riguardanti il gas
dati_gas = tabella_dati(tabella_dati.GAS > 0, {'Data', 'PV', 'GAS'});

% Conto il numero di occorrenze di ogni punto vendita nell'insieme degli
% ordini del gas
count_gas = count_occurrencies(dati_gas.PV);

% Filtro i punti vendita con meno di 10 ordini
dati_gas = dati_gas(ismember(dati_gas.PV, count_gas(count_gas.orders_count>10, :).PV), :);


% Filtro per punto vendita
dati_gas = dati_gas(dati_gas.PV==1658, :);
% figure('Name', 'Ordini GAS');
% scatter(dati_gas.Data, dati_gas.GAS);
% hold on;
% plot(dati_gas.Data, dati_gas.GAS);
% hold off;

figure('Name', 'Ordini GAS annuali', 'NumberTitle', 'off');
scatter(dati_gas.Data, dati_gas.GAS);
hold on;
plot(dati_gas.Data, dati_gas.GAS);
hold off;
xlim([datetime('01-01-2016', 'InputFormat', 'dd-MM-yyyy'),datetime('31-12-2016', 'InputFormat', 'dd-MM-yyyy')]);
ylim([0 25]);

% Filtro per mese
dati_gennaio = dati_gas(dati_gas.Data>='01-01-2016' & dati_gas.Data<='31-01-2016', :);
dati_febbraio = dati_gas(dati_gas.Data>='01-02-2016' & dati_gas.Data<='29-02-2016', :);
dati_marzo = dati_gas(dati_gas.Data>='01-03-2016' & dati_gas.Data<='31-03-2016', :);

figure('Name', 'Ordini GAS per mese', 'NumberTitle', 'off');

subplot(3,1,1);
scatter(dati_gennaio.Data, dati_gennaio.GAS);
title('Gennaio');
xlim(datetime(2016, 1, [1 31]));
ylim([0 25]);
hold on;
plot(dati_gennaio.Data, dati_gennaio.GAS);
hold off;
subplot(3,1,2)
scatter(dati_febbraio.Data, dati_febbraio.GAS);
title('Febbraio');
xlim(datetime(2016, 2, [1 29]));
ylim([0 25]);
hold on;
plot(dati_febbraio.Data, dati_febbraio.GAS);
hold off;
subplot(3,1,3)
scatter(dati_marzo.Data, dati_marzo.GAS);
title('Marzo');
xlim(datetime(2016, 3, [1 31]));
ylim([0 25]);
hold on;
plot(dati_marzo.Data, dati_marzo.GAS);
hold off;

% figure('Name', 'Ordini GAS - Continue', 'NumberTitle', 'off');
% plot(dati_gas.Data, dati_gas.GAS);


% Analisi frequenziale

%figure('Name', 'Ordini GAS', 'NumberTitle', 'off');



% 
% % figure(1);
% % stem(gas_gt_10.Data, gas_gt_10.GAS);
% % % xlim(datetime(2018,[1 12],[1 30]))
% % % xtickformat('dd-MMM-yyyy')
% ft = fft(dati_gennaio.GAS);
% m = abs(ft); % Magnitude
% p = unwrap(angle(ft)); % Phase
% 
% figure(2);
% freqs = (0:length(ft)-1)*100/length(ft); % Vettore frequenze
% subplot(2,1,1)
% scatter(freqs,m)
% title('Magnitude')
% subplot(2,1,2)
% scatter(freqs,p*180/pi)
% title('Phase')

figure('Name', 'Histogram');
c = 1:max(dati_gas.GAS);
hist(dati_gas.GAS, c);


% 
% %histogram(t1.GAS);
% 
% %t1 = tb(tb.GAS==6, {'Data', 'PV', 'GBLU', 'GAS', 'BSP'});
