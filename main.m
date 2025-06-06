% Load node data
nodes = readtable('data_nodes.csv');
node_ids = nodes.NodeID;
latitudes = nodes.Latitude;
longitudes = nodes.Longitude;

angle = 0;

center_lat = mean(latitudes);
center_lon = mean(longitudes);

rotated_latitudes = cos(angle) * (latitudes - center_lat) - sin(angle) * (longitudes - center_lon) + center_lat;
rotated_longitudes = sin(angle) * (latitudes - center_lat) + cos(angle) * (longitudes - center_lon) + center_lon;

% Load edge data
edges = readtable('data_edges.csv');
source_nodes = edges.SourceNode;
target_nodes = edges.TargetNode;
distances = edges.Distance_km;

% Create adjacency list
graph_matrix = containers.Map('KeyType', 'int32', 'ValueType', 'any');
for i = 1:height(edges)
    if isKey(graph_matrix, source_nodes(i))
        graph_matrix(source_nodes(i)) = [graph_matrix(source_nodes(i)); target_nodes(i), distances(i)];
    else
        graph_matrix(source_nodes(i)) = [target_nodes(i), distances(i)];
    end
    
    if isKey(graph_matrix, target_nodes(i))
        graph_matrix(target_nodes(i)) = [graph_matrix(target_nodes(i)); source_nodes(i), distances(i)];
    else
        graph_matrix(target_nodes(i)) = [source_nodes(i), distances(i)];
    end
end

% Create a figure with a map
fig = figure;
geoaxes;
hold on;
title('Graph');

% Plot the nodes
scatter(rotated_longitudes, rotated_latitudes, 50, 'b', 'filled');

% Plot the edges
for i = 1:height(edges)
    src_idx = find(node_ids == source_nodes(i));
    tgt_idx = find(node_ids == target_nodes(i));
    
    if ~isempty(src_idx) && ~isempty(tgt_idx)
        plot([rotated_longitudes(src_idx), rotated_longitudes(tgt_idx)], [rotated_latitudes(src_idx), rotated_latitudes(tgt_idx)], 'k-');
    end
end

disp('Click on two nodes: Start and End');
%[selected_x, selected_y] = ginput(2);

% Find the closest nodes to the clicked points
%[~, start_idx] = min(vecnorm([rotated_longitudes - selected_x(1), rotated_latitudes - selected_y(1)]'));
%[~, goal_idx] = min(vecnorm([rotated_longitudes - selected_x(2), rotated_latitudes - selected_y(2)]'));

start_id = node_ids(100); % 1, 100
goal_id = node_ids(56); % 56, 169

tic;
pathAstar = astar(start_id, goal_id, graph_matrix, rotated_latitudes, rotated_longitudes, node_ids);
disp("A* ")
toc;

disp(" ")

tic;
pathDijkstra = dijkstra(start_id, goal_id, graph_matrix, node_ids);
disp("Dijkstra")
toc;



for i = 1:length(pathAstar)-1
    src_idx = find(node_ids == pathAstar(i));
    tgt_idx = find(node_ids == pathAstar(i+1));
    plot([rotated_longitudes(src_idx), rotated_longitudes(tgt_idx)], [rotated_latitudes(src_idx), rotated_latitudes(tgt_idx)], 'r-', 'LineWidth', 2);
end
for i = 1:length(pathDijkstra)-1
    src_idx = find(node_ids == pathDijkstra(i));
    tgt_idx = find(node_ids == pathDijkstra(i+1));
    plot([rotated_longitudes(src_idx), rotated_longitudes(tgt_idx)], [rotated_latitudes(src_idx), rotated_latitudes(tgt_idx)], 'm-', 'LineWidth',4);
end
hold off;
