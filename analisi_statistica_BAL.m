clear 
close all
clc

tab_65_70 = readtable('results_65_70.xlsx');
tab_70_75 = readtable('results70_75.xlsx');
tab_75_80 = readtable('results75_80.xlsx');

tab_65_70.eta_gruppo = repmat("65_70", height(tab_65_70), 1);
tab_70_75.eta_gruppo = repmat("70_75", height(tab_70_75), 1);
tab_75_80.eta_gruppo = repmat("75_80", height(tab_75_80), 1);

Tabella_tot = [tab_65_70; tab_70_75; tab_75_80];

Tabella_tot.condizione = strtrim(Tabella_tot.condition);

Tabella_tot.condizione = categorical(Tabella_tot.condizione);
Tabella_tot.eta_gruppo = categorical(Tabella_tot.eta_gruppo);

Tabella_tot.log_var_dx = log(Tabella_tot.var_dx);
gruppi = categories(Tabella_tot.eta_gruppo);

mdl_total = fitlm(Tabella_tot, 'log_var_dx ~ condition');
tbl_total = anova(mdl_total);
disp(tbl_total);

for i = 1:length(gruppi)
    g = gruppi{i};
    Tabella_tot_sub = Tabella_tot(Tabella_tot.eta_gruppo == g, :);
    mdl_sub = fitlm(Tabella_tot_sub, 'log_var_dx ~ condition');
    tbl_sub = anova(mdl_sub);
    disp(tbl_sub);
end

f = figure();
subplot(1, 2, 1);
boxplot(Tabella_tot.log_var_dx, Tabella_tot.condizione, 'Notch', 'on', 'Colors', 'rb');
grid on;
ylabel('Log(Varianza DX)');
title('ANOVA Complessiva POLSO DESTRO: Effetto Condizione');
xticklabels({'Controls', 'PD'});

subplot(1, 2, 2);
combined_label = strcat(string(Tabella_tot.eta_gruppo), "_", string(Tabella_tot.condizione));
boxplot(Tabella_tot.log_var_dx, combined_label, 'FactorGap', 10, 'ColorGroup', Tabella_tot.condizione);
grid on;
ylabel('Log(Varianza DX)');
title('ANOVA per Fascia di Età POLSO DESTRO');

Tabella_tot.log_var_sx = log(Tabella_tot.var_sx);
gruppi = categories(Tabella_tot.eta_gruppo);

mdl_total = fitlm(Tabella_tot, 'log_var_sx ~ condition');
tbl_total = anova(mdl_total);
disp(tbl_total);

for i = 1:length(gruppi)
    g = gruppi{i};
    Tabella_tot_sub = Tabella_tot(Tabella_tot.eta_gruppo == g, :);
    mdl_sub = fitlm(Tabella_tot_sub, 'log_var_sx ~ condition');
    tbl_sub = anova(mdl_sub);
    disp(tbl_sub);
end

f = figure();
ax = subplot(1, 2, 1);
boxplot(Tabella_tot.log_var_sx, Tabella_tot.condition, 'Notch', 'on', 'Colors', 'rb');
grid on;
ylabel('Log(Varianza SX)');
title('ANOVA Complessiva POLSO SINISTRO: Effetto Condizione');
xticklabels({'Controls', 'PD'});

ax = subplot(1, 2, 2);
boxplot(Tabella_tot.log_var_sx, combined_label, 'FactorGap', 10, 'ColorGroup', Tabella_tot.condizione);
grid on;
ylabel('Log(Varianza SX)');
title('ANOVA per Fascia di Età polso sinistro');