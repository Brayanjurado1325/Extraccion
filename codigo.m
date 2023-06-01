clear all 
close all

% CARGAR IMAGENES
Tem = imread('FLIR1432.jpg');

% CARGAR CSV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M = csvread('FLIR1432.csv');


% CREAR MASCARA 
figure
mascara = roipoly(Tem);
mascara = imcomplement(mascara);
imshow(mascara);

% APLICAR MASCARA EN IMAGENES 
Tem2 = Tem;
Tem2(mascara) = 0;
figure
imshow(Tem2)


% APLICAR MASCARA EN CSV
M(mascara) = 0;
figure
imshow(M)

% CREAR NUBE DE PUNTOS

L = 480*640;
Data = zeros(L,3);  % 1=X 2=Y 3=temperatura 

n=1;
for i=1:480
    for j=1:640
        if M(i,j)~=0 
            Data(n,1)=i;
            Data(n,2)=j;
            Data(n,3)=M(i,j);
            n=n+1;
        end
    end
end 

Data = Data(1:n-1,:);
Data_muestra= datasample(Data,150)
x = Data_muestra(:,1);
y = Data_muestra(:,2);
z = Data_muestra(:,3);
figure 
scatter(x,y,z)

% Agrupar en 3 partes 
X =  Data_muestra(:,1:2)/200;
rng(1); 
[idx,C] = kmeans(X,3);

x1 = min(X(:,1)):0.01:max(X(:,1));
x2 = min(X(:,2)):0.01:max(X(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; 

idx2Region = kmeans(XGrid,3,'MaxIter',1,'Start',C);

figure;
gscatter(XGrid(:,1),XGrid(:,2),idx2Region,...
    [0,0.75,0.75;0.75,0,0.75;0.75,0.75,0],'..');
hold on;
plot(X(:,1),X(:,2),'k*','MarkerSize',5);
title 'Agrupación de las regiones de la panícula';
legend('Region 1','Region 2','Region 3','Data','Location','SouthEast');
hold off;


% Obtener promedio por cada parte  
