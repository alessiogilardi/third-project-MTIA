
%Giorno da testare
giornoTest = 183:347;
err=zeros(3,length(giornoTest));
Y=zeros(3,length(giornoTest));
TestingOutput = zeros(3,length(giornoTest));
for k=1:length(giornoTest)
    
    %Dati testing
    inizioTest = giornoTest(k)-10;

    TestingInput= zeros(1,42);
    index = 1;

    for j=inizioTest:inizioTest+9
        TestingInput(index) = MatriceGasBlu(idDesiderato, j);  
        TestingInput(index+10) = MatriceGas(idDesiderato, j);
        TestingInput(index+20) = MatriceBenzina(idDesiderato, j);
        TestingInput(index+30) = X3(j);
        index = index+1;
    end

    TestingInput(41) = X3(inizioTest+10);
    TestingInput(42) = X3(inizioTest+11);
    TestingInput = TestingInput';

    %TestingOutput = zeros(3,1);
    TestingOutput(1,k) = MatriceGasBlu(idDesiderato, giornoTest(k));
    TestingOutput(2,k) = MatriceGas(idDesiderato, giornoTest(k));
    TestingOutput(3,k) = MatriceBenzina(idDesiderato, giornoTest(k));

    Y(:,k) = net(TestingInput);

    for i=1:3
        if Y(i,k) < 0
            Y(i,k) = 0;
        end
    end
    err(:,k)=TestingOutput(:,k)-Y(:,k);
end
e2 = err*err';
ris=(sum(e2))/length(giornoTest);
%Display
ris