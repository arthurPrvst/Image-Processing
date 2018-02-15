function imageFiltree = filtrerImageQ1(image)

%Reduction du bruit poivre et sel par application de filtres medians
%itérativement

passe1 = medfilt2(image,[5,5]);
passe2 = medfilt2(passe1,[9,11]);
passe3 = medfilt2(passe2,[5,5]);
passe4 = medfilt2(passe3,[3,3]);
imageFiltree = medfilt2(passe4,[3,3]);

%subplot(3,2,1),imshow(imagenonfiltre),title('Avant le traitement ');
%subplot(3,2,2),imshow(imageFiltree),title('Après le traitement-med');

end
