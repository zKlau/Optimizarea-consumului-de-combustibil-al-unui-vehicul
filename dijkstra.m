
% Function for Dijkstra's algorithm
function path = dijkstra(start_id, goal_id, graph_matrix, node_ids)
    dist = containers.Map('KeyType', 'int32', 'ValueType', 'double');
    prev = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    
    for i = 1:length(node_ids)
        dist(node_ids(i)) = inf;
    end
    dist(start_id) = 0;
    
    Q = node_ids;
    
    while ~isempty(Q)
        [~, idx] = min(cell2mat(values(dist, num2cell(Q))));
        u = Q(idx);
        Q(idx) = [];
        
        if u == goal_id
            path = [u];
            while isKey(prev, u)
                u = prev(u);
                path = [u, path];
            end
            return;
        end
        
        if isKey(graph_matrix, u)
            neighbors = graph_matrix(u);
            for j = 1:size(neighbors, 1)
                v = neighbors(j, 1);
                alt = dist(u) + neighbors(j, 2);
                
                if alt < dist(v)
                    dist(v) = alt;
                    prev(v) = u;
                end
            end
        end
    end
    path = [];
end
