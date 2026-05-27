clear
close all
clc

pd_pazienti = {'NLS140','NLS189','NLS194','NLS201','WPD013','WPD016','WPD029','WPD006','WPD009','NLS121','NLS143','NLS144','NLS148','NLS150','NLS174'};
controlli_pazienti = {'WHC029','HC130','HC132','HC148','HC151','WHC008','WHC011','WHC013','HC100','HC106','HC112','HC114','HC115','HC116','HC117'};

tutti_pazienti = [pd_pazienti, controlli_pazienti];
tutti_gruppi = [repmat("PD",1,length(pd_pazienti)), repmat("Controls",1,length(controlli_pazienti))];
results = table();

for i = 1:length(tutti_pazienti)
    id = tutti_pazienti(i);
    gruppo = tutti_gruppi(i);
    dati = caricare_paziente_BAL(id + ".mat", id, gruppo, "EC_FeetTogether");
    metriche = metriche_BAL(dati);

    variabili = {'rms_dx','var_dx','range_dx','rms_sx','var_sx','range_sx','corr_dx_sx','HY','TREMOR'};

    for j = 1:length(variabili)
        variabile = variabili(j);
        if ~isfield(metriche, variabile)
            metriche.(variabile) = NaN;
        else
            val = metriche.(variabile);
            if isstring(val) || ischar(val)
                val = str2double(val);
            end
            if isempty(val) || isnan(val)
                metriche.(variabile) = NaN;
            else
                metriche.(variabile) = val;
            end
        end
    end
    tabella = table(string(id), string(gruppo), metriche.rms_dx, metriche.var_dx, metriche.range_dx, metriche.rms_sx, metriche.var_sx, metriche.range_sx, metriche.corr_dx_sx, metriche.HY, metriche.TREMOR,'VariableNames', {'id','condition','rms_dx','var_dx','range_dx','rms_sx','var_sx','range_sx','corr_dx_sx','HY','TREMOR'});
    results = [results; tabella];
    disp(tabella);
end

%in base a che pazienti abbiamo inserito all'inizio abbiamo cambiato il nome della tabella in base alla fascia di età
save('results.mat', 'results')
writetable(results, 'results.xlsx')