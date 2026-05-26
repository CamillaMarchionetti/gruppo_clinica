function test_statistico_ST(gruppo1, gruppo2)

    metriche = {'step_media', 'step_CV', 'AI'};

    for i = 1:length(metriche)
        x1 = gruppo1.(metriche{i});
        x2 = gruppo2.(metriche{i});

        p = mannwhitney_u(x1, x2);

        if p < 0.001, sig = '***';
        elseif p < 0.01, sig = '**';
        elseif p < 0.05, sig = '*';
        else, sig = 'n.s.';
        end
    end
    fprintf('%s\n', repmat('=',1,62));
    fprintf('* p<0.05  ** p<0.01  *** p<0.001  n.s. = non significativo\n');
end