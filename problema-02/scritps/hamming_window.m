function w = hamming_window(N)
    % hamming_window calcula a janela de Hamming
    % w = hamming_window(N) retorna uma janela de Hamming de tamanho N.
    % N é o tamanho da janela desejada.
    % w é o vetor de janela de Hamming resultante.

    if nargin < 1
        error('Número de argumentos insuficiente. Você deve fornecer o tamanho da janela (N).');
    end

    % Geração da janela de Hamming
    n = (0:N-1)';  % Vetor de índices de 0 a N-1
    w = 0.54 - 0.46 * cos((2 * pi * n) / (N - 1));
end
