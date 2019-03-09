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

%% Seleziono un punto vendita e estraggo i dati
PVs = unique(X(:,2));
pv_selez = mode(X(:,2));

X_gblu((X(X(:,2) == pv_selez,1))) = X(X(:,2) == pv_selez,3);
X_gaso((X(X(:,2) == pv_selez,1))) = X(X(:,2) == pv_selez,4);
X_benz((X(X(:,2) == pv_selez,1))) = X(X(:,2) == pv_selez,5);

X = [X_gblu; X_gaso; X_benz];

clear X_gblu X_gaso X_benz

%% Normalizzo tra 0 e 1
X = (X - min(X,[],2))./(max(X,[],2) - min(X,[],2));

%% Calcolo la media in ogni periodo
days = 10;
for i = 1:days:(size(X,2)-days)
    X(:,i:i+days-1) = mean(X(:,i:i+days-1),2).*ones(size(X,1),days);
end

%% Plotto i risultati
figure
hold on
grid on
grid minor

years = 2;
plot(X(1,1:365*years), '.-.');
plot(X(2,1:365*years), '.-.');
plot(X(3,1:365*years), '.-.');

legend('Gasolio Blu', 'Gasolio', 'Benzina')

