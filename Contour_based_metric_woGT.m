% Contour-based metric for image defogging without ground truth
clear
clc
addpath(genpath("Functions_metric"))
addpath(genpath("Demo_Dataset\GT\"))
addpath(genpath("Demo_Dataset\Hazy\"))

Hazy_path = "45_outdoor_hazy.jpg"; %Path to Hazy image
Defogged_path = "45_outdoor_GT.jpg"; %Path to Defogged image

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
xlabel("Relative difference")
ylabel("R")
hold off
subplot(2,2,4)
imshow(result)