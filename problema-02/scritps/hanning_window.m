function w = hanning_window(M)
    % hanning_window calcula a janela de Hanning
    % w = hanning_window(M) retorna uma janela de Hanning de tamanho M.
    % N é o tamanho da janela desejada.
    % w é o vetor de janela de Hanning resultante.

    if nargin < 1
        error('Número de argumentos insuficiente. Você deve fornecer o tamanho da janela (M).');
    end

    % Geração da janela de Hanning
    n = (0:M-1)';  % Vetor de índices de 0 a M-1
    w = 0.5 - 0.5 * cos((2 * pi * n) / (M - 1));
end
