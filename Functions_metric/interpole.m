function v = interpole(vector)
v = [];
for i = [1:length(vector)-1]
    v =[v,(vector(i)+vector(i+1))/2];
end
end