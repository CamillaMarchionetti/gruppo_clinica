clear
close all
clc

Tabella = readtable("results.xlsx");
Tabella(strcmp(Tabella.id, 'WHC005'),:) = [];
idx_pd = strcmp(Tabella.condition, 'PD');
HY_pd = Tabella.HY(idx_pd);
RMS_pd = Tabella.rms(idx_pd);
[rho_rms, p_val_rms] = corr(HY_pd, RMS_pd,'Type', 'Spearman','Rows', 'complete');

fprintf('Spearman rho rms = %.3f\n', rho_rms)
fprintf('p-value rms = %.4f\n', p_val_rms)

var_pd = Tabella.var(idx_pd);
[rho_var, p_val_var] = corr(HY_pd, var_pd,'Type', 'Spearman','Rows', 'complete');

fprintf('Spearman rho var = %.3f\n', rho_var)
fprintf('p-value var = %.4f\n', p_val_var)

range_pd = Tabella.range(idx_pd);
[rho_range, p_val_range] = corr(HY_pd, range_pd, 'Type', 'Spearman', 'Rows', 'complete');

fprintf('Spearman rho range = %.3f\n', rho_range)
fprintf('p-value range = %.4f\n', p_val_range)