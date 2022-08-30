% Contour-based metric for image defogging without ground truth
clear
clc

Hazy_path = "D:\Documentos\4_TFM_GANS\0_Datasets\# I-HAZY NTIRE 2018\hazy\01_indoor_hazy.jpg"; %Path to Hazy image
Defogged_path = "D:\Documentos\4_TFM_GANS\0_Datasets\# I-HAZY NTIRE 2018\GT\01_indoor_GT.jpg"; %Path to Defogged image

Hazy = imread(Hazy_path);
Defogged = imread(Defogged_path);

[kernelX, kernelY] = myNsizeSobelKernel(3); % Generates Sobel Kernel with dimensions (3x3) 
eps = 0.05; % The threshold may vary between 0.05 and 0.08. Changing the threshold any higher or lower may deviate the result.

Hazy_gray = rgb2gray(Hazy); %Before computing the derivative we obtain the gray image of the scene
Defogged_gray =rgb2gray(Defogged);

% We obtain the derivatives of both images
[~,~,Hazy_edges,~] = computeImageDerivative(Hazy_gray, kernelX, kernelY, 1,  true);
[~,~,Defogged_edges,~] = computeImageDerivative(Defogged_gray, kernelX, kernelY, 1,  true);

%We compute the Relative Difference matrix
RD = (Defogged_edges-Hazy_edges)./Hazy_edges.*(Hazy_edges>eps).*(Defogged_edges>eps);

% Differential operators usually struggle with image borders. We perform a
% mask eliminating the first pixel of every border to avoid trouble.
border = borders(size(Hazy_gray));
% Compute an image for the RD matrix
result = overlap(Hazy_edges,Defogged_edges,border);

width = 0.1;
[h, bin] = histcounts(RD(RD~=0),'BinWidth',width);

% Perform the Ratio
R = metric(h,bin);


figure(1)
subplot(2,2,1)
imshow(Hazy)
title("Hazy")
subplot(2,2,2)
imshow(Defogged)
title("Defogged")
subplot(2,2,3)
histogram(RD(RD>0),'BinWidth',0.5,'FaceColor','green')
hold on
histogram(RD(RD<0),'BinWidth',0.5,'FaceColor','red')
title(sprintf('R = %0.4f',R))
hold off
subplot(2,2,4)
imshow(result)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

function result = overlap(edgeshazy, edgesgan,border)
    eps = 0.05;
    mask = (edgeshazy>edgesgan).*(edgesgan>eps).*(edgeshazy>eps);
    shape = size(edgeshazy);
    result = zeros(shape(1),shape(2),3);
    result(:,:,3) = ones(shape(1),shape(2)).*(edgesgan<eps).*(edgeshazy<eps);
    result(:,:,1) = ones(shape(1),shape(2)).*(edgeshazy<eps).*(edgesgan<eps)+edgeshazy.*mask.*border;
    result(:,:,2) = ones(shape(1),shape(2)).*(edgeshazy<eps).*(edgesgan<eps)+ edgesgan.*(1-mask).*border;
end

function v = interpole(vector)
v = [];
for i = [1:length(vector)-1]
    v =[v,(vector(i)+vector(i+1))/2];
end
end

function ratio = metric(histo, bins)
sum_posi = sum(histo(interpole(bins)>0).*bins(interpole(bins)>0));
sum_neg = sum(histo(interpole(bins)<0).*abs(bins(interpole(bins)<0)));
ratio = (sum_posi-sum_neg)/(sum_posi+sum_neg);
end
function mask = borders(shape)
mask = ones(shape(1),shape(2));
mask(1,:)=0;
mask(end,:)=0;
mask(:,1)=0;
mask(:,end)=0;
end