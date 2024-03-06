function predictedFinal = processFrame(frame, r, c, awb, contrast, method, classsifier_AV, classifier_YCr)
    if strcmp(awb, "awb")
        if strcmp(contrast, "contrast")
            image = im2double(pre_processingComplete(frame, r, c));
        else
            image = im2double(pre_processing_only_AWB(frame, r, c));
        end
    else
        if strcmp(contrast, "contrast")
            image = im2double(pre_processing_only_contrast(frame, r, c));
        else
            image = im2double(pre_processing_basic(frame, r, c));
        end
    end
    
    % CONVERSIONE spazi colore
    imYCbCr = rgb2ycbcr(image);
    imLab = rgb2lab(image);
    imHSV = rgb2hsv(image);
    
    % RESHAPE dei vari canali
    pixsYCbCr = reshape(imYCbCr, r*c, 3);
    pixsLab = reshape(imLab, r*c, 3);  
    pixsHsv = reshape(imHSV, r*c, 3);
    
    % YCr
    Y = pixsYCbCr(:, 1);
    Cr = pixsYCbCr(:, 3);
    pixsYCr = cat(2, Y, Cr);

    % AV
    A = pixsLab(:, 2);
    V = pixsHsv(:, 3);
    pixsAV = cat(2, A, V);
    

    %%% OTSU
    % per i canali cb (YCbCr)
    cr = imYCbCr(:, :, 3);
    tcb = graythresh(cr);
    cr = imbinarize(cr, tcb);
    
    % a (Lab)
    a = imLab(:, :, 2);
    ta = graythresh(a);
    a = imbinarize(a, ta);

    % r (RGB)
    rr = image(:, :, 1);
    trr = graythresh(rr);
    rr = imbinarize(rr, trr);
    
    % Hard or soft
    if strcmp(method, "hard")
        otsu = cr & a;
    elseif strcmp(method, "crazy")
        otsu = cr & a & rr;
    else
        otsu = a;
    end

    % elimino regioni spurie
    otsuBw = bwareaopen(otsu, floor(max(r, c)), 4);
        
    %%% MULTI-CLASSIFICATORE
    % Bayesiano / Cart AV
    predicted_AV = predict(classsifier_AV, pixsAV);
    predicted_AV = reshape(predicted_AV, r, c) > 0;
    predicted_AV = bwareaopen(predicted_AV, floor(max(r, c)/5), 4);
    
    % Bayesiano YCr
    predicted_YCr = predict(classifier_YCr, pixsYCr);
    predicted_YCr  = reshape(predicted_YCr, r, c) > 0;
    predicted_YCr = bwareaopen(predicted_YCr, floor(max(r, c)/8), 8);
    
    % Ternaria
    predictedTernaria = (predicted_AV  + predicted_YCr) .* 0.5;
    predictedTernaria = reshape(predictedTernaria, r, c, 1);
    
    % Propagate
    if strcmp(method, "hard") || strcmp(method, "crazy")
        predictedFinal = propagateHard(predictedTernaria, otsuBw, r, c);
    else
        predictedFinal = propagateSoft(predictedTernaria, otsuBw, r, c);
    end
    
end