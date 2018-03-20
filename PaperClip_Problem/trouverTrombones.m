%programme pas comtinuer
% raison: modif rendre les threshold inutile
% unique changement dans : find_color(hsvXbin,BinImage)
% testage de: compare_V_vs_BG(BW,HSVImage)


%rouge, jaune, vert, bleu, mauve, rose et fuck Blanc-> saturation =0
% return x,y,z
%possibility to add w for hue value of S value 
%(determineted by the level of white)
function [x,y,z]=trouverTrombones(images)
%all the same image
RGBImage = images;
GrayImage=rgb2gray(RGBImage);
%HSVImage=rgb2hsv(decorrstretch(RGBImage));
HSVImage=rgb2hsv(RGBImage);
BinImage=remplirtrbn(GrayImage);

hsvXbin=HSVImage.*double(BinImage>0);

%subplot(2,2,1),imshow(BinImage);
%subplot(2,2,2),imshow(hsv2rgb(hsvXbin));
%subplot(2,2,4),imshow(rbgXbin);%histogram(RGBImage(BinImage));
[x,y,z,w]=find_color(hsvXbin,BinImage);
end

function fulltrbn = remplirtrbn(Grayimage)

B = imgaussfilt(Grayimage,8);

SE = strel('disk',16);
BW1 = imbothat(B,SE);
BW2=bwareaopen(BW1,10000);
BW3=add_border(BW2);
BW4=imclearborder(BW3);
SE = strel('disk',1);
BW5=imclose(BW4,SE);

fulltrbn=bwlabel(BW5);

end

function [out_x,out_y,out_z,out_w]=find_color(hsvXbin,BinImage)

BinImage_end=BinImage;
nb_area=max(BinImage_end(:));
%create output with enoug buffer a tthe end
%color or in cell because string...
x=zeros(nb_area+5,1);
y=zeros(nb_area+5,1);
z=cell(nb_area+5,1);
w=zeros(nb_area+5,1);


area=0;
while area~=nb_area
    area=area+1;
    %isolate a area
    hsvXarea=hsvXbin.*(BinImage_end==area);
    %check for white
    whiteTH=0.2;
    hsvXarea_W=hsvXarea(:,:,1).*(hsvXarea(:,:,2)<whiteTH);
    
    %%%%%%WHITE PART%%%%%%%%%%
    %%%%%displaying
    %subplot(2,2,3);
    %Hist_W=histogram(nonzeros(hsvXarea_W(:,:,1)),'BinWidth',10/360);
    %Histdata_W=Hist_W.Values;
    %%%%not displaying
    Hist_W=histcounts(nonzeros(hsvXarea_W(:,:,1)),'BinWidth',10/360);
    Histdata_W=Hist_W;
    %because it's on 360 degree the 0 and 360 have an impact on each other
    
    Histdata_W=horzcat(Histdata_W(length(Histdata_W)),Histdata_W,Histdata_W(1));
    %bar(Histdata_W);
    [pks_W,locs_W]=findpeaks(Histdata_W);
    
    %eliminate low saturation
    hsvXarea_NoW=hsvXarea(:,:,1).*(hsvXarea(:,:,2)>whiteTH);
    
    %%%%%%COLOR PART%%%%%%%%%%
    %rouge, jaune, vert, bleu, mauve, rose
    %subplot(2,2,2),imshow(hsv2rgb(hsvXarea));
    %histogram of color without white
    %subplot(2,2,4);
    %%%%%displaying
    %Hist_col=histogram(nonzeros(hsvXarea_NoW(:,:,1)),'BinWidth',10/360);
    %Histdata_col=Hist_col.Values;
    Hist_col=histcounts(nonzeros(hsvXarea_NoW(:,:,1)),'BinWidth',10/360);
    
    %because it's on 360 degree the 0 and 360 have an impact on each other
    Histdata_col=Hist_col;
    Histdata_col=horzcat(Histdata_col(length(Histdata_col)),Histdata_col,Histdata_col(1));
    %bar(Histdata_col);
    [pks_col,locs_col]=findpeaks(Histdata_col);
    
    %threshold
    color_noise_TH=0.8*10^4;
    moreOF2=5*10^4; %average for 1 paperclip of color %%%%%% doesn't work
    
    %confirm that if any white in noise with Hist_W
    white_noise_TH=1*10^4;
    filt_W=double(white_noise_TH<pks_W);
    nb_whites=sum(filt_W)>0;
    locs_filtered_W=filt_W.*locs_W;
    pks_filtered_W=filt_W.*pks_W;
    %number of unique PC
    filt1=double(color_noise_TH<pks_col & pks_col<=moreOF2);
    nb_ones=sum(filt1);
    pks_filtered_Color=filt1.*pks_col;
    locs_filtered_Color=filt1.*locs_col;
    
    %number of multipl (of same color) PC
    filt2=uint8(moreOF2<pks_col); %filter
    nb_twos=sum(filt2);
    %total paperclip
    nbPCS=nb_whites+nb_ones+2*nb_twos;
    %sub divide paperclips
    if nbPCS>1
        splitted_area=K_means_pos_clustering(hsvXarea,nbPCS,area,nb_area);
        BinImage_end=(BinImage_end~=area).*BinImage_end+splitted_area;
        %pass again on the same area
        area=area-1;
        %change the max value area
        nb_area=max(BinImage_end(:));
        %add a row to the answer
    else
        %output_color_hist=color_code(locs_filtered_Color,locs_filtered_W);
        % not regionprop because multiple area create multiple region
        % sometime...
        
        Re=Kmeans_centroids(BinImage_end==area);
        hue_val_center=K_means_cluster_center((BinImage_end==area).*hsvXarea);
            
        if Re
            output_color=color_code(hue_val_center,locs_filtered_W);
            x(area)=mean(Re(1));
            y(area)=mean(Re(2));
            z(area)={output_color};
            if strcmp(output_color,'blanc')
                w(area)=sum(pks_filtered_W);
            else
                w(area)=hue_val_center;
            end
        end
        
    end
end
maxrow=find(x,1,'last');

out_x=x(1:maxrow);
out_y=y(1:maxrow);
out_z=z(1:maxrow);
out_w=w(1:maxrow);
%figure(2),imshow(BinImage_end,[0,max(BinImage_end(:))]);
end

%color code
%locs_filtered=localisation filtered (only the good unique value) to 15
function output_color=color_code(locs_filtered,locs_filtered_W)
l=sum(locs_filtered);

%rouge, jaune, vert, bleu, mauve, rose et fuck Blanc-> saturation =0
if sum(locs_filtered_W)>0
    output_color='blanc';
elseif 0<l && l<=3
    %rouge
    output_color='rouge';
elseif 3<l && l<=7
    %jaune
    output_color='jaune';
elseif 7<l && l<=21
    %vert
    output_color='vert';
elseif 21<l && l<=26
    %bleu
    output_color='bleu';
elseif 26<l && l<=33
    %mauve
    output_color='mauve';
elseif 33<l && l<=36
    %%rose
    output_color='rose';
elseif 36<l
    %rouge 2
    output_color='rouge';
else
    output_color='error';
end

end
%define the color center of one cluster of color
function hue_val=K_means_cluster_center(area_hsv)
area_rgb=hsv2rgb(area_hsv);
area_lab=rgb2lab(area_rgb);

ab = double(area_lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,1,'distance','sqEuclidean','Replicates',1);
rgb_center=lab2rgb([50,cluster_center(1),cluster_center(2)]);
hsv_center=rgb2hsv(rgb_center);
hue_val=hsv_center(1)*36; % temporary conversion for color_code
end
%define the center of a position of one cluster
function output_centroid=Kmeans_centroids(BinImage_end_area)

[abx,aby] = find(BinImage_end_area);
ab=horzcat(abx,aby);

if length(ab)>1
    % repeat the clustering 3 times to avoid local minima
    [cluster_idx, cluster_center] = kmeans(ab,1,'distance','sqEuclidean','Replicates',3);
    output_centroid=cluster_center;
else
    output_centroid=FALSE;
end

end
%define multiple PC by the position and the color 3D map (x,y,color)
function output_area=K_means_pos_clustering(area_hsv,nb_cluster,area,nb_area)
area_rgb=hsv2rgb(area_hsv);
area_lab=rgb2lab(area_rgb);

[abx,aby] = find(area_hsv(:,:,1));
abc=reshape(nonzeros(area_hsv(:,:,1)),[],1);
ab=horzcat(abx,aby,(abc+10).^7);
nrows = size(ab,1);
ncols = size(ab,2);


% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nb_cluster,'distance','sqeuclidean','Replicates',3);


ab=horzcat(ab,cluster_idx);
[picrow,piccol]=size(area_hsv(:,:,1));
split_area=zeros(picrow,piccol);

for i=1:nrows
    split_area(ab(i,1),ab(i,2))=ab(i,4);
end

for k=2:nb_cluster
    split_area=(split_area~=k).*split_area+((split_area==k).*(k-1+nb_area));
end

split_area=(split_area==1).*area+(split_area~=1).*split_area;




output_area=split_area;

%subplot(2,2,2),imshow(split_area), title('objects in cluster 1');
%subplot(2,2,3),imshow(split_area==1), title('objects in cluster 1');
%subplot(2,2,4),imshow(split_area==2), title('objects in cluster 1');

%subplot(2,2,1),imshow(segmented_images{4}), title('objects in cluster 4');
end
%add a border to eliminate near by object (advande clearborder)
function output_BW=add_border(BW)
Border_size=10;
[x,y]=size(BW);
BW(1:Border_size,:)=1;
BW(x-Border_size:x,:)=1;
BW(:,1:Border_size)=1;
BW(:,y-Border_size:y)=1;

output_BW=BW;
end