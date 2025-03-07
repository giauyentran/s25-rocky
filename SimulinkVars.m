clear all

t = 0.0644;
g = -9.8;
K = 0.0027;
m = 0.53;  %kg
l = 0.3062;

Kp = 3.0125e3;
Ki = 1.7051e4;
Jp = 212.2063;
Ji = -3.0598e+03;
Ci = -3.7872e+03; 

%run simulink model
model2023