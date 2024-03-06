function finalFframe = pre_processingComplete(frame, r, c)
    noiseLevel = estimate_noise(rgb2gray(frame), r, c);

    if noiseLevel < 0.50 || max([r, c]) > 700
        awb = awb_frame_grayWorld(frame);
        finalFframe = imadjust_contrast(awb);
    else 
        n = 5;
        if noiseLevel > 0.7 && noiseLevel < 1.1
            n = 7;
        elseif noiseLevel >= 1.1
            n = 9;
        end
        denoise = denoise_frame_wiener2_RGB(frame, n);        
        awb = awb_frame_grayWorld(denoise);
        finalFframe = imadjust_contrast(awb); 
    end
end