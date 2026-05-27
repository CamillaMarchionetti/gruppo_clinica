function paziente = caricare_paziente_ST(file, id_soggetto, condizione, trial, task)

    righe = load(file, trial);
    indici = find(righe.(trial).Annotation.GeneralEvent == task);
    if isempty(indici)
        error('Nessun dato trovato per il task: %s nel trial: %s', task, trial);
    end

    walkway = righe.(trial).Walkway(indici,:);
    paziente.id = id_soggetto;
    paziente.condition = condizione;
    [hs_times_sx, hs_times_dx] = estrazione_heel_strikes(walkway);
    paziente.hs_times_sx = hs_times_sx;
    paziente.hs_times_dx = hs_times_dx;

    stride_sx = diff(hs_times_sx);
    paziente.stride_sx = stride_sx(stride_sx > 0.6 & stride_sx < 2.5);
    stride_dx = diff(hs_times_dx);
    paziente.stride_dx = stride_dx(stride_dx > 0.6 & stride_dx < 2.5);

    heel_strike = sort([hs_times_sx; hs_times_dx]);
    step_time = diff(heel_strike);
    valori_validi = find(step_time > 0.3 & step_time < 1.5);
    paziente.step_time = step_time(valori_validi);
    paziente.heel_strike = heel_strike(valori_validi);
end