clear
close all
clc

WALKWAY = readtable('PKMAS Walkway Gait Metrics - HP+SP.csv');
PD = readtable('PD - Demographic+Clinical - datasetV1.csv');
CONTROLS = readtable('CONTROLS - Demographic+Clinical - datasetV1.csv');

WALKWAY_PD = WALKWAY(strcmp(WALKWAY.PDVsControl,'PD') & strcmp(WALKWAY.Task,'SelfPace'), :);
WALKWAY_CONTROLS = WALKWAY(strcmp(WALKWAY.PDVsControl,'Control') & strcmp(WALKWAY.Task,'SelfPace'), :);

[val_PD, loc_PD] = ismember(PD.x_, WALKWAY_PD.ParticipantID);
WALKWAY_PD = WALKWAY_PD(loc_PD(val_PD), :);
[val_CONTROLS, loc_CONTROLS] = ismember(CONTROLS.Var1, WALKWAY_CONTROLS.ParticipantID);
WALKWAY_CONTROLS = WALKWAY_CONTROLS(loc_CONTROLS(val_CONTROLS), :);

TAB_PD = innerjoin(PD(:,["x_","x__4","x__5"]),WALKWAY_PD(:,["ParticipantID", "StepLength_cm__","StepLength_cm___1","StepLength_cm___2","StepLength_cm___3", "StepLength_cm___4","StepLength_cm___5","Velocity_cm__sec__"]), "LeftKeys","x_", "RightKeys","ParticipantID");
TAB_CONTROLS = innerjoin(CONTROLS(:,["Var1","Var8","Var4"]),WALKWAY_CONTROLS(:,["ParticipantID", "StepLength_cm__","StepLength_cm___1","StepLength_cm___2","StepLength_cm___3", "StepLength_cm___4","StepLength_cm___5","Velocity_cm__sec__"]), "LeftKeys","Var1", "RightKeys","ParticipantID");
TAB_CONTROLS = TAB_CONTROLS(1:end-1,:);


TAB_PD.Properties.VariableNames = ["ID", "Altezza", "Eta", "Step_length_samples", "Step_length_mean", "Step_length_mean_ratio", "Step_length_mean_asi", "Step_length_SD","Step_length_CV","Velocita"];
TAB_CONTROLS.Properties.VariableNames = ["ID", "Altezza", "Eta", "Step_length_samples", "Step_length_mean", "Step_length_mean_ratio", "Step_length_mean_asi", "Step_length_SD","Step_length_CV","Velocita"];

TAB_PD.Gruppo = repmat("PD", height(TAB_PD), 1);
TAB_CONTROLS.Gruppo = repmat("Controlli", height(TAB_CONTROLS), 1);
TAB = [TAB_PD; TAB_CONTROLS];
TAB.Gruppo = categorical(TAB.Gruppo);
summary(TAB);

f1 = figure();
mdl_mean = fitlm(TAB, 'Step_length_mean ~ Gruppo + Altezza');
disp(mdl_mean)
h0 = plotAdded(mdl_mean); 
hold on;
adjX = h0(1).XData;
adjY = h0(1).YData;
% delete(h0(1));
groupNames = mdl_mean.VariableInfo.Range{'Gruppo'}; 
idx1 = (TAB.Gruppo == groupNames(1)); 
idx2 = (TAB.Gruppo == groupNames(2));
scatter(adjX(idx1), adjY(idx1), 40, 'filled', 'MarkerFaceColor', [0.85 0.33 0.1], 'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', 'Parkinson');
scatter(adjX(idx2), adjY(idx2), 40, 'filled', 'MarkerFaceColor', [0 0.45 0.74], 'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', 'Controlli');
set(h0(2), 'Color', 'red', 'LineWidth', 2, 'DisplayName', 'Modello (Fit)'); 
set(h0(3), 'Color', [1 0.5 0.5], 'LineStyle', ':', 'LineWidth', 1); 
title({'Linear regression model:', 'Step length mean ~ 1 + Altezza + Gruppo'}, 'FontSize', 12);
xlabel('Adjusted whole model');
ylabel('Step length mean');
legend('Location', 'best'); 
grid on;
set(gca, 'Box', 'off');

f2 = figure();
mdl_mean2 = fitlm(TAB, 'Step_length_mean ~ Gruppo + Altezza + Eta');
disp(mdl_mean2)
res = mdl_mean2.Residuals.Raw;
[h,p] = lillietest(res);
plotResiduals(mdl_mean2,'probability');
h1 = plotAdded(mdl_mean2);
hold on;
adjX = h1(1).XData;
adjY = h1(1).YData;
delete(h1(1));
groupNames = mdl_mean2.VariableInfo.Range{'Gruppo'}; 
idx1 = (TAB.Gruppo == groupNames(1)); 
idx2 = (TAB.Gruppo == groupNames(2));
scatter(adjX(idx1), adjY(idx1), 50, 'filled', 'MarkerFaceColor', [0.85 0.33 0.1], 'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', char(groupNames(1)));
scatter(adjX(idx2), adjY(idx2), 50, 'filled', 'MarkerFaceColor', [0 0.45 0.74], 'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', char(groupNames(2)));
set(h1(2), 'Color', 'green', 'LineWidth', 2, 'DisplayName', 'Fit');
set(h1(3), 'Color', [0.6 1 0.6], 'LineStyle', ':', 'LineWidth', 1);
title({'Linear regression model:', 'Step length mean ~ 1 + Altezza + Gruppo + Età'}, 'FontSize', 12);
xlabel('Adjusted whole model');
ylabel('Step length mean');
legend('Location', 'best');
grid on;
set(gca, 'Box', 'off');

f3 = figure();
boxchart(categorical(TAB.Gruppo), TAB.Step_length_mean)
hold on;
scatter(categorical(TAB.Gruppo), TAB.Step_length_mean, 10, 'filled', 'jitter','on','MarkerFaceAlpha',0.3)
ylabel('Step length mean (cm)')
xlabel('Group')
title('Step length distribution')

f4 = figure();
mdl_vel = fitlm(TAB, 'Velocita ~ Gruppo + Altezza + Eta + Step_length_mean');
disp(mdl_vel)
res_vel = mdl_vel.Residuals.Raw;
[h1,p1] = lillietest(res_vel);
plotResiduals(mdl_vel,'probability');
h2 = plotAdded(mdl_vel);
hold on;
adjX = h2(1).XData;
adjY = h2(1).YData;
groupNames = categories(TAB.Gruppo);
idx1 = (TAB.Gruppo == groupNames{1});
idx2 = (TAB.Gruppo == groupNames{2});
scatter(adjX(idx1), adjY(idx1), 50, 'filled', 'MarkerFaceColor', [0.85 0.33 0.1], 'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', groupNames{1});
scatter(adjX(idx2), adjY(idx2), 50, 'filled', 'MarkerFaceColor', [0 0.45 0.74], 'MarkerEdgeColor', [0.2 0.2 0.2], 'DisplayName', groupNames{2});
set(h2(2), 'Color', 'green', 'LineWidth', 2, 'DisplayName', 'Fit');
set(h2(3), 'Color', [0.6 1 0.6],'LineStyle', ':','LineWidth', 1);
title({'Linear regression model:', 'Velocità ~ 1 + Altezza + Età + Step length mean + Gruppo'}, 'FontSize', 12);
xlabel('Adjusted whole model');
ylabel('Velocità');
legend('Location', 'best');
grid on;
set(gca, 'Box', 'off');