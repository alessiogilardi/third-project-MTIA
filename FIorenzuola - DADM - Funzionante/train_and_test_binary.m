clc;
close all;
clear;

%% Load data
a_2016 = csvread('2016.csv',1);
a_2017 = csvread('2017.csv',1);
a_2018 = csvread('2018.csv',1);

a_2017 = a_2017(:,1:end-1);
a_2018 = a_2018(:,1:end-1);

% Carico il calendario con i pesi dei giorni (Sabato -> 0.5, Domenica -> 1)
cal = csvread('Calendar.csv',1);

%% Genero il dataset con i tre anni
X = [a_2016; a_2017; a_2018];
X(:,1) = X(:,1) - 42369; % Normalizzo la data
clear a_2016 a_2017 a_2018

%% Seleziono un punto vendita e estraggo i dati
PVs = unique(X(:,2));
pv_selez = mode(X(:,2)); % 13846; % PV per cui voglio fare la predizione
X_gblu((X(X(:,2) == pv_selez,1))) = X(X(:,2) == pv_selez,3);
X_gaso((X(X(:,2) == pv_selez,1))) = X(X(:,2) == pv_selez,4);
X_benz((X(X(:,2) == pv_selez,1))) = X(X(:,2) == pv_selez,5);

%% Rendo i dati binari
X_gblu(X_gblu > 0) = 1;
X_gaso(X_gaso > 0) = 1;
X_benz(X_benz > 0) = 1;


%% Genero le matrici di input e output per il train della rete neurale (primi 730 giorni)
input_TS  = [];
output_TS = [];
for i = 1:730
    % Input e Output per 2 anni: 2016,2017
    % 10 giorni per il GAS Blu, 10 GAS, 10 giorni per la Benzina, 10 giorni per
    % il calendario e 2 giorni in più per passare a lunedì dal sabato e dalla
    % domenica -> in totale mando in input 42 dati
    input_TS  = [input_TS [X_gblu(i:i+9) X_gaso(i:i+9) X_benz(i:i+9) cal(i:i+9,3)' cal(i+10,3)' cal(i+11,3)']'];
    output_TS = [output_TS [X_gblu(i+10) X_gaso(i+10) X_benz(i+10)]'];
end

%% Addestro la Rete Neurale
net = scriptTrain(input_TS, output_TS);

%% Eseguo la validazione
output_VS = [];
predicted = [];
for i = 731:848 % Potrei usare i = 721:738 ma per chiarezza meglio usare un indice di supporto i1
    % Predispongo i dati per i restanti 118 giorni (Test)
    i1 = i - 10;
    input_VS  = [X_gblu(i1:i1+9) X_gaso(i1:i1+9) X_benz(i1:i1+9) cal(i1:i1+9,3)' cal(i1+10,3)' cal(i1+11,3)']';
    output_VS = [output_VS [X_gblu(i1+10) X_gaso(i1+10) X_benz(i1+10)]'];
    predicted = [predicted net(input_VS)];
end
predicted(predicted < 0) = 0;

%% Rendo binaria la previsione
predicted(1,predicted(1,:) < mean(predicted(1,:))) = 0;
predicted(2,predicted(2,:) < mean(predicted(2,:))) = 0;
predicted(3,predicted(3,:) < mean(predicted(3,:))) = 0;

predicted(1,predicted(1,:) >= mean(predicted(1,:))) = 1;
predicted(2,predicted(2,:) >= mean(predicted(2,:))) = 1;
predicted(3,predicted(3,:) >= mean(predicted(3,:))) = 1;


%% Calcolo l'errore
error = output_VS - predicted;

%% Plotto (Dati, predizione)
figure
subplot(3,1,1)
title('Gasolio Blu')
hold on
grid on

plot(0:(size(output_VS, 2)-1), output_VS(1,:))
plot(0:(size(predicted, 2)-1), predicted(1,:))
legend('Dati', 'Predizione')

subplot(3,1,2)
title('Gasolio')
hold on
grid on

plot(0:(size(output_VS, 2)-1), output_VS(2,:))
plot(0:(size(predicted, 2)-1), predicted(2,:))
legend('Dati', 'Predizione')

subplot(3,1,3)
title('Benzina')
hold on
grid on

plot(0:(size(output_VS, 2)-1), output_VS(3,:))
plot(0:(size(predicted, 2)-1), predicted(3,:))
legend('Dati', 'Predizione')

%% MSE
MSE_gblu = (error(1,:)*error(1,:)')/size(output_VS,2);
MSE_gaso = (error(2,:)*error(2,:)')/size(output_VS,2);
MSE_benz = (error(3,:)*error(3,:)')/size(output_VS,2);

%% MAD
MAD_gblu = sum(abs(error(1,:)))/size(output_VS,2);
MAD_gaso = sum(abs(error(2,:)))/size(output_VS,2);
MAD_benz = sum(abs(error(3,:)))/size(output_VS,2);

%% MAPD
output_VS = output_VS + 1;
predicted = predicted + 1;
error = output_VS - predicted;

MAPD_gblu = 100*sum(abs(error(1,:)./output_VS(1,:)))/size(output_VS,2);
MAPD_gaso = 100*sum(abs(error(2,:)./output_VS(2,:)))/size(output_VS,2);
MAPD_benz = 100*sum(abs(error(3,:)./output_VS(3,:)))/size(output_VS,2);

output_VS = output_VS - 1;
predicted = predicted - 1;
error = output_VS - predicted;

clear cal i i1 input_VS input_TS net output_TS PVs X X_benz X_gaso X_gblu;

