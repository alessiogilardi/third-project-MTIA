% Giorni su cui eseguire il test (dal 01/01/2018 al 28/04/2018)
clc
out_test    = [];
predicted   = [];
for i = 731:848
    i1 = i - 10;
    in_test     = [X_gblu(i1:i1+9) X_gaso(i1:i1+9) X_benz(i1:i1+9) cal(i1:i1+9,3)' cal(i1+10,3)' cal(i1+11,3)']';
    out_test    = [out_test [X_gblu(i1+10) X_gaso(i1+10) X_benz(i1+10)]'];
    predicted   = [predicted net(in_test)];
end

predicted(predicted < 0) = 0;

error = out_test - predicted;
%meanSquareError = diag(error*error')/size(out_test,2)

gblu_MSE = (error(1,:)*error(1,:)')/size(out_test,2);
gaso_MSE = (error(2,:)*error(2,:)')/size(out_test,2);
benz_MSE = (error(3,:)*error(3,:)')/size(out_test,2);

MSE = [gblu_MSE, gaso_MSE, benz_MSE]
