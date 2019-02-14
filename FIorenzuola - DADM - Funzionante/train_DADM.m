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
cal    = csvread('Calendar.csv',1);

%% Genero il dataset con i tre anni
X = [a_2016; a_2017; a_2018];
clear a_2016 a_2017 a_2018

%% Seleziono un punto vendita e estraggo i dati
PVs = unique(X(:,2));
pv_selez = 13846; % PV per cui voglio fare la predizione
X(:,1) = X(:,1) - 42369; % Normalizzo la data
X_gblu((X(X(:,2)==pv_selez,1))) = X(X(:,2) == pv_selez,3);
X_gaso((X(X(:,2)==pv_selez,1))) = X(X(:,2) == pv_selez,4);
X_benz((X(X(:,2)==pv_selez,1))) = X(X(:,2) == pv_selez,5);

%% Genero le matrici di input e output per il train della rete neurale (primi 730 giorni)
in_mat  = [];
out_mat = [];
for i = 1:730
    % Input e Output per 2 anni: 2016,2017
    % 10 giorni per il GAS Blu, 10 GAS, 10 giorni per la Benzina, 10 giorni per
    % il calendario e 2 giorni in più per passare a lunedì dal sabato e dalla
    % domenica -> in totale mando in input 42 dati
    in_mat  = [in_mat [X_gblu(i:i+9) X_gaso(i:i+9) X_benz(i:i+9) cal(i:i+9,3)' cal(i+10,3)' cal(i+11,3)']'];
    out_mat = [out_mat [X_gblu(i+10) X_gaso(i+10) X_benz(i+10)]'];
end

%%
net = scriptTrain(in_mat, out_mat);