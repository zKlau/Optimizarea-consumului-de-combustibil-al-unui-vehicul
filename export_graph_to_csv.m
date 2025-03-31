function export_graph_to_csv(G, coords, filename)
   
    
    node_table = table((1:numnodes(G))', coords(:,1), coords(:,2), ...
        'VariableNames', {'NodeID', 'Latitude', 'Longitude'});
    
    [s, t] = findedge(G);
    edge_table = table(s, t, G.Edges.Weight, ...
        'VariableNames', {'SourceNode', 'TargetNode', 'Distance_km'});
    
    [path, name, ~] = fileparts(filename);
    
    nodes_filename = fullfile(path, [name '_nodes.csv']);
    writetable(node_table, nodes_filename);
    fprintf('Saved node data to: %s\n', nodes_filename);
    
    edges_filename = fullfile(path, [name '_edges.csv']);
    writetable(edge_table, edges_filename);
    fprintf('Saved edge data to: %s\n', edges_filename);
end