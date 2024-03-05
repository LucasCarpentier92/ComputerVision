clear all
close all
% Charger l'image
donnees1 = load('425aa_2405.mat');
donnees2 = load('425aa_0706.mat');
donnees3 = load('761aa_2306.mat');
image1 = donnees1.I;
image2 = donnees2.I;
image3 = rot90(donnees3.I);

% Obtenir la taille de l'image
taille_image = size(image1);
taille_image2 = size(image2);
taille_image3 = size(image3);

% Afficher la taille de l'image dans l'environnement de travail
disp(['La taille de l''image 1 est : ', num2str(taille_image(1)), ' x ', num2str(taille_image(2)), ' pixels ']);
disp(['La taille de l''image 2 est : ', num2str(taille_image2(1)), ' x ', num2str(taille_image2(2)), ' pixels ']);
disp(['La taille de l''image 3 est : ', num2str(taille_image3(1)), ' x ', num2str(taille_image3(2)), ' pixels ']);
figure;

% Afficher chaque bande spectrale dans un subplot
subplot(2,3,1);
imshow(image1(:,:,1), []);
title('Bande 450 nm');
subplot(2,3,2);
imshow(image1(:,:,2), []);
title('Bande 530 nm');
subplot(2,3,3);
imshow(image1(:,:,3), []);
title('Bande 560 nm');
subplot(2,3,4);
imshow(image1(:,:,4), []);
title('Bande 675 nm');
subplot(2,3,5);
imshow(image1(:,:,5), []);
title('Bande 730 nm');
subplot(2,3,6);
imshow(image1(:,:,6), []);
title('Bande 850 nm');

% Créer les compositions colorées en vraies couleurs pour chaque date
vraies_couleurs1 = image1(:,:,4); % Rouge: 675nm
vraies_couleurs1(:,:,2) = image1(:,:,3); % Vert: 560nm
vraies_couleurs1(:,:,3) = image1(:,:,1); % Bleu: 450nm
vraies_couleurs2 = image2(:,:,4);
vraies_couleurs2(:,:,2) = image2(:,:,3);
vraies_couleurs2(:,:,3) = image2(:,:,1);
vraies_couleurs3 = image3(:,:,4);
vraies_couleurs3(:,:,2) = image3(:,:,3);
vraies_couleurs3(:,:,3) = image3(:,:,1);


% Créer les compositions colorées en fausses couleurs pour chaque date
fausses_couleurs1 = image1(:,:,6);          % Infrarouge: 850nm
fausses_couleurs1(:,:,2) = image1(:,:,3);   % Vert: 560nm
fausses_couleurs1(:,:,3) = image1(:,:,5);   % Bleu: 730nm
fausses_couleurs2 = image2(:,:,6);
fausses_couleurs2(:,:,2) = image2(:,:,3);
fausses_couleurs2(:,:,3) = image2(:,:,5);
fausses_couleurs3 = image3(:,:,6);
fausses_couleurs3(:,:,2) = image3(:,:,3);
fausses_couleurs3(:,:,3) = image3(:,:,5);
figure;
subplot(2,1,1);
imshow(vraies_couleurs1);
impixelinfo;
title('Composition colorée en vraies couleurs');
subplot(2,1,2);
imshow(fausses_couleurs1);
impixelinfo;
title('Composition colorée en fausses couleurs');
% pixel de sol coordonnées (179, 65)
% pixel de végétation coordonnées (208, 50)
figure;
% Afficher les histogrammes des 6 bandes
for i = 1:size(image1, 3)
    subplot(2, 3, i);
    histogram(image1(:, :, i));
    title(['Histogramme - Bande ', num2str(i)]);
    xlabel('Intensité');
    ylabel('Fréquence');
end
% Coordonnées d'un pixel de sol
x_betterave = 230;
y_betterave = 36;

% Coordonnées d'un pixel de betterave
x_sol = 243;
y_sol = 46;

% Longueurs d'onde correspondant à chaque bande spectrale
longueurs_donde = [450, 530, 560, 675, 730, 850]; % en nm
% Extraire les profils spectraux des pixels de sol et de betterave
profil_sol = squeeze(image1(y_sol, x_sol, :)); 
profil_betterave = squeeze(image1(y_betterave, x_betterave, :));
% Tracer les profils spectraux avec les longueurs d'onde en abscisses
figure;
plot(longueurs_donde, profil_sol, 'b', 'LineWidth', 2);
hold on;
plot(longueurs_donde, profil_betterave, 'r', 'LineWidth', 2);
hold off;
title('Profils spectraux des pixels de sol et de betterave');
xlabel('Longueur d''onde (nm)');
ylabel('Réflectance');
legend('Sol', 'Betterave');


R = double(image1(:,:,4)); % Bande 675 nm
PIR = double(image1(:,:,6)); % Bande 850 nm
% Calculer l'indice de végétation NDVI
NDVI = (PIR - R) ./ (PIR + R);
% Afficher l'indice de végétation NDVI
figure;
imshow(NDVI);
colormap('jet');
colorbar;
title('Indice de végétation NDVI');
% Afficher les images dans la même figure
figure;
subplot(3,2,1);
imshow(vraies_couleurs1);
title('Vraies couleurs - Date 1');
subplot(3,2,2);
imshow(fausses_couleurs1);
title('Fausses couleurs - Date 1');
subplot(3,2,3);
imshow(vraies_couleurs2);
title('Vraies couleurs - Date 2');
subplot(3,2,4);
imshow(fausses_couleurs2);
title('Fausses couleurs - Date 2');
subplot(3,2,5);
imshow(vraies_couleurs3);
title('Vraies couleurs - Date 3');
subplot(3,2,6);
imshow(fausses_couleurs3);
title('Fausses couleurs - Date 3');
% Calculer l'indice de végétation NDVI pour chaque image
NDVI1 = (double(image1(:,:,6)) - double(image1(:,:,4))) ./ (double(image1(:,:,6)) + double(image1(:,:,4)));
NDVI2 = (double(image2(:,:,6)) - double(image2(:,:,4))) ./ (double(image2(:,:,6)) + double(image2(:,:,4)));
NDVI3 = (double(image3(:,:,6)) - double(image3(:,:,4))) ./ (double(image3(:,:,6)) + double(image3(:,:,4)));
% Créer une nouvelle figure
figure;
% Afficher les trois NDVI sur une même subplot
subplot(3,1,1);
imshow(NDVI1);
impixelinfo;
colormap('jet'); % Utiliser la même table de couleur 'jet' pour tous les NDVI
colorbar; % Ajouter une échelle de couleur
title('Indice de végétation - Date 1');
subplot(3,1,2);
imshow(NDVI2);
impixelinfo;
colormap('jet');
colorbar;
title('Indice de végétation - Date 2');
subplot(3,1,3);
imshow(NDVI3);
impixelinfo;
colormap('jet');
colorbar;
title('Indice de végétation - Date 3');
%seuil pour chaque date 
seuil1=0.4; %date 1
seuil2=0.4; %date 2
seuil3=0.4; %date 3
culture1= NDVI1> seuil1;
culture2= NDVI2> seuil2;
culture3= NDVI3>seuil3;
%Calcl du nombre de pixel pour une culture
nb_de_pixel1=sum(culture1(:));
nb_de_pixel2=sum(culture2(:));
nb_de_pixel3=sum(culture3(:));
%Calcl du nombre de pixel pour toute l'image
nb_de_pixel_total1=numel(NDVI1);
nb_de_pixel_total2=numel(NDVI2);
nb_de_pixel_total3=numel(NDVI3);
%calcul de la proportion de culture
proportion_culture1=nb_de_pixel1/nb_de_pixel_total1;
proportion_culture2=nb_de_pixel2/nb_de_pixel_total2;
proportion_culture3=nb_de_pixel3/nb_de_pixel_total3;
proportions=[proportion_culture1, proportion_culture2, proportion_culture3];
dates = {'Date 1', 'Date 2', 'Date 3'};
figure;
bar(proportions);
set(gca, 'XTickLabel', dates);
xlabel('Date');
ylabel('Proportion de culture');
title('Proportion de culture au cours du temps');
seuil1=0.4;
pixel_veg1=0;
pixel_sol1=0;
carte1 = zeros(119,484);
seuil2=0.4;
pixel_veg2=0;
pixel_sol2=0;
carte2 = zeros(200,529);
seuil3=0.4;
pixel_veg3=0;
pixel_sol3=0;
carte3 = zeros(87,219);
for i=1:119
    for j=1:484
        if (NDVI1(i,j) >= seuil1)
            pixel_veg1=pixel_veg1+1;
            carte1(i,j) = 255;
        elseif NDVI(i, j) > -1 && NDVI(i, j) < seuil1
            pixel_sol1 = pixel_sol1 + 1;
            carte1(i, j) = 100;
        else
            carte1(i,j)=0;
        end
        carte1=uint8(carte1);
    end
end
for i=1:200
    for j=1:529
        if (NDVI2(i,j) >= seuil2)
            pixel_veg2=pixel_veg2+1;
            carte2(i,j) = 255;
        elseif NDVI2(i, j) > -1 && NDVI2(i, j) < seuil2
            pixel_sol2 = pixel_sol2 + 1;
            carte2(i, j) = 100;
        else
            carte2(i,j)=0;
        end
        carte2=uint8(carte2);
    end
end
for i=1:87
    for j=1:219
        if (NDVI3(i,j) >= seuil3)
            pixel_veg3=pixel_veg3+1;
            carte3(i,j) = 255;
        elseif NDVI3(i, j) > -1 && NDVI3(i, j) < seuil3
            pixel_sol3 = pixel_sol3 + 1;
            carte3(i, j) = 100;
        else
            carte3(i,j)=0;
        end
        carte3=uint8(carte3);
    end
end
figure;
subplot(3, 1, 1);
imshow(carte1);
title('Carte NDVI - Image 1');
subplot(3, 1, 2);
imshow(carte2);
title('Carte NDVI - Image 2');
subplot(3, 1, 3);
imshow(carte3);
title('Carte NDVI - Image 3');