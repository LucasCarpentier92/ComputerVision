import cv2
import numpy as np
import matplotlib.pyplot as plt

image_path = 'images/cropped_pleiade2.png'
image = cv2.imread(image_path)
image_copy = image.copy()
image_copy = cv2.cvtColor(image_copy, cv2.COLOR_BGR2RGB)

# Affichage de la shape de l'image
shape = image.shape  # (800,1000,3)
print(shape)

# Affichage de chaque bande de l'image
B,G,R = cv2.split(image)

histB = cv2.calcHist([B],[0],None,[256],[0,256])
histG = cv2.calcHist([G],[0],None,[256],[0,256])
histR = cv2.calcHist([R],[0],None,[256],[0,256])


plt.figure(figsize=(9,9))
plt.subplot(3,3,1)
plt.imshow(cv2.cvtColor(B, cv2.COLOR_BGR2RGB))
plt.title("Canal Bleu")
plt.axis('off')

plt.subplot(3,3,4)
plt.imshow(cv2.cvtColor(G, cv2.COLOR_BGR2RGB))
plt.title("Canal Vert")
plt.axis('off')

plt.subplot(3,3,7)
plt.imshow(cv2.cvtColor(R, cv2.COLOR_BGR2RGB))
plt.title("Canal Rouge")
plt.axis('off')

plt.subplot(3, 3, 3)
plt.plot(histB, color='blue')
plt.title('Histogramme du Canal Bleu')
plt.xlim([0, 256])

plt.subplot(3, 3, 6)
plt.plot(histG, color='green')
plt.title('Histogramme du Canal Vert')
plt.xlim([0, 256])

plt.subplot(3, 3, 9)
plt.plot(histR, color='red')
plt.title('Histogramme du Canal Rouge')
plt.xlim([0, 256])
plt.show()

# Nombre de ROIs à sélectionner
nb_rois = 3
rois = []
roi_names = []

# Sélectionner les ROIs et nommer chacune (le code reste inchangé)
for i in range(nb_rois):
    roi = cv2.selectROI("Selectionnez le ROI", image)
    rois.append(roi)
    name = input(f"Entrez un nom pour le ROI {i + 1}: ")
    roi_names.append(name)
    print(roi)

cv2.destroyAllWindows()

# Affichage de l'image avec les ROIs nommées
plt.figure(figsize=(6, 6))
plt.imshow(image_copy)
plt.title("Image avec ROIs")
for i, roi in enumerate(rois):
    x, y, w, h = roi
    plt.gca().add_patch(plt.Rectangle((x, y), w, h, linewidth=2, edgecolor='green', facecolor='none'))
    plt.text(x, y - 10, roi_names[i], color='green', fontsize=12)
plt.axis('off')
plt.show()

plt.figure(figsize=(10, 4))

# Affichage de chaque ROI dans un subplot
for i, (roi, name) in enumerate(zip(rois, roi_names)):
    x, y, w, h = roi
    roi_img = image_copy[y:y+h, x:x+w]

    plt.subplot(1, 3, i+1)  # 3 subplots, pour les 3 ROIs
    plt.imshow(roi_img)
    plt.title(name)
    plt.axis('off')

plt.tight_layout()
plt.show()

# Calcul de la valeur moyenne pour chaque canal de chaque ROI
means_B = []
means_G = []
means_R = []

for (x, y, w, h) in rois:
    roi_B = B[y:y + h, x:x + w]
    roi_G = G[y:y + h, x:x + w]
    roi_R = R[y:y + h, x:x + w]

    means_B.append(np.mean(roi_B))
    means_G.append(np.mean(roi_G))
    means_R.append(np.mean(roi_R))


plt.figure(figsize=(8, 6))
bands = ['Rouge', 'Vert', 'Bleu']
x = range(len(bands))

for i in range(len(rois)):
    means = [means_R[i], means_G[i], means_B[i]]
    plt.plot(x, means, marker='o', linestyle='-', label=roi_names[i])

plt.xticks(x, bands)
plt.xlabel('Bande Spectrale')
plt.ylabel('Intensité Moyenne')
plt.title('Profil Spectral des ROIs')
plt.legend()
plt.grid(True)
plt.show()

# Classification
centroids = []
for (x, y, w, h) in rois:
    roi = image[y:y+h, x:x+w]
    mean_colors = np.mean(roi, axis=(0, 1))
    centroids.append(mean_colors)

p, t, s = centroids

carte = np.zeros_like(image)
carte2 = np.zeros_like(image)

# Classification utilisant la distance euclidienne
for i in range(image.shape[0]):
    for j in range(image.shape[1]):
        x = image[i, j, :]
        d = np.array([np.linalg.norm(x - p), np.linalg.norm(x - t), np.linalg.norm(x - s)])
        indice = np.argmin(d)

        if indice == 0:
            carte[i, j, :] = [173, 216, 230]
        elif indice == 1:
            carte[i, j, :] = [34, 139, 34]  # Vert
        elif indice == 2:
            carte[i, j, :] = [255, 255, 102]  # Jaune

# Classification utilisant le Spectral Angle Mapper (SAM)
for i in range(image.shape[0]):
    for j in range(image.shape[1]):
        x = image[i, j, :]
        angle = np.array([
            np.arccos(np.clip(np.dot(x, p) / (np.linalg.norm(x) * np.linalg.norm(p)), -1.0, 1.0)),
            np.arccos(np.clip(np.dot(x, t) / (np.linalg.norm(x) * np.linalg.norm(t)), -1.0, 1.0)),
            np.arccos(np.clip(np.dot(x, s) / (np.linalg.norm(x) * np.linalg.norm(s)), -1.0, 1.0))
        ])
        indice = np.argmin(angle)

        if indice == 0:
            carte2[i, j, :] = [173, 216, 230]  # Rouge
        elif indice == 1:
            carte2[i, j, :] = [34, 139, 34]  # Vert
        elif indice == 2:
            carte2[i, j, :] = [255, 255, 102]  # Jaune

# Affichage des résultats avec Matplotlib
plt.figure(figsize=(12, 6))

plt.subplot(1, 2, 1)
plt.imshow(carte)
plt.title('Classification par Distance Euclidienne')

plt.subplot(1, 2, 2)
plt.imshow(carte2)
plt.title('Classification par SAM')

plt.show()