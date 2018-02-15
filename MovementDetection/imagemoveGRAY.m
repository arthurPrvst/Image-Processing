%main function to call
%define gloabal paramater and define them
%call subfunction for analysis
function answer=imagemoveGRAY()
answer=0;
global Pimages;
global PimagesRGB;
global Nimages;
global NimagesRGB;
%INITIALISATION
actualfold=pwd;
posfold=strcat(actualfold,'\positive\');
negfold=strcat(actualfold,'\negative\');
readpic(posfold,negfold);

    if 0
        posimage=Nimages;
        ii=7;
        jj=23;
    else
        posimage=Pimages;
        ii=4;
        jj=8;
    end

negBG=negBackground();

%***TESTING 1
set(0,'DefaultFigureVisible','on');
figure(1)

for w=0:4
    if 1
        y=1+4*w;
        NF=4;
        for i=1:NF
            
            res= imanalaser(negBG,posimage(:,:,y));
            subplot(2,NF,i),imshow(uint8(posimage(:,:,y)));
            subplot(2,NF,i+NF),imshow(res);
            y=y+1;
        end
        
    end
pause(7);    
end

end

%image analyser
% first with max and min 
% second with a minimal cluster size 
function output=imanalaser(Background,ima)
res=zeros(size(Background(:,:,1)));
res=Background(:,:,1)>=ima & Background(:,:,2)<=ima;
res=bwareaopen(1-res,120);

output=res;
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

%define Background template of all the negative image
%local [3,3] max min +/- 5
%return mat of 1=max and 2=min
function output=negBackground()
global Nimages
negimage=Nimages;
dim=size(negimage(:,:,1));
negBackground=zeros(dim(1),dim(2),2);

negBackground(:,:,1)=max(negimage,[],3)+5;
negBackground(:,:,2)=min(negimage,[],3)-5;

negBackground(:,:,1)=ordfilt2(negBackground(:,:,1),9,ones(3),'symmetric');
negBackground(:,:,2)=ordfilt2(negBackground(:,:,2),1,ones(3),'symmetric');


%negBackground(:,:,1)=mean(negimage,3);
%negBackground(:,:,2)=std(negimage,0,3)+15; % minimum std of 10 define arbitrary

output=negBackground;

%subplot(2,1,1),imshow(uint8(negBackground(:,:,1))),title('negBackground');
%subplot(2,1,2),imshow(uint8(negimage(:,:,1))),title('negimage');
end
