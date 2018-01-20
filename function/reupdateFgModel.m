function re_model = reupdateFgModel(model,fgmodel,thrimg)

mus     = model{1};
sigmas  = model{2};
weights = model{3};

fgmus     = fgmodel{1};
fgsigmas  = fgmodel{2};
fgweights = fgmodel{3};

[row column byte] = size(mus);

index = thrimg == 255;

for i = 1:byte
    tempmus = mus(:,:,i);
    tempfgmus = fgmus(:,:,i);

    tempmus(index) = tempfgmus(index);

    mus(:,:,i) = tempmus;


    tempsigmas = sigmas(:,:,i);
    tempfgsigmas = fgsigmas(:,:,i);

    tempsigmas(index) = tempfgsigmas(index);

    sigmas(:,:,i) = tempsigmas;


    tempweights = weights(:,:,i);
    tempfgweights = fgweights(:,:,i);

    tempweights(index) = tempfgweights(index);

    weights(:,:,i) = tempweights;
end

re_model = {mus,sigmas,weights};

