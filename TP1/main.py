import numpy as np
import cv2 as cv2
import matplotlib.pyplot as plt 
import glob
import math
import warnings
warnings.filterwarnings("ignore")



def rgb2gray(img_in):
    img_in = img_in.astype("float")
    img_out = (img_in[:,:,0]+img_in[:,:,1]+img_in[:,:,2])/3
    img_out = img_out.astype('uint8')
    return img_out

def hist_graysclale(img_in):
    h = np.zeros([256,1])
    for i in range(img_in.shape[0]):
        for j in range(img_in.shape[1]):
            valeur = img_in[i,j]
            h[valeur]+=1
    return h

def binarisation(img_in,seuil):
    img_out = np.zeros(img_in.shape)
    for i in range(img_in.shape[0]):
        for j in range(img_in.shape[1]):
            if img_in[i,j]>seuil:
                img_out[i,j] = 255
    return img_out.astype('uint8')

seuil = 127


img_c3 = cv2.imread('test_3bb_blancs.png')
img_g3 = rgb2gray(img_c3)
h_g3 = hist_graysclale(img_g3)
bin_img3 = binarisation(img_g3,seuil)
hist_bin3 = hist_graysclale(bin_img3)
nb_bb = hist_bin3[255]/3


img_c = cv2.imread('test_11bb_blancs.png')
img_g = rgb2gray(img_c)
h_g = hist_graysclale(img_g)
bin_img = binarisation(img_g,seuil)
hist_bin = hist_graysclale(bin_img)


h255 = hist_bin[255]


print(f"Nombre de pixel par bonbon :{(nb_bb)}")
print(f"Nombre de bonbon :{math.ceil(h255/nb_bb)}")

cv2.imshow('Image 3 gris', img_g3)
plt.plot(hist_bin3)
plt.show()
cv2.waitKey(0)
cv2.destroyAllWindows()
plt.close('all')

