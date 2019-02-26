clc;
clear;

% Ottenimento dataset da file Excel
anno1 = xlsread('Fiorenzuola.xlsx','2016','A2:E43580');
anno2 = xlsread('Fiorenzuola.xlsx','2017','A2:E45668');
anno3 = xlsread('Fiorenzuola.xlsx','2018','A2:E15074');
dati = cat(1,anno1, anno2, anno3);

% Creazione matrice contenente dati pv X giorni
calendario = 42370:43218; % Vettore di date da 01/01/2016 a 28/04/2018
idPuntiVendita = unique(dati(:,2)); % Vettore di id Punti Vendita
ordiniPuntiVendita = zeros(length(idPuntiVendita),length(calendario)); % puntiVendita X giorni

% Seleziono un id Punto Vendita da analizzare
idPvDesiderato = 1658;

% Scorro tutti i punti vendita per trovare l'indice di idPvDesiderato
indexDesiderato = find(idPuntiVendita == idPvDesiderato);

% Normalizzo la data in modo da usarla come indice
normData = dati(:,1) - 42369;

for i=1:size(dati,1)
    % OrdiniPuntiVendita -> matrice che indica i giorni in cui un punto
    % vendita ha effettuato un ordine, inserendo 1 in corrsipondenza di
    % questi giorni e del punto vendita relativo
    ordiniPuntiVendita(idPuntiVendita == dati(i,2), normData(i)) = 1;
end

riga = ordiniPuntiVendita(indexDesiderato, :) - mean(ordiniPuntiVendita(indexDesiderato, :));
% Frequenza di campionamento
Fs = 1;
% Periodo di campionamento = 1/Fs
T = 1/Fs;
% Lunghezza del segnale (numero di campioni)
L = 849;
% Tempo 
t = T*(0:L-1);

y = fft(riga);

% Entrambe le parti della trasformata
P2 = abs(y/L);
%singola parte della trasformata (simmetria)
P1 = P2(1:L/2+1);
%moltiplicazione per due per la divisione della trasformata
P1(2:end-1) = 2*P1(2:end-1);
%dimezzio il tempo
f = Fs*(0:L/2)/L;
plot(f,P1);
