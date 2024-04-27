clear;
% Carregue o pacote de processamento de sinais
% pkg load signal;

%% dados do sinal
f1 = 50;%Freq entrada Hz
f2 = 200;%Freq entrada Hz
f = 100*f2; %frequencia de resolucao
Fs = 5*f2; %Taxa de amostragem (em Hz)
ts = [0:1/Fs:0.2];%Periodo de amostragem

%% gerar sinal "contínuo"
t_continuo = [0:1/(f):0.2];

% Sinal de entrada
sinal_entrada = 100*sin(2*pi*f1*t_continuo)+50*sin(2*pi*f2*t_continuo);

% 1. Aplicar a Transformada de Fourier (FFT) no sinal de entrada
sinal_fft_entrada = fft(sinal_entrada);
frequencias_fft_entrada = (0:length(sinal_fft_entrada)-1) * (f/length(sinal_fft_entrada));

% 1.1. Calcular as frequências correspondentes ao espectro
N = length(sinal_entrada); % Comprimento do sinal
disp(N);
frequencias = (0:N-1) * (f / N); % Frequências correspondentes

% 1.2. Calcular a magnitude da FFT e ajustar a escala
magnitude_fft = abs(sinal_fft_entrada) / N;

% 1.3. Usar fftshift para centralizar o espectro
magnitude_fft_shifted_sinal_entrada = fftshift(magnitude_fft);
frequencias_shifted_sinal_entrada = (-N/2:N/2-1) * (f / N); % Frequências centralizadas

% 2. Aplicar um filtro anti-aliasing no sinal
% wp = 50/(f/2);
% ws = 200/(f/2);
fc = 50/(f/2);
n = 6;
% [n,wn] = buttord(wp,ws,3,60);
[b, a] = butter(n, fc, 'low');
sinal_filtrado = filter(b, a, sinal_entrada);


% 3. Aplicar a FFT no sinal filtrado
sinal_fft_filtrado = fft(sinal_filtrado);
frequencias_fft_filtrado = (0:length(sinal_fft_filtrado)-1) * (f/length(sinal_fft_filtrado));

% 3.1. Calcular as frequências correspondentes ao espectro do sinal filtrado
N_filtrado = length(sinal_filtrado); % Comprimento do sinal filtrado
frequencias_filtrado = (0:N_filtrado-1) * (f / N_filtrado); % Frequências correspondentes

% 3.2. Calcular a magnitude da FFT e ajustar a escala para o sinal filtrado
magnitude_fft_filtrado = abs(sinal_fft_filtrado) / N_filtrado;

% 3.3. Usar fftshift para centralizar o espectro do sinal filtrado
magnitude_fft_shifted_sinal_filtrado = fftshift(magnitude_fft_filtrado);
frequencias_shifted_sinal_filtrado = (-N_filtrado/2:N_filtrado/2-1) * (f / N_filtrado); % Frequências centralizadas

% 4. Amostragem o sinal filtrado
pulso = 0.5*square(2 * pi * Fs * t_continuo)+0.5;

% 5. Aplicar a FFT no pulso retangular;
fft_pulso = fft(pulso);

% 5.1. Calcular as frequências correspondentes ao espectro do sinal filtrado
N_pulso = length(pulso); % Comprimento do sinal filtrado
frequencias_pulso = (0:N_pulso-1) * (f / N_pulso); % Frequências correspondentes
% 5.2. Calcular a magnitude da FFT e ajustar a escala para o sinal filtrado
magnitude_fft_pulso = abs(fft_pulso) / N_pulso;
% 5.3. Usar fftshift para centralizar o espectro do sinal filtrado
magnitude_fft_shifted_sinal_pulso = fftshift(magnitude_fft_pulso);
frequencias_shifted_sinal_pulso = (-N_pulso/2:N_pulso/2-1) * (f / N_pulso); % Frequências centralizadas

% 6. Amostragem do sinal
sinal_amostrado =  sinal_filtrado.*pulso;

% 7. Aplicar a FFT no sinal amostrado;
fft_sinal_amostrado = fft(sinal_amostrado);

% 7.1. Calcular as frequências correspondentes ao espectro do sinal filtrado
N_amostrado = length(sinal_amostrado); % Comprimento do sinal filtrado
frequencias_amostrado = (0:N_amostrado-1) * (f / N_amostrado); % Frequências correspondentes

% 7.2. Calcular a magnitude da FFT e ajustar a escala para o sinal filtrado
magnitude_fft_amostrado = abs(fft_sinal_amostrado) / N_amostrado;

% 7.3. Usar fftshift para centralizar o espectro do sinal filtrado
magnitude_fft_shifted_sinal_amostrado = fftshift(magnitude_fft_amostrado);
frequencias_shifted_sinal_amostrado = (-N_amostrado/2:N_amostrado/2-1) * (f / N_amostrado); % Frequências centralizadas


% Parâmetros do filtro passa-baixa ideal
fc = 60; % Frequência de corte em Hz
t_tempo = [0:1/Fs:0.2]; % Vetor de tempo correspondente ao sinal amostrado

% Crie um filtro passa-baixa ideal no domínio da frequência usando a função square
filtro_passa_baixa_quadrado = zeros(size(frequencias_amostrado));
filtro_passa_baixa_quadrado(frequencias_amostrado <= fc) = 1;

% Aplique o filtro na transformada de Fourier do sinal amostrado
sinal_filtrado_fft_quadrado = fft_sinal_amostrado .* filtro_passa_baixa_quadrado;

% Agora, você pode calcular a transformada inversa para obter o sinal no domínio do tempo
sinal_filtrado_tempo_quadrado = ifft(sinal_filtrado_fft_quadrado);

% ampliação do sinal reconstruido
fator_ampliacao = 3; % ampliação de 3 vezes
sinal_reconstruido = sinal_filtrado_tempo_quadrado * fator_ampliacao;

% 7.4. Calcular as frequências correspondentes ao espectro do sinal filtrado
N_reconstruido = length(sinal_reconstruido); % Comprimento do sinal filtrado
frequencias_reconstruido = (0:N_reconstruido-1) * (f / N_reconstruido); % Frequências correspondentes

% 7.5. Calcular a magnitude da FFT e ajustar a escala para o sinal filtrado
magnitude_fft_reconstruido = abs(sinal_filtrado_fft_quadrado) / N_reconstruido;

% 7.6. Usar fftshift para centralizar o espectro do sinal filtrado
magnitude_fft_shifted_sinal_reconstruido = fftshift(magnitude_fft_reconstruido);
frequencias_shifted_sinal_reconstruido = (-N_reconstruido/2:N_reconstruido/2-1) * (f / N_reconstruido); % Frequências centralizadas

% Plot dos resultados
figure;

% Plot do sinal de entrada
subplot(4, 2, 1);
plot(t_continuo, sinal_entrada);
title('Sinal Senoidal de Entrada');
% Defina os limites dos eixos X e Y
xlim([0.04, 0.13]); % Limita o eixo X de 0.1 a 0.15
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot da FFT do sinal de entrada
subplot(4, 2, 3);
plot(frequencias_shifted_sinal_entrada, magnitude_fft_shifted_sinal_entrada,'-');
title('Espectro do Sinal de Entrada');
xlim([-400, 400]); % Limita o eixo X de -400 a 400
xlabel('Frequência (Hz)');
ylabel('Amplitude');

% Plot do sinal de entrada filtrado
subplot(4, 2, 2);
plot(t_continuo, sinal_filtrado);
title('Sinal Filtrado (Passa-Baixa)');
xlim([0.04, 0.13]); % Limita o eixo X de 0.00 a 0.05
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot da FFT do sinal filtrado
subplot(4, 2, 4);
plot(frequencias_shifted_sinal_filtrado, magnitude_fft_shifted_sinal_filtrado,'-');
title('Espectro do Sinal Filtrado');
xlim([-400, 400]); % Limita o eixo X de -400 a 400
xlabel('Frequência (Hz)');
ylabel('Amplitude');

% Plot do pulso retangular
subplot(4, 2, 5);
plot(t_continuo, pulso);
max_pulso = max(pulso);
extra_height = 0.2; % Para facilitar a visualização
title('Pulso retangular');
xlim([0.0, 0.05]); % Limita o eixo X de 0.0 a 0.05
ylim([0, max_pulso + extra_height]);
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot da fft do trem de pulsos retangular
subplot(4, 2, 7);
plot(frequencias_shifted_sinal_pulso, magnitude_fft_shifted_sinal_pulso,'-');
title('Espectro do trem de pulsos retangular');
xlabel('Frequência (Hz)');
ylabel('Amplitude');

% Plot do sinal amostrado
subplot(4, 2, 6);
plot(t_continuo, sinal_amostrado);
title('Sinal amostrado');
xlim([0.04, 0.13]); % Limita o eixo X de 0.04 a 0.13
xlabel('Tempo (s)');
ylabel('Amplitude');

% Plot da fft do sinal amostrado
subplot(4, 2, 8);
plot(frequencias_shifted_sinal_amostrado, magnitude_fft_shifted_sinal_amostrado,'-');
title('Espectro do sinal amostrado');
xlim([-1000, 1000]); % Limita o eixo X de -1500 a 1500
xlabel('Frequência (Hz)');
ylabel('Amplitude');


hold off;
figure;
% Plot do sinal reconstruido
subplot(4, 2, 1);
plot(t_continuo, sinal_reconstruido, 'b');
title('Sinal Reconstruído');
xlim([0.04, 0.13]); % Limita o eixo X de 0.04 a 0.13
xlabel('Tempo');
ylabel('Amplitude');

% Plot do filtro PB ideal
subplot(4, 2, 3);
stem(frequencias_shifted_sinal_reconstruido, magnitude_fft_shifted_sinal_reconstruido,'.');
title('Espectro do sinal reconstruido');
xlim([-200, 200]); % Limita o eixo X de -200 a 200
xlabel('Frequência (Hz)');
ylabel('Amplitude');

