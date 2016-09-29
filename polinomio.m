%TERMOCUPLA TIPO J; (0C to 760C with error range -0.9C to 0.7C
a1 = 1.9323799E-2 ;
a2 = -1.0306020E-7 ;
a3 = 3.7084018E-12 ;
a4 = -5.1031937E-17 ;
%TERMOCUPLA TIPO K; (0C to 1370C with error range -2.4C to 1.2C) 
a0 = 0.0 ;
b1 = 2.5132785E-2 ;
b2 = -6.0883423E-8 ;
b3 = 5.5358209E-13 ;
b4 = 9.3720918E-18 ;
%%%%%%%%%%%%%%%%%%%%%
%definimos vector temperatura
temperatura = zeros(7, 1366);
%Pongo bien los datos de la medicin 3 (el resto es lo que no se sobreescribi de la 2)
DATA33 = zeros(7, 166);
TIME33 = zeros(7, 166);

for j = 1:7
    for i = 1:166
        DATA33(j,i) = DATA3(j,i);
        TIME33(j,i) = TIME3(j,i);
    end
end

%%%%%%%%%%%%%%%%%%%%%%
DATA = horzcat(DATA1, DATA2, DATA33);

for k = 1:5
    for l = 1:1366
        temperatura(k, l) = a1*(DATA(k, l)*1000000) + a2*(DATA(k,l)*1000000)^2 + a3*(DATA(k,l)*1000000)^3 + a4*(DATA(k,l)*1000000)^4;
    end
end
 

for m = 6:7
    for n = 1:1366
        temperatura(m,n) = b1*DATA(m,n)*1000000 + b2*(DATA(m,n)*1000000)^2 + b3*(DATA(m,n)*1000000)^3 + b4*(DATA(m,n)*1000000)^4;
    end
end

%%%%%%%%%%%%%%%%%%%%%

% definimos tiempo
tiempo1 = zeros(7,600);
tiempo22 = zeros(7,600);
tiempo33 = zeros(7,166);
for j = 1:7
    for i = 2:600
        tiempo1(j,i) = tiempo1 (j,i-1) - TIME1(j,i) + 12.1 +(j-1)*TIME1(1,i) ;
    end
end

for j = 1:7
    tiempo22(j,1) = tiempo1(j, 600) + 43;
    for i = 2:600
        tiempo22(j,i) = tiempo22 (j,i-1) - TIME2(j,i) + 12.1 +(j-1)*TIME2(1,i) ;
    end
end


for j = 1:7
    tiempo33(j, 1) = tiempo22(j, 600) + 50;
    for i = 2:166
        tiempo33(j,i) = tiempo33 (j,i-1) - TIME33(j,i) + 12.1 +(j-1)*TIME33(1,i);
    end
end

tiempo = horzcat(tiempo1, tiempo22, tiempo33);

%%%%%%%%%%%%%%%%%%%%%%%
hold on
plot(tiempo(1,:), temperatura(1,:), 'r.') 
plot(tiempo(4,:), temperatura(4,:), 'y.')
plot(tiempo(6,:), temperatura(6, :), 'g.')
plot(tiempo(7,:), temperatura(7,:), 'b.')
hold off
%   http://www.unirioja.es/cu/lzorzano/jk.htm
%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAXIMOS (no hace falta correrlo)
mx=zeros(7,1)
mn=zeros(7,1)
for i=1:7   
    mx(i,1) = max (DATA33(i,:));
    mn(i,1) = DATA(i,868);
end
mx
mn
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%REDEFINICION
DATAF=zeros(7,918);
for i = 1:7
   for j= 1:868
    DATAF(i,j)=DATA(i,j);
   end
end

for i= 1:7
    for j= 1286:1336
       DATAF(i, j-1285+868)=DATA(i,j);
    end
end
%%%%%%%%%%%%%%%%%% 
%teoria 
DELTA = zeros(7,1)
for i = 1:7
    DELTA(i,1)=DATAF(i,868)-DATAF(i,869);
end

for i = 1:7
    for j = 869:918
    DATAF(i,j)=DATAF(i,j)+DELTA(i,1);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%temperatura nueva
temperaturaf = zeros(7,918);
for k = 1:5
    for l = 1:918
        temperaturaf(k, l) = a1*(DATAF(k, l)*1000000) + a2*(DATAF(k,l)*1000000)^2 + a3*(DATAF(k,l)*1000000)^3 + a4*(DATAF(k,l)*1000000)^4;
    end
end
 

for m = 6:7
    for n = 1:918
        temperaturaf(m,n) = b1*DATAF(m,n)*1000000 + b2*(DATAF(m,n)*1000000)^2 + b3*(DATAF(m,n)*1000000)^3 + b4*(DATAF(m,n)*1000000)^4;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%
tiempof = zeros(7,918);
for j = 1:7
    for i = 1:918
    tiempof(j,i) = tiempo(j,i);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%ploteamos los datos nuevos
figure
hold on
plot(tiempof(1,:), temperaturaf(1,:), 'r.')
plot(tiempof(2,:), temperaturaf(2,:), 'y.')
plot(tiempof(3,:), temperaturaf(3,:), 'c.')
plot(tiempof(4,:), temperaturaf(4,:), 'm.')
plot(tiempof(5,:), temperaturaf(5,:), 'b.')
plot(tiempof(6,:), temperaturaf(6, :), 'g.')
plot(tiempof(7,:), temperaturaf(7,:), 'b.')
hold off
title ('Difusividad térmica')
xlabel ('Tiempo[s]')
ylabel ('Temperatura[°C]')
