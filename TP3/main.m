clear;
close all;
%%

image = imread("image fond ifremer.tif");
size(image)
imshow(image)
title('image sous marine');
impixelinfo;

% on voit quatre poissons
%%
R = image(:,:,1);
V = image(:,:,2);
B = image(:,:,3);

figure(2);
subplot(321);
imshow(R);
title('bande rouge');
subplot(322);
imhist(R);
subplot(323);
imshow(V);
title('bande verte');
subplot(324);
imhist(V);
subplot(325);
imshow(B);
title('bande bleue');
subplot(326);
imhist(B);
%%
figure(3);
image = imread("image fond ifremer.tif");
taille = size(image);
imshow(image)
title('image couleur');
impixelinfo;

mask_posi = roipoly(image);
mask_taxi = roipoly(image);
mask_sable = roipoly(image);
save('masks.mat','mask_posi','mask_taxi','mask_sable');
load masks.mat
%%

figure(4);
subplot(321);
imshow(mask_posi);
subplot(323);
imshow(mask_taxi);
subplot(325);
imshow(mask_sable);

%%
image = double(image);

numr1 = sum(sum(image(:,:,1).*mask_posi));
numv1 = sum(sum(image(:,:,2).*mask_posi));
numb1 = sum(sum(image(:,:,3).*mask_posi));
den = sum(sum(mask_posi));
p(1) = numr1/den;
p(2) = numv1/den;
p(3) = numb1/den;

numr2 = sum(sum(image(:,:,1).*mask_taxi));
numv2 = sum(sum(image(:,:,2).*mask_taxi));
numb2 = sum(sum(image(:,:,3).*mask_taxi));
den2 = sum(sum(mask_taxi));
t(1) = numr2/den2;
t(2) = numv2/den2;
t(3) = numb2/den2;

numr3 = sum(sum(image(:,:,1).*mask_sable));
numv3 = sum(sum(image(:,:,2).*mask_sable));
numb3 = sum(sum(image(:,:,3).*mask_sable));
den3 = sum(sum(mask_taxi));
s(1) = numr3/den3;
s(2) = numv3/den3;
s(3) = numb3/den3;

figure(5);
plot(p)
hold on 
plot(t)
hold on
plot(s)
legend('Posi','taxi','sable')
title('Profil spectral')

%%
nl = 800;
nc = 1000;

carte= zeros(nl,nc,3);

for i = 1:nl
    for j = 1:nc
        x = squeeze(image(i, j, :));
        d(1) = sqrt((x(1) - p(1)).^2 + (x(2) - p(2)).^2 + (x(3) - p(3)).^2);
        d(2) = sqrt((x(1) - t(1)).^2 + (x(2) - t(2)).^2 + (x(3) - t(3)).^2);
        d(3) = sqrt((x(1) - s(1)).^2 + (x(2) - s(2)).^2 + (x(3) - s(3)).^2);
        [~, indice] = min(d);

        switch indice
            case 1
                carte(i, j, :) = [0, 0, 255];
            case 2
                carte(i, j, :) = [0, 255, 0];
            case 3
                carte(i, j, :) = [255, 255, 0];
        end
    end
end


figure(7);
imshow(carte)

carte2 = zeros(nl, nc, 3);

for i = 1:nl
    for j = 1:nc
        x = squeeze(image(i, j, :));
        angle(1) = acos(((x(1) * p(1)) + (x(2) * p(2)) + (x(3) * p(3))) / (norm(x) * norm(p)));
        angle(2) = acos(((x(1) * t(1)) + (x(2) * t(2)) + (x(3) * t(3))) / (norm(x) * norm(t)));
        angle(3) = acos(((x(1) * s(1)) + (x(2) * s(2)) + (x(3) * s(3))) / (norm(x) * norm(s)));
        [~, indice] = min(angle);
        switch indice
            case 1
                carte2(i, j, :) = [0, 0, 255];
            case 2
                carte2(i, j, :) = [0, 255, 0];
            case 3
                carte2(i, j, :) = [255, 255, 0];
        end
    end
end

figure(8);
imshow(carte2);