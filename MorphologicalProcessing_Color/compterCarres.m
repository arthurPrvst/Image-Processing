function decompte = compterCarres(image)

%Attribue valeur à chaque aglomération
L = bwlabel(image);
%Détermine le nombre de forme
carre = max(L(:));
%crée une matrice de toute les formes
Q = zeros(carre,2);

%compte le nombre de pixel de chaque forme
for k=1:carre  
       
nb=sum(L==k);
Q(k,1)=k;
Q(k,2)=sum(nb);

end

Q;
P=Q;

%Donne la grosseur de chaque forme. (entier si carré et réel si autre
%forme)
for w=1:carre
        
value=P(w,2);    
P(w,2)=sqrt(value);

end

P;

%Crée une matrice ligne des 20 grosseurs recherchées
R=zeros(1,20,'uint32');

%Balayer le tableau pour compter le nombre de carré de même grosseur nous
%avons
for grosseur=1:20
    
Qtt=0;

    for x=1:carre
           
        if(P(x,2)==grosseur)
            
        Qtt=Qtt+1;
        
        end    
        
    R(1,grosseur)= Qtt;    
    
    end    
end

decompte = R;

end