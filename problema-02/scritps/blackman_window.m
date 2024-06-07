function w = blackman_window(M)
    % blackman_window calcula a janela de Blackman
    % w = blackman_window(M) retorna uma janela de Blackman de tamanho M.
    % M é o tamanho da janela desejada.
    % w é o vetor de janela de Blackman resultante.

    if nargin < 1
        error('Número de argumentos insuficiente. Você deve fornecer o tamanho da janela (M).');
    end

    % Geração da janela de Blackman
    n = (0:M-1)';  % Vetor de índices de 0 a M-1
    w = 0.42 - 0.5 * cos((2 * pi * n) / (M - 1)) + 0.08 * cos((4 * pi * n) / (M - 1));
end
