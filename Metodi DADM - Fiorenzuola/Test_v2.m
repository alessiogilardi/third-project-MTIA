% Provo a modificare il codice di test in modo da ridurre i cicli


% Giorni su cui eseguire il test (dal 01/01/2018 al 28/04/2018)
testDays = 731:848;

% Predispongo le varibili per Uscita, Valori di test e Errore
predicted        = zeros(3,length(testDays));
testOutputValues = zeros(3,length(testDays));

% Predispongo vettore per valori di test in input
testInputValues = zeros(length(testDays),42);

indexDesiderato = find(PVs == pv_selez);

% Ciclo su tutti i giorni su cui voglio fare una predizione (dal 01/01/2018 al 28/04/2018)
% In questo modo predispongo i valori di test per la rete neurale e
% l'output su cui verr� calcolato l'errore
for k=1:length(testDays)
    
    inizioTest = testDays(k)-10;
    
    index = 1;
    for j=inizioTest:inizioTest+9
        testInputValues(k,index)    = X_gblu(j);  
        testInputValues(k,index+10) = X_gaso(j);
        testInputValues(k,index+20) = X_benz(j);
        testInputValues(k,index+30) = cal(j,3);
        index = index+1;
    end
    
    testInputValues(k,41) = cal(inizioTest+10,3);
    testInputValues(k,42) = cal(inizioTest+11,3);
    
    testOutputValues(1,k) = X_gblu(testDays(k));
    testOutputValues(2,k) = X_gaso(testDays(k));
    testOutputValues(3,k) = X_benz(testDays(k));
    
    predicted(:,k) = net(testInputValues(k,:)');
end

predicted(predicted < 0) = 0;

error = testOutputValues - predicted;
meanSquareError = diag(error*error')/length(testDays)


