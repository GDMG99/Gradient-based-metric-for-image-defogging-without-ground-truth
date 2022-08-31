function mask = borders(shape)
mask = ones(shape(1),shape(2));
mask(1,:)=0;
mask(end,:)=0;
mask(:,1)=0;
mask(:,end)=0;
end