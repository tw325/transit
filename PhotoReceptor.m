function p=PhotoReceptor(pmax,n,l50,int)
%%
p = -pmax*(power(int,n)./(l50+power(int,n)));
