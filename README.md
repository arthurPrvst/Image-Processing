# Image-Processing
Image processing using matlab.

## Noise reduction on images
The main purpose of the noise reduction here is to reduce the mean square
error (MSE).

* imageName.jpg : Initial MSE / MSE after the image-processing :
* ```montreal.jpg``` : 4433 / 149
* ```navette.jpg``` : 7001 / 51
* ```ourspolaires.jpg``` : 2139 / 252
* ```lena.jpg``` - x / x

### How to use it
```noisedImage = imread('myimageX.jpg');```
```res = filtrerImageX(noisedImage);```
```evaluerSolutionQX(res);```

Note : you can get the magnitude (spectre) of the image using : ```afficherMagnitudeFourier('myImage.jpg');```.

## Morphological processing on color
Different matlab code are presented here. They are using morphological operators to count shapes, to separate forms. There is also a segmentation with colors thresholding.
### CompteBulles
The purpose of this code is to count the number of isolated bubble, and the number of agglomerated bubble (group of bubbles). The source image is ``` bulles.bmp ```.
* You can use it like that : 
```image = imread('bulles.bmp');```
```[NbIsolatedBubbles, NbAgglomeratedBubbles] = compteBulles(image);```
This will display you 2 images containing for each isolated bubbles or agglomerated bubbles.
### CompterCarres
The purpose of this code is to count the number of squares having the same size, for each size existing in the image ```carres.png```.
* You can use it like that :
```image = imread('carres.png');```
```histo = compterCarres(image);```
histo is row vector containing the number of square detected for a specific size. The first value will be the number of square having a 1px width, and so one...
### TrouverFraises
The purpose of this code is to separate strawberry's leaves from strawberry's body using segmentation.
* You can use it like that :
```image = imread('Fraises.jpg');```
```trouverFraises(image);```
This will display a a binary image containing only strawberry's leaves.

## Movement detection on images
The purpose here is to correctly classify images from a security camera. There are two classes for images: positive images, in which there are moving cars or pedestrians and negative images or there is no movement. According to the image training set in ```negative``` and ```positive``` folders, the code gives you a boolean if he detects a mouvement in the new image from the same camera you gave him.
* You can use it like that :
```image = imread('imageFromCamera.jpg');```
```imagemoveGRAYF(image);```
Note : this works could have been done with machine learning (labbeled image => supervised).

## PaperClip_Problem
The purpose of the code is to count the number of paper clips of each color in a series of images, and to know the position of their center. Different images of paperclip are available in the ``trombonesImages``` folder.
* You can use it like that :
```image = imread('trbn1.jpg');```
```[x, y, c] = trouverTrombones(image);```
x is a vector containing the number of paperclip that have been detected.
y is a vector containing the horinzontal position of the detected paperclip.
c is a vector containng the color of the detected paperclip.
