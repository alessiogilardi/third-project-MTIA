clc;
clear;

X = xlsread('Eni_LGS_OrdiniReteFDCarb_3lug2017-16giu2018_Napoli.xlsx','ordini','A2:E30245');
X3 = xlsread('Calendar.xlsx', 'Foglio1', 'C2:C349');
%X = cat(1,X1,X2);

Calendar = 42919:43267;
IdPv = unique(X(:,2));
MatriceGasBlu = zeros(length(IdPv),length(Calendar));
MatriceGas = zeros(length(IdPv),length(Calendar));
MatriceBenzina = zeros(length(IdPv),length(Calendar));

%id da analizzare
idPvDesiderato = 8038;

for i = 1:length(IdPv)
    if IdPv(i) == idPvDesiderato
        idDesiderato = i;
        break;
    end
end

for i=1:size(X,1)
    data = X(i,1)-42918;
    pv = X(i,2);
    index = 0;
    for j=1:length(IdPv)
        if (IdPv(j) == pv)
            index = j;
            break;
        end
    end
    MatriceGasBlu(index,data) = X(i,3);
    MatriceGas(index,data) = X(i,4);
    MatriceBenzina(index,data) = X(i,5);
end

MatriceGasBlu(isnan(MatriceGasBlu))=0;
MatriceGas(isnan(MatriceGas))=0;
MatriceBenzina(isnan(MatriceBenzina))=0;

%Input e Output per 1 anno: 2017
InputMatrix = zeros(182,42);
OutputMatrix= zeros(182,3);

for i=1:182
    Input = zeros(1,42); 
    index = 1;
    for j=i:i+9
        Input(index) = MatriceGasBlu(idDesiderato, j);  
        Input(index+10) = MatriceGas(idDesiderato, j);
        Input(index+20) = MatriceBenzina(idDesiderato, j);
        Input(index+30) = X3(j);
        index = index+1;
    end
    Input(41) = X3(i+10);
    Input(42) = X3(i+11);
    
   InputMatrix(i,:) = Input;
   OutputMatrix(i,1) = MatriceGasBlu(idDesiderato,i+10);
   OutputMatrix(i,2) = MatriceGas(idDesiderato,i+10);
   OutputMatrix(i,3) = MatriceBenzina(idDesiderato,i+10);
end


InputMatrix = InputMatrix';
OutputMatrix = OutputMatrix';

%Addestramento rete
net = scriptTrain(InputMatrix, OutputMatrix);






    

    

    
