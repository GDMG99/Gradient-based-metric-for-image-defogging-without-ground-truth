% Compute the derivative of an image
function [Gx, Gy, G, Gdir] = computeImageDerivative(im, kernelX, kernelY, mask, normalize)
%%
%
%% Main fun
Gx = filter2(kernelX, im); % convolve in 2d
Gy = filter2(kernelY, im);
G = sqrt(Gy.^2 + Gx.^2); % Find magnitude
Gdir = atan2(Gy, Gx);
if normalize
    Gmin = min(G.*mask, [], 'all');
    dx = max(G.*mask, [], 'all') - Gmin; % find range
    G = (G.*mask-Gmin)/dx; % normalise from 0 to 1
end
end