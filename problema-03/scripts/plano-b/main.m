pkg load image;

% Carregar a imagem
img = imread('lena.tiff'); % Substitua 'imagem.jpg' pelo nome do arquivo da sua imagem

% Verificar se a imagem é RGB e converter para tons de cinza se necessário
if size(img, 3) == 3
    img_gray = rgb2gray(img);
else
    img_gray = img;
end

% Aplicar o operador de Sobel manualmente para calcular as bordas
sobel_x = [-1 0 1; -2 0 2; -1 0 1];  % Kernel Sobel para detecção de bordas horizontais
sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];  % Kernel Sobel para detecção de bordas verticais

Gx = conv2(double(img_gray), 2*sobel_x, 'same');
Gy = conv2(double(img_gray), 2*sobel_y, 'same');

% Magnitude do gradiente
magnitude = sqrt(Gx.^2 + Gy.^2);

% Aplicar limiarização para destacar bordas significativas
limiar = 350; % Ajuste o limiar conforme necessário
bordas = magnitude > limiar;

% Mostrar a imagem das bordas detectadas
figure;
subplot(1, 3, 1);
imshow(img);
title('Imagem original');

subplot(1, 3, 2);
imshow(bordas);
title('Bordas detectadas com limiarização (Sobel)');

edges = edge(img_gray, 'canny');
subplot(1,3,3);
imshow(edges);
title('Bordas detectadas com Canny');
