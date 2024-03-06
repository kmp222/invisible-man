clear;
close all;
load("classifier_arcobaleno.mat");

% Recuperare il nome del VideoAdaptor del proprio sistema
ainfo = imaqhwinfo;

% Cambiare VideoAdaptorName
vid = videoinput("winvideo");
vid = videoinput("winvideo");
set(vid, 'FramesPerTrigger', Inf);
    set(vid, 'ReturnedColorspace', 'rgb');
    vid.FrameGrabInterval = 5; % distance between captured frames 
    start(vid);

frame = getsnapshot(vid);
background = getsnapshot(vid);

% resize background
[r, c, ch] = size(background);
r = floor(r/2);
c = floor(c/2);
background = imresize(background, [r, c]);

v = VideoWriter("test\stream.avi", "Motion JPEG AVI");
v.FrameRate = 5;
open(v);


while vid.FramesAcquired <= 150
    frame = getsnapshot(vid);
    frame = imresize(frame, [r, c]);
    
    % Chiamare la funzione per processare il frame
    predictedFinal = processFrame(frame, r, c, "awb", "contrast", "hard", bayes_AV, bayes_YCr);
    
    % process background
    final = process_background(frame, background, predictedFinal, ch);

    imshow(final); 
    writeVideo(v, mat2gray(final));
end

delete(vid);
close(v);