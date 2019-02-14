 
% Giorni su cui eseguire il test (dal 01/01/2018 al 28/04/2018)
giorniTest = 731:848;

% Predispongo le varibili per Uscita, Valori di test e Errore
predicted        = zeros(3,length(giorniTest));
testOutputValues = zeros(3,length(giorniTest));
%error            = zeros(3,length(giorniTest));

% Ciclo su tutti i giorni su cui voglio fare una predizione (dal 01/01/2018 al 28/04/2018)
for k=1:length(giorniTest)
    %Dati testing
    inizioTest = giorniTest(k)-10;

    testInputValues = zeros(1,42);
    index = 1;
    
    for j=inizioTest:inizioTest+9
        testInputValues(index)    = matriceGasBlu(indexDesiderato, j);  
        testInputValues(index+10) = matriceGas(indexDesiderato, j);
        testInputValues(index+20) = matriceBenzina(indexDesiderato, j);
        testInputValues(index+30) = calendarioExcel(j);
        index = index+1;
    end
    
    testInputValues(41) = calendarioExcel(inizioTest+10);
    testInputValues(42) = calendarioExcel(inizioTest+11);
    testInputValues     = testInputValues';
    
    testOutputValues(1,k) = matriceGasBlu(indexDesiderato, giorniTest(k));
    testOutputValues(2,k) = matriceGas(indexDesiderato, giorniTest(k));
    testOutputValues(3,k) = matriceBenzina(indexDesiderato, giorniTest(k));

    predicted(:,k) = net(testInputValues);
end


predicted(predicted < 0) = 0;

error = testOutputValues - predicted;
meanSquareError = diag(error*error')/length(giorniTest)

