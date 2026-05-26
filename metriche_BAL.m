function metriche = metriche_BAL(paziente)

    metriche.id = paziente.id;
    metriche.condition = paziente.condition;

    % DX
    metriche.rms_dx   = rms(paziente.acc_dx);
    metriche.var_dx   = var(paziente.acc_dx);
    metriche.range_dx = max(paziente.acc_dx) - min(paziente.acc_dx);

    % SX
    metriche.rms_sx   = rms(paziente.acc_sx);
    metriche.var_sx   = var(paziente.acc_sx);
    metriche.range_sx = max(paziente.acc_sx) - min(paziente.acc_sx);

    % Correlazione
    min_len = min(length(paziente.acc_dx), length(paziente.acc_sx));
    metriche.corr_dx_sx = corr(paziente.acc_dx(1:min_len),paziente.acc_sx(1:min_len));

    PD = readtable('PD - Demographic+Clinical - datasetV1.csv');
    indice = find(strcmp(PD.x_, paziente.id));
    if isempty(indice)
        metriche.HY = 'Nan';
    else
        metriche.HY = PD.x__21(indice);
    end
    PD = readtable('PD - Demographic+Clinical - datasetV1.csv');
    indice = find(strcmp(PD.x_, paziente.id));
    if isempty(indice)
        metriche.TREMORE= 'Nan';
    else
        metriche.TREMORE = PD.TREMOR(indice);
    end
end