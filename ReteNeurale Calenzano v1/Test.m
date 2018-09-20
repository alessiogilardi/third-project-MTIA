
%Giorno da testare
giornoTest = 739;

%Dati testing
inizioTest = giornoTest-10;

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

TestingOutput = zeros(3,1);
TestingOutput(1) = MatriceGasBlu(idDesiderato, giornoTest);
TestingOutput(2) = MatriceGas(idDesiderato, giornoTest);
TestingOutput(3) = MatriceBenzina(idDesiderato, giornoTest);

Y = net(TestingInput);

for i=1:3
    if Y(i) < 0
        Y(i) = 0;
  
    end
end

%Display
Y 
TestingOutput