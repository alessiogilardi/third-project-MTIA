% Giorni su cui eseguire il test (dal 01/01/2018 al 28/04/2018)
clc
out_test    = [];
predicted   = [];
for i = 731:848
    % Predispongo i dati per i restanti 118 giorni (Test)
    i1 = i - 10;
    in_test     = [X_gblu(i1:i1+9) X_gaso(i1:i1+9) X_benz(i1:i1+9) cal(i1:i1+9,3)' cal(i1+10,3)' cal(i1+11,3)']';
    out_test    = [out_test [X_gblu(i1+10) X_gaso(i1+10) X_benz(i1+10)]'];
    predicted   = [predicted net(in_test)];
end

predicted(predicted < 0) = 0;

error = out_test - predicted;

startDate   = datenum('01-01-2018');
endDate     = datenum('28-04-2018');
xDate = linspace(startDate, endDate, size(out_test,2));

figure('Name', 'Prediction')
plot(xDate, predicted(1,:), '-o')
hold on
plot(xDate, out_test(1,:), '-o')
legend('Prediction','Real Values')

gblu_MSE = (error(1,:)*error(1,:)')/size(out_test,2);
gaso_MSE = (error(2,:)*error(2,:)')/size(out_test,2);
benz_MSE = (error(3,:)*error(3,:)')/size(out_test,2);

MSE = [gblu_MSE, gaso_MSE, benz_MSE]


% Conversione in valori binari
predicted_bin = predicted;
predicted_bin(predicted_bin >= 0.5) = 1;
predicted_bin(predicted_bin < 0.5)  = 0;

out_bin = out_test;
out_bin(out_bin > 0) = 1;

err_bin = out_bin - predicted_bin;
gblu_MSE_bin = (err_bin(1,:)*err_bin(1,:)')/size(out_test,2);
gaso_MSE_bin = (err_bin(2,:)*err_bin(2,:)')/size(out_test,2);
benz_MSE_bin = (err_bin(3,:)*err_bin(3,:)')/size(out_test,2);

MSE_bin = [gblu_MSE_bin, gaso_MSE_bin, benz_MSE_bin]

figure('Name', 'Binary Prediction')
plot(xDate, predicted_bin(1,:), 'o')
hold on
plot(xDate, out_bin(1,:), 'o')
legend('Prediction','Real Values')

