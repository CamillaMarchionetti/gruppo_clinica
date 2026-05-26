function grafico_gruppi_ST(gruppo1, gruppo2, nome1, nome2, titolo)

    metriche = {'step_media', 'step_CV', 'AI'};
    ylabels = {'Media Step Time (s)', 'CV (%)', 'Indice di asimmetria (%)'};
    
    t = tiledlayout(1, 3, 'TileSpacing', 'compact', 'Padding', 'loose');

    for i = 1:length(metriche)
        nexttile;
        data1 = gruppo1.(metriche{i});
        data2 = gruppo2.(metriche{i});
        
        dati = [data1; data2];
        gruppi_totali = [repmat({nome1}, length(data1), 1); repmat({nome2}, length(data2), 1)];
        gruppi_totali = categorical(gruppi_totali); 
        
        b = boxchart(gruppi_totali, dati, 'MarkerStyle', 'none'); 
        b.BoxFaceColor = [0.7 0.7 0.7];
        b.BoxFaceAlpha = 0.3;
        hold on;
        x1 = ones(length(data1),1) + (rand(length(data1),1)-0.5)*0.2;
        x2 = 2*ones(length(data2),1) + (rand(length(data2),1)-0.5)*0.2;
        scatter(x1, data1, 35, 'r', 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'w');
        scatter(x2, data2, 35, 'b', 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeColor', 'w');

        ylabel(ylabels{i}, 'FontSize', 11);
        title(ylabels{i}, 'FontSize', 12, 'FontWeight', 'bold');
        grid on; 
        set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.5);
        box on;
        set(gca, 'TickDir', 'out'); 
    end
    title(t, titolo, 'FontSize', 15, 'FontWeight', 'bold');
end
