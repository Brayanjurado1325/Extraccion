clear all 
close all

% CARGAR IMAGENES
Tem = imread('FLIR1432.jpg');

% CARGAR CSV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%M = readmatrix('FLIR1432.csv','Range','B2:E3');% EL rango debe adaptarse a los cv de FLuke 
M = randi([28,32],480,640)


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
[idx,C] = kmeans(X(:,[1,2]),3);

x1 = min(X(:,1)):0.01:max(X(:,1));
x2 = min(X(:,2)):0.01:max(X(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; 

[idx,C] = kmeans(X,3); % EN Idx esta la ubicacion de cada grupo


x1 = min(X(:,1)):0.01:max(X(:,1));
x2 = min(X(:,2)):0.01:max(X(:,2));
[x1G,x2G] = meshgrid(x1,x2);
XGrid = [x1G(:),x2G(:)]; % Defines a fine grid on the plot

idx2Region = kmeans(XGrid,3,'MaxIter',1,'Start',C);

% Obtener promedio por cada parte  

L = 150;

P1 =zeros(1);
P2 =zeros(1);
P3 =zeros(1);

for i=1:L

    if idx(i)==1
        if length(P1) == 1 && P1(length(P1)) == 0
            P1(1)= z(1);
        else
            P1(length(P1)+1)=z(i);
        end

    elseif idx(i)==2
        if length(P2) == 1 && P2(length(P2)) == 0
            P2(1)= z(1);
        else
            P2(length(P2)+1)=z(i);
        end
    else 
        if length(P3) == 1 && P3(length(P3)) == 0
            P3(1)= z(1);
        else
            P3(length(P3)+1)=z(i);
        end

    end

end


R1 = sprintf('Region 1 = %.1f ',mean(P1));
R2 = sprintf('Region 2 = %.1f ',mean(P2));
R3 = sprintf('Region 3 = %.1f ',mean(P3));


figure;
gscatter(XGrid(:,1),XGrid(:,2),idx2Region,...
    [0,0.75,0.75;0.75,0,0.75;0.75,0.75,0],'..');
hold on;
plot(X(:,1),X(:,2),'k*','MarkerSize',5);
title 'Fisher''s Iris Data';
xlabel 'Petal Lengths (cm)';
ylabel 'Petal Widths (cm)'; 
legend(R1,R2,R3,'Data','Location','SouthEast');
hold off;

