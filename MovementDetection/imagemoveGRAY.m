%main function to call
%define gloabal paramater and define them
%call subfunction for analysis
function output=imagemoveGRAYF(imageIN)
%creation of the back ground
BGin=load('info.mat','negBG');
negBG=BGin.negBG;

%analysis of the picture with the reference
res= imanalaser(negBG,imageIN);

output=max(max(res));
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
