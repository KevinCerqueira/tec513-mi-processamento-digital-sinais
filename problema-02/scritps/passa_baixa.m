clear variables;
close all;
clc;

[audio, FreqAmostragem] = audioread('sax.wav');

if size(audio, 2) == 1
    disp('The audio is already mono.');
    mono_audio = audio;
else
    mono_audio = mean(audio, 2);
end

fp = 1500;                  % Freq Passagem
fs = 2000;                  % Freq de Rejeição
fc = (fp + fs) / 2;         % Freq de corte

wp = (2*pi*fp) / FreqAmostragem;    % Freq de passagem discretizada
ws = (2*pi*fs) / FreqAmostragem;    % Freq de rejeição discretizada
wc = (wp + ws) / 2;                 % Freq de corte discretizada
delta_w = abs(ws - wp);

janela_funcs = {@hamming_window, @hanning_window, @bartlett_window, @square_window, @blackman_window};
janela_names = {'Hamming', 'Hanning', 'Bartlett', 'Retangular', 'Blackman'};
windows_const = [3.3, 3.1, 2.9, 0.9, 5.5];  % Constantes das janelas para cálculo do comprimento do filtro

for i = 1:length(windows_const)
    % Tamanho da janela N
    N = ceil(windows_const(i)/(delta_w / (2 * pi)));
    %Ordem do filtro M = N - 1
    M = N - 1;

    % Garantir que M seja ímpar (para centralizar corretamente o índice)
    if mod(M, 2) == 0
        M = M + 1;
    end

    disp(['Para a janela ' janela_names{i} ':']);
    disp(['Ordem filtro (M): ' num2str(M)]);
    disp(['Comprimento da janela (N): ' num2str(N)]);

    % Gerar o filtro ideal passa-alta (invertendo o filtro passa-baixa)
    n = -(M-1)/2:(M-1)/2;
    % Passa-alta
    %h_ideal = -sin(wc * n) ./ (pi * n);
    %h_ideal((M+1)/2) = 1 - wc / pi;

    %Passa-baixa
    h_ideal = sin(wc * n) ./ (pi * n);
    h_ideal((M+1)/2) = wc / pi;

    % Gerar a janela
    w = janela_funcs{i}(M);

    % Aplicar a janela ao filtro
    h = h_ideal .* w';

    % Plotar o filtro ideal e seu espectro
    Nfft = length(h_ideal);
    H_ideal_fft = fft(h_ideal, Nfft);
    f_ideal_fft_hz = (-Nfft/2: Nfft/2 - 1) * (FreqAmostragem / Nfft);
    f_ideal_fft_rad = (2*pi*f_ideal_fft_hz) / FreqAmostragem;

    figure('Name', janela_names{i});
    subplot(4, 1, 1);
    stem(n, h_ideal);
    title(sprintf('Filtro para N = %d Amostras', N));
    xlabel('Amostra');
    ylabel('Amplitude');
    grid on;

    subplot(4, 1, 2);
    [H, f_hz] = freqz(h, 1, 1024, FreqAmostragem);
    f_rad =  (2*pi*f_hz) / FreqAmostragem;
    plot(f_rad, 20*log10(abs(H)));
    title('Espectro do Filtro - Resposta em Frequência');
    xlabel('Frequência (Rad)');
    ylabel('Magnitude (dB)');
    xlim([0 1]);
    grid on;

    % Convoluir o sinal de áudio com o filtro projetado
    audio_filtrado = conv(mono_audio, h, 'same');
    audiowrite(sprintf('audio_filtrado_PB_%s.wav', janela_names{i}), audio_filtrado, FreqAmostragem);

    % Calcular o espectro do áudio filtrado
    N_audio_filtrado = length(audio_filtrado);
    AudioFiltrado_fft = fft(audio_filtrado, N_audio_filtrado);
    f_AudioFiltrado_fft_hz = (-N_audio_filtrado/2:N_audio_filtrado/2-1) * (FreqAmostragem / N_audio_filtrado);
    f_AudioFiltrado_fft_rad = (2*pi*f_AudioFiltrado_fft_hz) / FreqAmostragem;


    N_audio = length(mono_audio);
    Audio_fft = fft(mono_audio, N_audio);
    f_Audio_fft_hz = (-N_audio/2:N_audio/2-1) *(FreqAmostragem/N_audio);
    f_Audio_fft_rad = (2*pi*f_Audio_fft_hz) / FreqAmostragem;
    subplot(4, 1, 4);
    % Plotar o espectro do áudio filtrado
    stem(f_AudioFiltrado_fft_rad, 20*log10(fftshift(abs(AudioFiltrado_fft))), '.');
    title('Espectro do Áudio Filtrado');
    xlabel('Frequência (Rad)');
    ylabel('Magnitude (dB)');
    xlim([-1 1]);
    ylim([-120, 100])
    grid on;

    subplot(4, 1, 3);
    stem(f_ideal_fft_rad, 20*log10(fftshift(abs(H_ideal_fft))), '.');
    hold on;
    stem(f_Audio_fft_rad, 20*log10(fftshift(abs(Audio_fft))), '.');
    hold off;
    title('Espectros de Filtro e Sinal Original');
    xlabel('Frequência (Rad)');
    ylabel('Magnitude (dB)');
    xlim([-1 1]);
    ylim([-120, 100])
    grid on;

end

