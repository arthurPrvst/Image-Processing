%Function that counts number of single bubles and grouped bubles
function [bulle, groupes] = compteBulles(image)
cc = bwconncomp(image); %nb connected component
b = rgb2gray(image); 

f = bwlabel(b);
figure, imshow(f), title('Labelled image');

g = regionprops(f, 'Area');

g(1)
area_values = [g.Area];
idx = find((0<=area_values) & (area_values <= 550));

h = ismember(f, idx); % tresholding

figure, imshow(h),title('Area between 7000 and 9000');

bulle = bwconncomp(h);
bulle = bulle.NumObjects; %get number of single buble


groupes = cc.NumObjects - bulle; %get number of connected component

end