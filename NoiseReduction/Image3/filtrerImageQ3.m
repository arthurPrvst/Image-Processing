function imageFiltree = filtrerImageQ3(image)
%On enleve le bruit cyclique avec des filtres passe bande

%Deux filtres coupe bande 
[Du, Dv] = size(image); % taille du masque identique à celle de f
D = @(u,v) ((u-Du/2).^2 + (v-Dv/2).^2).^0.5; % distance euclidienne au centre
D0 = 195; % le petit rayon du coupe bande numero 1
D02 = 398; % le petit rayon du coupe bande numero 2

W = 8; % la largeur de l'anneau du coupe bande numero 1
W2 = 8; % la largeur de l'anneau du coupe bande numero 2

[v,u] = meshgrid(1:Dv,1:Du);
masque = double( ((D(u,v) < D0) | (D(u,v) > (D0+W))) & ((D(u,v) < D02) | (D(u,v) > (D02+W2))) );

%masqueButterworthCoueBande1 = 1 /(1 +( (D(u,v)*W)/(mpower(D(u,v),2)-(D0*D0)) ));
%masqueButterworthCoueBande2 = 1 /(1 +( (D(u,v)*W2)/(mpower(D(u,v),2)-(D02*D02)) ));

subplot(1,2,1),imshow(masque);
%le masque des coupes bandes 1 et 2 doit être de la bonne taille
if ~isequal(size(masque),size(image))
    error('L''image et le masque doivent avoir la même taille.')
end


%On traite l'image en double
if isequal(class(image),'uint8')
    image = im2double(image);
end


% Calcul et centrage du spectre de l'image
Fc = fftshift( fft2(double(image)) );

% Multiplication point par point du spectre et du masque coupe bande 1
Fc1 = Fc.*masque;

% Decentrage du spectre
F1 = ifftshift(Fc1);

% Calcul de la transformée inverse
imageFiltreeSansMedian = real( ifft2(F1) );

%Reduction du sel et poivre avec filtres median
passe = medfilt2(imageFiltreeSansMedian,[3,3]);
imageFiltree = medfilt2(passe,[3,3]);

subplot(3,2,1),imshow(image),title('Avant le traitement frequentiel');
imageFiltree = uint8(imageFiltree*255);
subplot(3,2,2),imshow(masque),title('masque');
subplot(3,2,3),imshow(imageFiltree),title(' Après le traitement frequentiel');

end
