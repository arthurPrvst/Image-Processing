function Output=testing
global Pimages;

actualfold=pwd;
posfold=strcat(actualfold,'\positive\');
negfold=strcat(actualfold,'\negative\');
readpic(posfold,negfold);
buf=0;
additiv=0;
for i=1:36
    buf=imagemoveGRAYF(Pimages(:,:,i));
    if buf
        additiv=additiv+1;
    end
end

Output=additiv;
end

%initialisation of all the picture
%back ground picture in ndirectory
function readpic(pdirectory,ndirectory)
global Pimages;
global PimagesRGB;
global Nimages;
global NimagesRGB;

file = dir(pdirectory);
NF = length(file);
dim=size(rgb2gray(imread(fullfile(pdirectory, file(3).name))));

Pimages = zeros(dim(1),dim(2),NF-2);
PimagesRGB = zeros(dim(1),dim(2),3,NF-2);
for k = 1 : NF-2
    Pimages(:,:,k) = rgb2gray(imread(fullfile(pdirectory, file(k+2).name)));
    PimagesRGB(:,:,:,k) = imread(fullfile(pdirectory, file(k+2).name));
end

file = dir(ndirectory);
NF = length(file);
dim=size(rgb2gray(imread(fullfile(ndirectory, file(3).name))));

Nimages = zeros(dim(1),dim(2),NF-2);
NimagesRGB = zeros(dim(1),dim(2),3,NF-2);
for k = 1 : NF-2
    Nimages(:,:,k) = rgb2gray(imread(fullfile(ndirectory, file(k+2).name)));
    NimagesRGB(:,:,:,k) = imread(fullfile(ndirectory, file(k+2).name));
end
end
