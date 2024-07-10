function process_image()
    % Carregar a imagem original
    image = imread('lena.tiff');

    % Converte para escala de cinza
    image_gray = rgb2gray(image);

     % Coordenadas da face exportada pelo detector.py
    face = load('face.txt');

    % Passo 1: Identifica a região do rosto na imagem
    x = face(1);
    y = face(2);
    w = face(3);
    h = face(4);

    % Passo 2: Copia a imagem original para uma imagem de saída
    image_result = image_gray;

    % Passo 3: Extrai a região do rosto
    face_region = image_gray(y:y+h, x:x+w);

    % Passo 4: Aplica a Transformada de Fourier
    f_transform = fft2(double(face_region));

    % Passo 5: Desloca a Transformada de Fourier
    f_shift = fftshift(f_transform);

    % Passo 6: Remove as frequências elevadas usando um filtro passa-baixa
    % Definindo uma máscara para manter apenas as frequências centrais, através de uma matriz binária.
    [m, n] = size(face_region);
    mask = zeros(m, n);
    radius = 5;
    center = [m/2, n/2];
    for i = 1:m
        for j = 1:n
            if sqrt((i-center(1))^2 + (j-center(2))^2) <= radius
                mask(i, j) = 1;
            end
        end
    end

    % Aplica a máscara às frequências
    f_masked = f_shift .* mask;

    % Passo 7: Desfaz o deslocamento
    f_unshift = ifftshift(f_masked);

    % Passo 8: Aplica a Transformada Inversa de Fourier
    blurred_face = ifft2(f_unshift);
    blurred_face = uint8(abs(blurred_face));

    % Passo 9: Insere a região do rosto desfocada de volta na imagem original
    image_result(y:y+h, x:x+w) = blurred_face;

    % Salva a imagem processada
    imwrite(image_result, 'imagem_desfocada.png');
end

process_image()
