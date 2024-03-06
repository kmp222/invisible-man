function propagated_mask = propagateHard(predictedTernaria, otsuBin, r, c)
    % Estraggo come "layer" dalla maschera ternaria i valori grigi.
    grey = (predictedTernaria == 0.5);
    grey = grey(:);
    tmpTernaria = predictedTernaria(:);
    tmpOtsu = otsuBin(:);
    
    for k = 1:length(tmpTernaria)
         if tmpOtsu(k) == 0 % hard decision
             tmpTernaria(k) = 0;
         else
            if(tmpTernaria(k) ~=1  && tmpOtsu(k) == 1 && grey(k) == 1)
            tmpTernaria(k) = 1;
            end
         end
    end
        propagated_mask = reshape(tmpTernaria, r,c);
        propagated_mask = (propagated_mask == 1);
        propagated_mask = imclose(propagated_mask, strel("disk", 11));
end