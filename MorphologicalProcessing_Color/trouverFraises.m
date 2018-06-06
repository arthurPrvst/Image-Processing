function [fraises, vert] = trouverFraises(imageFraises)
global R G B;
R=imageFraises(:,:,1);
G=imageFraises(:,:,2);
B=imageFraises(:,:,3);

red=redisolator();
green=greenisolator();
greenHSV=HSVgreenisolator(imageFraises);

subplot(1,2,1),imshow(green);
subplot(1,2,2),imshow(greenHSV);
%subplot(1,3,3),imshow(green);

fraises=1;%red;
vert=1;%green;
end
%function who find the red color
function red=redisolator()
global R G B;

dR=double(R);
dG=double(G);
dB=double(B);
%red Threshold
redTH=0.47;
blueTH=redTH;
% the blue filter doesnt actually have a impact....
red= redTH>dG./dR & blueTH>dB./dR & dR > 100;

end
%function who find the "green" ish color include yellow ish color
function green=greenisolator()
global R G B;

dR=double(R);
dG=double(G);
dB=double(B);

%valeur avec lesquel jouer 
reddif=30;
blueTH=0.6;

green= blueTH>dB./dG & reddif>abs(dG-dR) & dG > 100;
%green=bwareaopen(green,20);
end
%function who find the "green" ish color include yellow ish color in HSV
%format
function green=HSVgreenisolator(ima)
hsvima=rgb2hsv(ima);
hue=hsvima(:,:,1);
sat=hsvima(:,:,2);

%valeur avec lesquel jouer 
hueLo=40/360;
hueHi=128/360;
satHi=100/256;

green= hueLo<hue & hue<hueHi & sat>satHi;
%green=bwareaopen(green,30);
end