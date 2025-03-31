% Exemplu de utilizare
graf = creareGraf();
nodStart = 1;
nodFinal = 5;

[traseuAStar, costTotalAStar] = aStar2(graf, nodStart, nodFinal);
[traseuDijkstra, costTotalDijkstra] = dijkstra2(graf, nodStart, nodFinal);

% Afisare rezultate
disp('Traseu optimizat A*:');
disp(traseuAStar);
disp(['Cost total optimizat A*: ', num2str(costTotalAStar)]);

disp('Traseu optimizat Dijkstra:');
disp(traseuDijkstra);
disp(['Cost total optimizat Dijkstra: ', num2str(costTotalDijkstra)]);