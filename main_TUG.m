clear
close all
clc

pd_pazienti = {'NLS196'};
controlli_pazienti = {'WHC007'};
tutti_pazienti = [pd_pazienti, controlli_pazienti];
tutti_gruppi = [repmat("PD",1,length(pd_pazienti)), repmat("Controls",1,length(controlli_pazienti))];
results = table();

for i = 1:length(tutti_pazienti)
    id = tutti_pazienti{i};
    gruppo = tutti_gruppi(i);
    dati = caricare_paziente_TUG(id + ".mat", id, gruppo);
    metriche = metriche_TUG(dati);

    variabili = {'rms','var','range','HY'};

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
    tabella = table(string(id), string(gruppo), metriche.rms, metriche.var, metriche.range, metriche.HY,'VariableNames', {'id','condition','rms','var','range','HY'});
    results = [results; tabella];
    disp(tabella);
end
save('results.mat', 'results')
writetable(results, 'results.xlsx')