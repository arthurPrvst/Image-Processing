function [ MSE ] = evaluerSolutionQ4( imageFiltree )
%EVALUERSOLUTION Cette fonction prend en param�tre l'image lena.jpg
%filtr�e, puis affiche et retourne l'erreur quadratique moyenne 
%(Mean square error, ou MSE). Le MSE est une m�trique permettant de
%quantifi� l'erreur par rapport � une solution optimale.

% Exemple:
% f = imread('lena.jpg');
% h = ones(3) ./ 9;
% g = imfilter(f,h,'symmetric');
% erreur = evaluerSolutionQ4( g );

    if max(imageFiltree(:)) <= 1
        imageFiltree = uint8(imageFiltree *255);
    end
    
    load('solutionLena.mat');

    if(numel(imageFiltree) ~= numel(solution))
        error('La taille de l''image ne doit pas avoir chang�e!');
    end

    MSE = sum(sum((double(imageFiltree(:)) - double(solution(:))) .^2))/numel(imageFiltree);

    display(['Cette solution pour lena.jpg a une erreur quadratique moyenne de ' num2str(MSE)]);

end
