clc;
close all;
clear;

%%
anno1 = xlsread('Fiorenzuola.xlsx','2016','A2:E43580');
anno2 = xlsread('Fiorenzuola.xlsx','2017','A2:E45668');
anno3 = xlsread('Fiorenzuola.xlsx','2018','A2:E15074');
dati  = cat(1,anno1,anno2,anno3);

% Importo calendario con pesi dei giorni della settimana
calendarioExcel = xlsread('Calendar.xlsx', 'Foglio1', 'C2:C850');

%%
a_2016 = csvread('2016.csv',1);
a_2017 = csvread('2017.csv',1);
a_2018 = csvread('2018.csv',1);
a_2017 = a_2017(:,1:end-1);
a_2018 = a_2018(:,1:end-1);

cal    = csvread('Calendar.csv',1);