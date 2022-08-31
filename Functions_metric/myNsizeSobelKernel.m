% My N size Sobel filter
function [kernelX, kernelY] = myNsizeSobelKernel(N)
%% Main fun
% Parameter checking.
% if ~isempty(varargin) && strcmp(varargin(1), 'normalise')
%     fnorm = 1/8;
% else
%     fnorm = 1;
% end
fnorm = 1/8;
% The dafault 3x3 Sobel kernel.
s = fnorm * [1 2 1];
d = [1 0 -1];
% Convolve the default 3x3 kernel to the desired size.
for ii = 1:N-3
    s = fnorm * conv([1 2 1], s);
    d = conv([1 2 1], d);
end
% Output the kernel.
% sum(kernel,'all') = 0 and sum(sqrt(kernel.^2),'all') = 1 if normalized
kernelX = s'*d;
kernelY = kernelX';
end