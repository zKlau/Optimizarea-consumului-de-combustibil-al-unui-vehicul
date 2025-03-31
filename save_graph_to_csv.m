function save_graph_to_csv(G, coords, filename)
    % SAVE_GRAPH_TO_CSV Saves the graph structure into a CSV file
    % Each row will contain: node_id, latitude, longitude, connected_nodes
    % 
    % G: Graph object
    % coords: Nx2 matrix containing [latitude, longitude] of each node
    % filename: Output CSV file name
    
    % Open file for writing
    fid = fopen(filename, 'w');
    if fid == -1
        error('Cannot open file %s for writing.', filename);
    end
    
    % Write header
    fprintf(fid, 'node_id,latitude,longitude,connected_nodes\n');
    
    % Iterate over each node
    for i = 1:numnodes(G)
        % Get connected nodes
        neighbors = neighbors(G, i); 
        neighbor_str = strjoin(string(neighbors), ' '); % Convert to space-separated string
        
        % Write data
        fprintf(fid, '%d,%.6f,%.6f,%s\n', i, coords(i,1), coords(i,2), neighbor_str);
    end
    
    % Close file
    fclose(fid);
    fprintf('Graph saved successfully to %s\n', filename);
end
