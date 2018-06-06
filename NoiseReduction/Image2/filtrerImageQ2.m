function imageFiltree = filtrerImageQ2(image)

%Reduction du bruit poivre et sel par application de filtres medians
%itérativement

passe1 = medfilt2(image,[3,3]);
passe2 = medfilt2(passe1,[3,3]);
passe3 = medfilt2(passe2,[3,3]);
passe4 = medfilt2(passe3,[3,3]);
passe5 = medfilt2(passe4,[3,3]);
imageFiltree = medfilt2(passe5,[3,3]);

%subplot(4,2,1),imshow(imagenonfiltre),title('Avant le traitement ');
%subplot(4,2,2),imshow(passe1),title('Après le traitement-med 1');
%subplot(4,2,3),imshow(passe2),title('Après le traitement-med 2');
%subplot(4,2,4),imshow(passe3),title('Après le traitement-med 3');
%subplot(4,2,5),imshow(passe4),title('Après le traitement-med 4');
%subplot(4,2,6),imshow(passe5),title('Après le traitement-med  5');
%subplot(4,2,7),imshow(imageFiltree),title('Après le traitement-med');

end