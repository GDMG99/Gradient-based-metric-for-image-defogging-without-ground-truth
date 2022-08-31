function result = overlap(edgeshazy, edgesgan,border)
    eps = 0.05;
    mask = (edgeshazy>edgesgan).*(edgesgan>eps).*(edgeshazy>eps);
    shape = size(edgeshazy);
    result = zeros(shape(1),shape(2),3);
    result(:,:,3) = ones(shape(1),shape(2)).*(edgesgan<eps).*(edgeshazy<eps);
    result(:,:,1) = ones(shape(1),shape(2)).*(edgeshazy<eps).*(edgesgan<eps)+edgeshazy.*mask.*border;
    result(:,:,2) = ones(shape(1),shape(2)).*(edgeshazy<eps).*(edgesgan<eps)+ edgesgan.*(1-mask).*border;
end