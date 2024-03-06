function Sigma=estimate_noise(I, r, c)

    I = double(I);
    % compute sum of absolute values of Laplacian
    M = [1 -2 1; -2 4 -2; 1 -2 1];
    Sigma = sum(sum(abs(conv2(I, M))));
    
    % scale sigma with proposed coefficients
    Sigma = Sigma * sqrt(0.5*pi)./(6*(c-2)*(r-2));

end