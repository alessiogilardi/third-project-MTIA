clc;
clear;

%ottenimento dataset da file Excel
X1 = xlsread('Eni_LGS_ordiniRete_Calenzano_anno2016.xlsx','ElencoordiniNew.rpt','A2:E24505');
X2 = xlsread('Eni_LGS_ordini_Rete_374+555_gen2017-apr2018.xlsx','Foglio1','A2:E31267');
X = cat(1,X1,X2);

%Creazione matrice contenente dati pv * giorni
Calendar = 42370:43218;
IdPv = unique(X(:,2));
MatriceDati = zeros(length(IdPv),length(Calendar));

%id da analizzare
idPvDesiderato = 34602;

for i = 1:length(IdPv)
    if IdPv(i) == idPvDesiderato
        idDesiderato = i;
        break;
    end
end

for i=1:size(X,1)
    data = X(i,1)-42369;
    pv = X(i,2);
    index = 0;
    for j=1:length(IdPv)
        if (IdPv(j) == pv)
            index = j;
            break;
        end
    end
    MatriceDati(index,data) = 1;
end
  

riga = MatriceDati(idDesiderato,:);
riga = riga - mean(riga);

%frequenza di campionamento
Fs = 1;
%periodo di campionamento = 1/Fs
T = 1/Fs;
%Lunghezza del segnale (numero di campioni)
L = 849;
%tempo 
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



    

    
