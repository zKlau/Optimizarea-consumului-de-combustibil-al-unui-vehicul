function graph_map(csv_filename, percentage)
    
    data = readtable(csv_filename);
    coords = [data.latitude, data.longitude];
    valid_idx = all(~isnan(coords), 2);
    coords = coords(valid_idx, :);
    n_total = size(coords, 1);
    
    n_selected = max(2, round(n_total * percentage/100));
    fprintf('Selecting %d/%d points (%.1f%%)\n', n_selected, n_total, percentage);
    
    rand_indices = randperm(n_total, n_selected);
    rand_coords = coords(rand_indices, :);

    k = min(5, n_selected-1); 
    [idx, ~] = knnsearch(rand_coords, rand_coords, 'K', k+1); 
    

    adj_matrix = false(n_selected);
    for i = 1:n_selected
        adj_matrix(i, idx(i,2:end)) = true; 
    end

    adj_matrix = adj_matrix | adj_matrix';

    G = graph(adj_matrix, 'omitselfloops');

    [s, t] = findedge(G);
    weights = zeros(numedges(G), 1);
    for i = 1:numedges(G)
        weights(i) = haversine_dist(rand_coords(s(i),:), rand_coords(t(i),:));
    end
    G.Edges.Weight = weights;

    [bin, binsize] = conncomp(G);
    if numel(unique(bin)) > 1
        fprintf('Merging %d disconnected components...\n', numel(unique(bin)));
        components = arrayfun(@(x) find(bin == x), unique(bin), 'UniformOutput', false);

        for comp = 2:length(components)
            [point1, point2, min_dist] = find_closest_pair(rand_coords, components{1}, components{comp});
            G = addedge(G, point1, point2, min_dist);
        end
    end


    export_graph_to_csv(G, rand_coords, 'my_graph_data.csv');
    
    
    
    
    save_graph_to_csv(G,coords,"graph.csv")
end

function [point1, point2, min_dist] = find_closest_pair(coords, group1, group2)
    min_dist = Inf;
    point1 = 1;
    point2 = 1;
    
    for i = 1:length(group1)
        for j = 1:length(group2)
            dist = haversine_dist(coords(group1(i),:), coords(group2(j),:));
            if dist < min_dist
                min_dist = dist;
                point1 = group1(i);
                point2 = group2(j);
            end
        end
    end

    
end

function d = haversine_dist(latlon1, latlon2)
    R = 6371; 
    lat1 = deg2rad(latlon1(1));
    lon1 = deg2rad(latlon1(2));
    lat2 = deg2rad(latlon2(1));
    lon2 = deg2rad(latlon2(2));
    
    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    
    a = sin(dlat/2)^2 + cos(lat1)*cos(lat2)*sin(dlon/2)^2;
    d = R * 2 * atan2(sqrt(a), sqrt(1-a));
end