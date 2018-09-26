clc;
clear;

% Ottenimento dataset da file Excel
anno1 = xlsread('Fiorenzuola.xlsx','2016','A2:E43580');
anno2 = xlsread('Fiorenzuola.xlsx','2017','A2:E45668');
anno3 = xlsread('Fiorenzuola.xlsx','2018','A2:E15074');
dati = cat(1,anno1,anno2,anno3); % X nell'altro file

% Importo calendario con pesi dei giorni della settimana
calendarioExcel = xlsread('Calendar.xlsx', 'Foglio1', 'C2:C850'); % X3 nell'altro file


calendar = 42370:43218;
idPuntiVendita = unique(dati(:,2));

matriceGasBlu   = zeros(length(idPuntiVendita),length(calendar));
matriceGas      = zeros(length(idPuntiVendita),length(calendar));
matriceBenzina  = zeros(length(idPuntiVendita),length(calendar));

% Seleziono un id Punto Vendita da analizzare
idPvDesiderato = 1658;
indexDesiderato = find(idPuntiVendita == idPvDesiderato);


% Normalizzo la data in modo da usarla come indice
normData = dati(:,1) - 42369;

for i=1:size(dati,1)
    matriceGasBlu(idPuntiVendita == dati(i,2), normData(i))     = dati(i,3);  
    matriceGas(idPuntiVendita == dati(i,2), normData(i))        = dati(i,4);
    matriceBenzina(idPuntiVendita == dati(i,2), normData(i))    = dati(i,5);
end

matriceGasBlu(isnan(matriceGasBlu))     = 0;
matriceGas(isnan(matriceGas))           = 0;
matriceBenzina(isnan(matriceBenzina))   = 0;

%Input e Output per 2 anno: 2016,2017
% 10 giorni per il GAS Blu, 10 GAS, 10 giorni per la Benzina, 10 giorni per
% il calendario e 2 giorni in più per passare a lunedì dal sabato e dalla
% domenica
inputMatrix = zeros(730,42); 
outputMatrix= zeros(730,3);


for i=1:size(inputMatrix,1) % size(inputMatrix,1) = 730
    input = zeros(1,size(inputMatrix,2)); % size(inputMatrix,2) = 42
    index = 1;
    for j=i:i+9
        input(index)    = matriceGasBlu(indexDesiderato, j);  
        input(index+10) = matriceGas(indexDesiderato, j);
        input(index+20) = matriceBenzina(indexDesiderato, j);
        input(index+30) = calendarioExcel(j);
        index = index+1;
    end
    input(41) = calendarioExcel(i+10);
    input(42) = calendarioExcel(i+11);
    
   inputMatrix(i,:)  = input;
   outputMatrix(i,1) = matriceGasBlu(indexDesiderato,i+10);
   outputMatrix(i,2) = matriceGas(indexDesiderato,i+10);
   outputMatrix(i,3) = matriceBenzina(indexDesiderato,i+10);
end


inputMatrix = inputMatrix';
outputMatrix = outputMatrix';

%Addestramento rete
net = scriptTrain(inputMatrix, outputMatrix);



