clc;
close all;
clear;

%% Load data
a_2016 = csvread('2016.csv',1);
a_2017 = csvread('2017.csv',1);
a_2018 = csvread('2018.csv',1);

a_2017 = a_2017(:,1:end-1);
a_2018 = a_2018(:,1:end-1);

%% Genero il dataset con i tre anni
X = [a_2016; a_2017; a_2018];
X(:,1) = X(:,1) - 42369; % Normalizzo la data
clear a_2016 a_2017 a_2018

%% Seleziono il punto vendita
PVs = unique(X(:,2));
pv_selez = 13846; % PV per cui voglio fare la predizione
X_pv((X(X(:,2)==pv_selez,1)), :) = X(X(:,2) == pv_selez, 3:5);

%% Normalizzo i dati
max = max(X_pv);
min = min(X_pv);

X_pv(:,1) = 2*(X_pv(:,1) - min(1))/(max(1) - min(1)) - 1;
X_pv(:,2) = 2*(X_pv(:,2) - min(2))/(max(2) - min(2)) - 1;
X_pv(:,3) = 2*(X_pv(:,3) - min(3))/(max(3) - min(3)) - 1;

clear max min

%%
riga = X_pv(:,1);% - mean(X_pv(:,1));
% Frequenza di campionamento
Fs = 1;
% Periodo di campionamento = 1/Fs
T = 1/Fs;
% Lunghezza del segnale (numero di campioni)
L = size(X_pv,1);
% Tempo 
t = T*(0:L-1);

y = fft(riga);

% Entrambe le parti della trasformata
P2 = abs(y/L);
%singola parte della trasformata (simmetria)
P1 = P2(1:L/2+1);
%moltiplicazione per due per la divisione della trasformata
P1(2:end-1) = 2*P1(2:end-1);
%dimezzo il tempo
f = Fs*(0:L/2)/L;
plot(f,P1);
