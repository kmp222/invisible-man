clear;
close all;
load("classifier_arcobaleno.mat");

% vid = VideoReader("...\test.mp4");

frame = read(vid, 1);
background = read(vid, 1);

% resize background
[r, c, ch] = size(background);
r = floor(r/2);
c = floor(c/2);
background = imresize(background, [r, c]);

v = VideoWriter("test\video.avi", "Motion JPEG AVI");
v.FrameRate = 8;
open(v);

while hasFrame(vid)
    frame = readFrame(vid);    
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