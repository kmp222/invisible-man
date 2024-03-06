function finalFframe = pre_processing_basic(frame, r, c)
    noiseLevel = estimate_noise(rgb2gray(frame), r, c);

    if noiseLevel < 0.50 || max([r, c]) > 700
        finalFframe = frame;
    else 
        n = 5;
        if noiseLevel > 0.7 && noiseLevel < 1.1
            n = 7;
        elseif noiseLevel >= 1.1
            n = 9;
        end
        finalFframe = denoise_frame_wiener2_RGB(frame, n);
    end
end