import rasterio
import matplotlib.pyplot as plt
import numpy as np
from skimage import exposure

with rasterio.open('images/pleiade.img') as dataset:
    red = dataset.read(1)
    green = dataset.read(2)
    blue = dataset.read(3)

    red_normalized = red / red.max()
    green_normalized = green / green.max()
    blue_normalized = blue / blue.max()
    image = np.dstack((red_normalized, green_normalized, blue_normalized))

    red_eq = exposure.equalize_adapthist(red_normalized, clip_limit=0.03)
    green_eq = exposure.equalize_adapthist(green_normalized, clip_limit=0.03)
    blue_eq = exposure.equalize_adapthist(blue_normalized, clip_limit=0.03)
    image_eq = np.dstack((red_eq, green_eq, blue_eq))

    crop = (500, 500, 1000, 1000)  # x, y, w, h
    crop_2 = (3700, 500, 550, 250)  # x, y, w, h
    end_x = crop_2[0] + crop_2[2]
    end_y = crop_2[1] + crop_2[3]

    image_cropped = image_eq[crop_2[1]:end_y, crop_2[0]:end_x]


    plt.figure(figsize=(10, 10))
    plt.imshow(image_eq)
    plt.axis('off')
    plt.show()

    plt.figure(figsize=(10, 10))
    plt.imshow(image_cropped)
    plt.axis('off')
    plt.show()

    plt.imsave('images/pleiade.png', image_eq)
    plt.imsave('images/cropped_pleiade2.png', image_cropped)

# 'driver': 'ENVI' raster file format
# 'dtype': 'uint16' - pixel data type (unsigned int on a 16 basis
# 'nodata': None - spare values if no data retrieved
# 'width': 5000, 'height': 3000 - dimension of the image
# 'count': 4 - number of bands
# 'crs': CRS.from_epsg(2154) - location system used
# 'transform': Affine()