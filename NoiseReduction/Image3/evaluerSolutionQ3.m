function [ MSE ] = evaluerSolutionQ3( imageFiltree )
%EVALUERSOLUTION Cette fonction prend en paramètre l'image ourspolaires.jpg
%filtrée, puis affiche et retourne l'erreur quadratique moyenne 
%(Mean square error, ou MSE). Le MSE est une métrique permettant de
%quantifié l'erreur par rapport à une solution optimale.

% Exemple:
% f = imread('ourspolaires.jpg');
% h = ones(3) ./ 9;
% g = imfilter(f,h,'symmetric');
% erreur = evaluerSolutionQ3( g );

    if max(imageFiltree(:)) <= 1
        imageFiltree = uint8(imageFiltree *255);
    end
    
    load('solutionOurspolaires.mat');

    if(numel(imageFiltree) ~= numel(solution))
        error('La taille de l''image ne doit pas avoir changée!');
    end

    MSE = sum(sum((double(imageFiltree(:)) - double(solution(:))) .^2))/numel(imageFiltree);

    display(['Cette solution pour ourspolaires.jpg a une erreur quadratique moyenne de ' num2str(MSE)]);

end
