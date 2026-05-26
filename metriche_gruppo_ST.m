function metriche = metriche_gruppo_ST(pazienti)
    n = length(pazienti);

    step_media = zeros(n,1);
    step_std = zeros(n,1);
    step_CV = zeros(n,1);
    stride_sx = zeros(n,1);
    stride_dx = zeros(n,1);
    AI = zeros(n,1);
    ids = cell(n,1);

    for i = 1:n
        m = compute_gait_metrics(pazienti{i});
        ids{i} = m.id;
        step_media(i) = m.step_media;
        step_std(i) = m.step_std;
        step_CV(i) = m.step_CV;
        stride_sx(i) = m.stride_sx_media;
        stride_dx(i) = m.stride_dx_media;
        AI(i) = m.AI;
    end

    metriche.ids = ids;
    metriche.step_media = step_media;
    metriche.step_std = step_std;
    metriche.step_CV = step_CV;
    metriche.stride_sx = stride_sx;
    metriche.stride_dx = stride_dx;
    metriche.AI = AI;

    metriche.gruppo_step_media = mean(step_media);
    metriche.gruppo_step_std  = std(step_media);
    metriche.gruppo_CV_media   = mean(step_CV);
    metriche.gruppo_AI_media   = mean(AI);
end