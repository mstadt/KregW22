function plot_dMKgut_dt(T,X,params,labels,tf)
    exp_start = params{1}.tchange + 60 + 6*60;
    tf = tf - exp_start;
    times1 = (T{1}-exp_start)/1;
    times2 = (T{2}-exp_start)/1;
    Kin.Kin_type = 'gut_Kin'; % 'step_Kin2';
    Kin.Meal     = 0;
    Kin.KCL      = 0;
    SS = false; % compute SS solution
    Kin1.Kin_type = 'gut_Kin'; 
    Kin1.Meal = 0;
    Kin1.KCL = 1;
    Kin2.Kin_type = 'gut_Kin';%'Preston_SS';
    Kin2.Meal = 0;
    Kin2.KCL = 1;
    Kin_opts{1} = Kin1;
    Kin_opts{2} = Kin2;

    % color options
    c1= [0.9290, 0.6940, 0.1250];%yellow
    c2 = [0.3010, 0.7450, 0.9330]; %blue
    % fontsizes
    fonts.title = 15;
    fonts.xlabel = 15;
    fonts.ylabel = 15;
    fonts.legend = 15;
    marker_size = 15;
    dMKgut_dt1 = zeros(size(T{1}));
    dMKgut_dt2 = zeros(size(T{2}));
    dMKmuscle_dt1 = zeros(size(T{1}));
    dMKmuscle_dt2 = zeros(size(T{2}));

    Phi_ECtoIC = zeros(size(T{1}));
    Phi_ICtoEC = zeros(size(T{1}));

    dMKmuscle_dt_vals1=zeros(size(T{1}));   % this is actually useless bc X{1}(ii,4) is M_Kmuscle, not its derivative. X_P would be derivative, but that is not outputted.
    dMKmuscle_dt_vals2=zeros(size(T{2}));
    dMKgut_dt_vals1=zeros(size(T{1}));
    dMKgut_dt_vals2=zeros(size(T{2}));
    %fprintf('params 1 kgut: %f \n',params{1}.kgut);
    %fprintf('params 2 kgut: %f \n',params{2}.kgut);
    for ii = 1:length(T{1})
        Phi_ECtoIC(ii)=X{1}(ii,13);
        Phi_ICtoEC(ii)=X{1}(ii,14);
        dMKmuscle_dt_vals1(ii)=X{1}(ii,4);
        dMKgut_dt_vals1(ii)=X{1}(ii,1);
        [Phi_Kin1, ~]=get_PhiKin(T{1}(ii), SS, params{1}, Kin1);
        [dMKgut_dt1(ii),dMKmuscle_dt1(ii),~]=get_dMKgut_dt(Phi_Kin1, params{1}.kgut, X{1}(ii,1),X{1}(ii,13),X{1}(ii,14),T{1}(ii));   %X(.,1) = MKgut
        %fprintf('Phi_Kin at time %f: %f \n',T{1}(ii),Phi_Kin1);
    end
    for ii = 1:length(T{2})
        dMKmuscle_dt_vals2(ii)=X{2}(ii,4);
        dMKgut_dt_vals2(ii)=X{2}(ii,1);
        [Phi_Kin2, ~]=get_PhiKin(T{2}(ii), SS, params{2}, Kin2);
        [dMKgut_dt2(ii),dMKmuscle_dt2(ii),~]=get_dMKgut_dt(Phi_Kin2, params{2}.kgut, X{2}(ii,1),X{2}(ii,13),X{2}(ii,14),T{2}(ii));
    end 
    
    figure(100)
    plot(times1,dMKgut_dt1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, dMKgut_dt2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    ylabel('$dM_{Kgut}$ (mEq/min)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
    title('$dM_{Kgut}$ vs time', 'interpreter', 'latex', 'fontsize', fonts.title)
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
    xlim([-exp_start, tf])
   % ylim([-exp_start, tf])
    hold off

    
    figure(101)
    plot(times1,dMKmuscle_dt1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, dMKmuscle_dt2, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    ylabel('$dM_{Kmuscle}$ (mEq/min)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
    title('$dM_{Kmuscle}$ vs time', 'interpreter', 'latex', 'fontsize', fonts.title)
    legend(labels{1}, labels{2}, 'fontsize', fonts.legend)
    xlim([-exp_start, tf])
   % ylim([-exp_start, tf])
    hold off

    figure(102)
    plot(times1,Phi_ECtoIC, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, Phi_ICtoEC, 'linewidth', 2, 'color', c2, 'linestyle', '-.')
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    ylabel('$\Phi$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
    title('$\Phi$ vs time', 'interpreter', 'latex', 'fontsize', fonts.title)
    legend('Phi_{ECtoIC}', 'Phi_{ICtoEC}', 'fontsize', fonts.legend)
    xlim([-exp_start, tf])
   % ylim([-exp_start, tf])
    hold off

end