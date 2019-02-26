clc;
clear;

%ottenimento dataset da file Excel
X1 = xlsread('Eni_LGS_ordiniRete_Calenzano_anno2016.xlsx','ElencoordiniNew.rpt','A2:E24505');
X2 = xlsread('Eni_LGS_ordini_Rete_gen2017-apr2018.xlsx','Foglio1','A2:E31267');
X = cat(1,X1,X2);

%Creazione matrice contenente dati pv * giorni
Calendar = 42370:43218;
IdPv = unique(X(:,2));
MatriceDati = zeros(length(IdPv),length(Calendar));

%id da analizzare
idPvDesiderato = 34602;

% Scorro tutti i punti vendita per trovare l'idice di idPvDesiderato
for i = 1:length(IdPv)
    if IdPv(i) == idPvDesiderato
        idDesiderato = i; % idDesiderato -> Indice dell'idPuntoVenditaDesiderato
        break;
    end
end

for i=1:size(X,1)
    data = X(i,1)-42369; % Sottraggo il giorno 31/12/2015(42369) ad ogni data in modo che siano normalizzate da 1 a 849 giorni
    pv = X(i,2);
    index = 0;
    for j=1:length(IdPv)
        if (IdPv(j) == pv)
            index = j;
            break;
        end
    end
    % Costruisco una matrice(indiciPuntiVendita X giorni) dove 1 vuol dire
    % punto vendita x ordina nel giorno y, 0 altrimenti
    MatriceDati(index,data) = 1;
end
  

riga = MatriceDati(idDesiderato,:); % Prelevo i giorni in cui sono stati fatti ordini da un punto vendita desiderato
riga = riga - mean(riga);

% Frequenza di campionamento
Fs = 1;
% Periodo di campionamento = 1/Fs
T = 1/Fs;
% Lunghezza del segnale (numero di campioni)
L = 849;
% Tempo 
t = T*(0:L-1);

y = fft(riga);

%entambe le parti della trasformata
P2 = abs(y/L);
%singola parte della trasformata (simmetria)
P1 = P2(1:L/2+1);
%moltiplicazione per due per la divisione della trasformata
P1(2:end-1) = 2*P1(2:end-1);
%dimezzio il tempo
f = Fs*(0:L/2)/L;
plot(f,P1);



    

    
