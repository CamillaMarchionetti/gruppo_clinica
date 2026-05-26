function metriche = metriche_TUG(pazienti)

    metriche.id = pazienti.id;
    metriche.condizione = pazienti.condizione;

    metriche.rms   = rms(pazienti.acc);
    metriche.var   = var(pazienti.acc);
    metriche.range = max(pazienti.acc) - min(pazienti.acc);
    PD = readtable('PD - Demographic+Clinical - datasetV1.csv');
    indice = find(strcmp(PD.x_, pazienti.id));
    if isempty(indice)
        metriche.HY = 'Nan';
    else
        metriche.HY = PD.x__21(indice);
    end
end