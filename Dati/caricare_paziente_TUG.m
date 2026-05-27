function segnale = caricare_paziente_TUG(nome_file, id, condizione, evento)

    segnale = load(nome_file);
    Balance = segnale.Balance;

    attivita = find(Balance.Annotation.GeneralEvent == evento);

    if isempty(attivita)
        error('Evento %s non trovato', evento);
    end
    tempo = Balance.IMU_acc.Time(attivita);
    acc_dx = sqrt(Balance.IMU_acc.R_Wrist_Acc_X(attivita).^2 + Balance.IMU_acc.R_Wrist_Acc_Y(attivita).^2 + Balance.IMU_acc.R_Wrist_Acc_Z(attivita).^2 );
    acc_sx = sqrt(Balance.IMU_acc.L_Wrist_Acc_X(attivita).^2 + Balance.IMU_acc.L_Wrist_Acc_Y(attivita).^2 + Balance.IMU_acc.L_Wrist_Acc_Z(attivita).^2 );
    perc = 0.20;
    n_dx = length(acc_dx);
    i1_dx = round(n_dx * perc);
    i2_dx = round(n_dx * (1 - perc));
    n_sx = length(acc_sx);
    i1_sx = round(n_sx * perc);
    i2_sx = round(n_sx * (1 - perc));
    segnale.id = id;
    segnale.condition = condizione;
    segnale.t_dx = tempo(i1_dx:i2_dx);
    segnale.acc_dx = acc_dx(i1_dx:i2_dx);
    segnale.t_sx = tempo(i1_sx:i2_sx);
    segnale.acc_sx = acc_sx(i1_sx:i2_sx);
end

