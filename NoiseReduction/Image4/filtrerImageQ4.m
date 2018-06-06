function imageFiltree=filtrerImageQ4(image)

dim=size(image);
masque=zeros(dim);


[Du, Dv] = size(image); % taille du masque identique à celle de f
D = @(u,v) ((u-Du/2).^2 + (v-Dv/2).^2).^0.5; % distance euclidienne au centre
D0 = 47; % le petit rayon
W = 5; % la largeur de l'anneau
[v,u] = meshgrid(1:Dv,1:Du);
masque = double((D(u,v) < D0) | (D(u,v) > (D0+W)));


imageFiltree=appliquerFiltreFrequentiel(image,masque);
end

function [ imageFiltree ] = appliquerFiltreFrequentiel( image,masque)
% Cette fonction applique un filtre fréquentiel.
%
% exemple:
% 


% le masque doit être de la bonne taille
if ~isequal(size(masque),size(image))
    error('L''image et le masque doivent avoir la même taille.')
end

% On traite l'image en double
if isequal(class(image),'uint8')
    image = im2double(image);
end


% Calcul et centrage du spectre de l'image
Fc = fftshift( fft2(double(image)) );

% Multiplication point par point du spectre et du masque
Fc1 = Fc.*(masque);

% Decentrage du spectre
F1 = ifftshift(Fc1);
% Calcul de la transformée inverse
imageFiltree = real( ifft2(F1) );
end