
% Function for A* search
function path = astar(start_id, goal_id, graph_matrix, latitudes, longitudes, node_ids)
    heuristic = @(a, b) sqrt((latitudes(a) - latitudes(b))^2 + (longitudes(a) - longitudes(b))^2);
    
    open_list = [start_id];
    came_from = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    g_score = containers.Map('KeyType', 'int32', 'ValueType', 'double');
    f_score = containers.Map('KeyType', 'int32', 'ValueType', 'double');
    
    for i = 1:length(node_ids)
        g_score(node_ids(i)) = inf;
        f_score(node_ids(i)) = inf;
    end
    
    g_score(start_id) = 0;
    f_score(start_id) = heuristic(start_id, goal_id);
    
    while ~isempty(open_list)
        [~, idx] = min(cell2mat(values(f_score, num2cell(open_list))));
        current = open_list(idx);
        
        if current == goal_id
            path = [current];
            while isKey(came_from, current)
                current = came_from(current);
                path = [current, path];
            end
            return;
        end
        
        open_list(idx) = [];
        
        if isKey(graph_matrix, current)
            neighbors = graph_matrix(current);
            for j = 1:size(neighbors, 1)
                neighbor = neighbors(j, 1);
                tentative_g_score = g_score(current) + neighbors(j, 2);
                
                if tentative_g_score < g_score(neighbor)
                    came_from(neighbor) = current;
                    g_score(neighbor) = tentative_g_score;
                    f_score(neighbor) = g_score(neighbor) + heuristic(neighbor, goal_id);
                    
                    if ~ismember(neighbor, open_list)
                        open_list = [open_list, neighbor];
                    end
                end
            end
        end
    end
    
    path = [];
end
