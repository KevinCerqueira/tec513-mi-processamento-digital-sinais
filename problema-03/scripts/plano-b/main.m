pkg load image

img = imread('lena.tiff');
if size(img, 3) == 3
    gray_image = rgb2gray(img);
else
    gray_image = img;
end

edges = edge(gray_image, 'sobel');

internal_mask = imcomplement(edges);
internal_mask = imfill(internal_mask, 'holes');

% Criar o elemento estruturante manualmente
radius = 15;
se = getnhood(strel('square', 2*radius+1 ));
se = imrotate(se, 90);

% Aplicar dilatação somente nas áreas internas
dilated_image = gray_image;
dilated_image(internal_mask) = imopen(gray_image(internal_mask), se);

%subplot(2,2,3);
%imshow(edges), title('Bordas detectadas');

% Aplicar desfoque nas áreas internas
h = fspecial('gaussian', [15 15], 25);  % Ajuste o tamanho e o desvio padrão conforme necessário
blurred_image = dilated_image;
blurred_image(internal_mask) = imfilter(dilated_image(internal_mask), h, 'replicate');

% Exibir a imagem desfocada
figure;
%subplot(2,2,1);
%imshow(gray_image), title('Imagem em tons de cinza');
%subplot(2,2,2);
imshow(blurred_image), title('Imagem com áreas internas desfocadas');
