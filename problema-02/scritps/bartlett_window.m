function w = bartlett_window(M)
    % bartlett_window calcula a janela de Bartlett
    % w = bartlett_window(M) retorna uma janela de Bartlett de tamanho M.
    % M é o tamanho da janela desejada.
    % w é o vetor de janela de Bartlett resultante.

    if nargin < 1
        error('Número de argumentos insuficiente. Você deve fornecer o tamanho da janela (M).');
    end

    % Geração da janela de Bartlett
    n = (0:M-1)';  % Vetor de índices de 0 a N-1
    w = 2 / (M - 1) * ((M - 1) / 2 - abs(n - (M - 1) / 2));
end
