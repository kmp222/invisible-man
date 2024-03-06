function final = process_background(frame, background, predictedFinal, ch)
    skinMask = double(repmat(predictedFinal,[1,1,3]));
    skinBackground = im2double(background).*skinMask;
  
    maskInv = 1 - predictedFinal;
    mask3_Inv = double(repmat(maskInv, [1, 1, ch]));
    noSkin = im2double(frame).*mask3_Inv;
  
    final = skinBackground + noSkin;

end
