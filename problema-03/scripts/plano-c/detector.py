import numpy as np
import cv2
import subprocess
import os

# Carregar o classificador pré-treinado para detecção de rostos
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

# Carregar a imagem
image = cv2.imread('lena.tiff')

# Detectar rosto na imagem
face = face_cascade.detectMultiScale(image, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

if len(face) == 0:
    print('Nenhum rosto detectado')
    exit()

# Coordenadas do rosto
x, y, w, h = face[0]

# Adicionar margem ao redor do rosto
margin = 10
x = max(0, x - margin)
y = max(0, y - margin)
w = min(image.shape[1] - x, w + 2 * margin)
h = min(image.shape[0] - y, h + 2 * margin)

# Salvar as coordenadas do rosto para processamento no Octave
np.savetxt('face.txt', np.array([x, y, w, h]), fmt='%d')

# Chamar script Octave para processar a imagem
subprocess.run(['octave', '--no-gui', '--quiet', 'process_image.m'])

# Verificar se o arquivo de saída foi gerado
if not os.path.exists('imagem_desfocada.png'):
    print('Erro: A imagem processada não foi gerada.')
    exit()
else:
    print('\n Imagem desfocada com sucesso!')