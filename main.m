
data = readtable('rom.csv');

numTotal = height(data);
numSample = round(0.05 * numTotal);  % 5% 
idx = randperm(numTotal, numSample);  


cities = data.cityname(idx);
lat = data.latitude(idx);
lon = data.longitude(idx);


numCities = length(lat);
k = 3; 
edges = [];


distMatrix = pdist2([lat, lon], [lat, lon]); 
for i = 1:numCities
    [~, idxSort] = sort(distMatrix(i, :)); % Sort by distance
    for j = 2:k+1
        edges = [edges; i, idxSort(j)];
    end
end


G = graph(edges(:,1), edges(:,2));

% Plot map with city connections
figure;
geobasemap streets;
hold on;


geoscatter(lat, lon, 20, 'r', 'filled');

for i = 1:size(edges,1)
    latPoints = [lat(edges(i,1)), lat(edges(i,2))];
    lonPoints = [lon(edges(i,1)), lon(edges(i,2))];
    geoplot(latPoints, lonPoints, 'b-', 'LineWidth', 1);
end


title('Proiect');
hold off;
