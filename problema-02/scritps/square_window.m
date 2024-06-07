function w = rectangular_window(M)
    % rectangular_window calcula a janela retangular
    % w = rectangular_window(M) retorna uma janela retangular de tamanho M.
    % M é o tamanho da janela desejada.
    % w é o vetor de janela retangular resultante.

    if nargin < 1
        error('Número de argumentos insuficiente. Você deve fornecer o tamanho da janela (M).');
    end

    % Geração da janela retangular
    w = ones(M, 1);
end
