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

Note : you can get the magnitude (spectre) of the image using : ```afficherMagnitudeFourier('myImage.jpg');```
## Movement detection on images

