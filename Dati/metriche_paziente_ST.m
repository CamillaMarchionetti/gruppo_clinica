function metriche = metriche_paziente_ST(paziente)
    metriche.id        = paziente.id;
    metriche.condizione = paziente.condizione;

    metriche.step_media = mean(paziente.step_time);
    metriche.step_std  = std(paziente.step_time);
    metriche.step_CV   = metriche.step_std / metriche.step_mean * 100;

    metriche.stride_sx_media = mean(paziente.stride_sx);
    metriche.stride_sx_std  = std(paziente.stride_sx);
    metriche.stride_sx_CV   = metriche.stride_sx_std / metriche.stride_sx_media * 100;

    metriche.stride_dx_media = mean(paziente.stride_dx);
    metriche.stride_dx_std  = std(paziente.stride_dx);
    metriche.stride_dx_CV   = metriche.stride_dx_std / metriche.stride_dx_media * 100;

    metriche.AI = abs(metriche.stride_sx_media - metriche.stride_dx_media) / (0.5*(metriche.stride_sx_media + metriche.stride_dx_media)) * 100;
end
