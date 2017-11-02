% script simple bad day
close all

% I = imread('It16U.tiff');

I = imread('im300_2.tiff');

% see http://www.peterkovesi.com/matlabfns/
[~,~,~, I] = phasecong3(I);

I = I(54:438,105:493);

% I = bt_niblackbin(I);

[rows, cols] = size(I);

I = double(I);

Ir = noisy_defdet(I);


Ir = Ir(1:rows,1:cols);


Ir = double(Ir).*I;



figure;
subplot(1,2,1);
imshow(I,[]);
subplot(1,2,2);
imshow(Ir,[]);
