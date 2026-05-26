clear 
close all
clc

PD = {'NLS002.mat', 'NLS005.mat', 'NLS022.mat','NLS033.mat', 'NLS036.mat',  'NLS056.mat', 'NLS101.mat', 'NLS102.mat', 'NLS121.mat', 'NLS124.mat','NLS130.mat','NLS135.mat', 'NLS139.mat', 'NLS140.mat', 'NLS141.mat', 'NLS142.mat', 'NLS143.mat', 'NLS144.mat', 'NLS147.mat', 'NLS148.mat', 'NLS150.mat', 'NLS152.mat', 'NLS153.mat', 'NLS154.mat', 'NLS157.mat',  'NLS158.mat', 'NLS161.mat', 'NLS162.mat','NLS165.mat', 'NLS167.mat', 'NLS170.mat', 'NLS172.mat','NLS173.mat','NLS174.mat','NLS177.mat', 'NLS179.mat','NLS185.mat', 'NLS187.mat', 'NLS190.mat','NLS191.mat','NLS194.mat', 'NLS195.mat', 'NLS196.mat','NLS201.mat', 'WPD009.mat', 'WPD011.mat','WPD016.mat', 'WPD023.mat', 'WPD024.mat','WPD025.mat' };
Controlli  = {'HC100.mat', 'HC101.mat','HC102.mat','HC103.mat', 'HC104.mat', 'HC106.mat','HC107.mat','HC108.mat', 'HC109.mat' , 'HC110.mat','HC111.mat','HC112.mat','HC113.mat', 'HC114.mat','HC115.mat', 'HC116.mat','HC117.mat', 'HC120.mat', 'HC121.mat',  'HC122.mat', 'HC123.mat', 'HC124.mat', 'HC125.mat','HC126.mat', 'HC128.mat', 'HC130.mat', 'HC135.mat','HC137.mat' , 'HC141.mat' ,'HC149.mat' , 'HC153.mat' , 'NLS193.mat','WHC001.mat','WHC006.mat' ,'WHC007.mat', 'WHC008.mat','WHC009.mat','WHC010.mat','WHC011.mat','WHC012.mat','WHC013.mat','WHC014.mat', 'WHC019.mat','WHC020.mat','WHC021.mat','WHC025.mat','WHC026.mat','WHC030.mat','WHC031.mat','WHC033.mat'};
trial = 'SelfPace_mat';
task = 'Walk';

PD_dem_clin = readtable('PD - Demographic+Clinical - datasetV1.csv'); 

PD_pazienti = {};
for i = 1:length(PD)
    id = erase(PD{i}, '.mat');
    PD_pazienti{end+1} = caricare_paziente_ST(PD{i}, id, 'PD', trial, task);
end

Controlli_pazienti = {};
for i = 1:length(Controlli)
    id = erase(Controlli{i}, '.mat');
    Controlli_pazienti{end+1} = caricare_paziente_ST(Controlli{i}, id, 'CONTROL', trial, task);
end

ID = PD_dem_clin.Properties.VariableNames{1}; 
HY = 'Modified Hoehn & Yahr Score';

if ~any(strcmp(PD_dem_clin.Properties.VariableNames, HY))
    %fprintf('Attenzione: Colonna "%s" non trovata. Cerco una colonna simile...\n', HY);
    match = contains(PD_dem_clin.Properties.VariableNames, 'Hoehn');
    if any(match)
        HY = PD_dem_clin.Properties.VariableNames{find(match, 1)};
        %fprintf('Trovata colonna alternativa: %s\n', HY);
    else
        error('Errore critico: Non è stata trovata nessuna colonna relativa al punteggio Hoehn & Yahr.');
    end
end

PD_lieve   = {};    % H&Y 1-2.5
PD_grave = {};    % H&Y 3-5

for i = 1:length(PD_pazienti)
    id_corrente = PD_pazienti{i}.id;
    idx = find(strcmp(string(PD_dem_clin.(ID)), string(id_corrente)));
    
    if ~isempty(idx)
        valore_hy = PD_dem_clin.(HY)(idx);
        if iscell(valore_hy)
            valore_hy = valore_hy{1}; 
        end
        if ischar(valore_hy) || isstring(valore_hy)
            valore_hy = str2double(valore_hy);
        end
        
        if valore_hy <= 2.5        
            PD_lieve{end+1} = PD_pazienti{i};
        elseif valore_hy >= 3      
            PD_grave{end+1} = PD_pazienti{i};
        end
    else
        fprintf('Warning: Soggetto %s non trovato nel file clinico.\n', id_corrente);
    end
end

metriche_controlli = metriche_gruppo_ST(Controlli_pazienti);
metriche_pd = metriche_gruppo_ST(PD_pazienti);
metriche_pd_lievi = metriche_gruppo_ST(PD_lieve);
metriche_pd_gravi = metriche_gruppo_ST(PD_grave);

confronti = { metriche_controlli, metriche_pd, 'CONTROL',  'PD Totale', 'CONTROL vs PD Totale';
              metriche_controlli, metriche_pd_lievi, 'CONTROL',  'PD Lievi',  'CONTROL vs PD Lievi';
              metriche_controlli, metriche_pd_gravi, 'CONTROL',  'PD Gravi',  'CONTROL vs PD Gravi';
              metriche_pd_lievi, metriche_pd_gravi, 'PD Lievi', 'PD Gravi',  'PD Lievi vs PD Gravi'};

for k = 1:size(confronti, 1)
    gruppo1 = confronti{k,1};
    gruppo2 = confronti{k,2};
    label1 = confronti{k,3};
    label2 = confronti{k,4};
    titolo = confronti{k,5};

    test_statistico_ST(gruppo1, gruppo2);
    figure('Name', titolo, 'NumberTitle', 'off', 'Color', 'w', 'Position', [100 100 1200 450]);
    grafico_gruppi_ST(gruppo1, gruppo2, label1, label2, titolo);
end

num_PD = length(PD_pazienti);
vett_media_passo = zeros(num_PD, 1);
vett_CV_passo = zeros(num_PD, 1);
vett_AI_passo = zeros(num_PD, 1);

for i = 1:num_PD
    m = metriche_paziente_ST(PD_pazienti{i});
    vett_media_passo(i) = m.step_media; 
    vett_CV_passo(i) = m.step_CV;   
    vett_AI_passo(i) = m.AI;        
end