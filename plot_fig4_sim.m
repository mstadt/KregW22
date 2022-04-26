function plot_fig4_sim(T,X,params, Kin_opts, labels, tf, MealInfo, days)
close all
exp_start = 0;%params{1}.tchange + 60 + 6*60;
tf = tf - exp_start;
times1 = (T{1}-exp_start)/1;
times2 = (T{2}-exp_start)/1;
times3 = (T{3}-exp_start)/1;
 
disp('days')
disp(days)
varnames = set_params().varnames;

% color options
c1= [0.9290, 0.6940, 0.1250];%yellow
c2 = [0.3010, 0.7450, 0.9330]; %blue
c3 = [0.4940, 0.1840, 0.5560];%purple

% which plots?
plt_barplots = 0;

% fontsizes
fonts.title = 17;
fonts.xlabel = 17;
fonts.ylabel = 17;
fonts.legend = 17;
fonts.tics = 16;

marker_size = 15;

if plt_barplots
    % plasma K bar plots
    figure(111)
    vals1 = X{1}(:,5);
    vals2 = X{2}(:,5);
    vals3 = X{3}(:,5);
    y = zeros(days,3);
    for i = 1:days
        start_id = find(times1 == (i-1)*1440+1);
        end_id = find(times1 == i*1440);
        y(i,1) = mean(vals1(start_id:end_id));
        y(i,2) = mean(vals2(start_id:end_id));
        y(i,3) = mean(vals3(start_id:end_id));
    end
    disp(y)
    bar(y)
    xlabel('time (days)')
    ylabel('Average plasma [K] (mEq/L)')
    title('Average plasma K concentration per day')
    legend(labels{1}, labels{2}, labels{3})

    % uK bar plots
    figure(112)
    vals1 = X{1}(:,28);
    vals2 = X{2}(:,28);
    vals3 = X{3}(:,28);
    z = zeros(days,3);
    for i = 1:days
        start_id = find(times1 == (i-1)*1440+1);
        end_id = find(times1 == i*1440);
        z(i,1) = mean(vals1(start_id:end_id));
        z(i,2) = mean(vals2(start_id:end_id));
        z(i,3) = mean(vals3(start_id:end_id));
    end
    disp(z)
    bar(z)
    xlabel('time (days)')
    ylabel('Average urine K (mEq/min)')  %%%%% this is average excretion per minute over the course of a day
    title('Average K in urine per day')
    legend(labels{1}, labels{2}, labels{3})

    % muscle K bar plots
    figure(113)
    vals1 = X{1}(:,4);
    vals2 = X{2}(:,4);
    vals3 = X{3}(:,4);
    m = zeros(days,3);
    for i = 1:days
        start_id = find(times1 == (i-1)*1440+1);
        end_id = find(times1 == i*1440);
        m(i,1) = mean(vals1(start_id:end_id));
        m(i,2) = mean(vals2(start_id:end_id));
        m(i,3) = mean(vals3(start_id:end_id));
    end
    disp(m)
    bar(m)
    xlabel('time (days)')
    ylabel('Average K amount in muscle (mEq)')
    title('Average K amound in muscle per day')
    legend(labels{1}, labels{2}, labels{3})
end

% Jessica's plots
PhiKin_vals1 = zeros(size(T{1}));
for ii = 1:length(T{1})
    [PhiKin_vals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1}, MealInfo{1});
end % for ii
PhiKin_vals2 = zeros(size(T{2}));
for ii = 1:length(T{2})
    [PhiKin_vals2(ii), ~] = get_PhiKin(T{2}(ii), 0, params{2}, Kin_opts{2}, MealInfo{2});
end %for ii
PhiKin_vals3 = zeros(size(T{3}));
for ii = 1:length(T{3})
    [PhiKin_vals3(ii), ~] = get_PhiKin(T{3}(ii), 0, params{3}, Kin_opts{3}, MealInfo{3});
end %for ii

% Kidney: Phi_filK 15; Phi_dtKsec 18; Net CD K Transport
figure(101)
plot_these = {15, 18, 'CDKtrans', 28};   % phi uk = 28
for ii = 1:4
    s = subplot(2,2, ii);
    if strcmp(plot_these{ii}, 'CDKtrans')
        vals1 = X{1}(:, 26) - X{1}(:, 23); % reab - sec, positive means net reab
        vals2 = X{2}(:, 26) - X{2}(:, 23);
        vals3 = X{3}(:, 26) - X{3}(:, 23);

    else
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:,plot_these{ii});
    end
%         fprintf('length 2 %f', length(vals2))
%         fprintf('length 3 %f', length(vals3))
    y = zeros(days,3);
    for i = 1:days
        start_id = find(times1 == (i-1)*1440+1);
        end_id = find(times1 == i*1440);
        y(i,1) = mean(vals1(start_id:end_id));
        y(i,2) = mean(vals2(start_id:end_id));
        y(i,3) = mean(vals3(start_id:end_id));
    end
    bar(y);
    ax = gca;
    ax.FontSize = fonts.tics;
    xlabel('time (days)', 'interpreter', 'latex','fontsize', fonts.xlabel)
    ylabel('Average rate (mEq/min)', 'interpreter', 'latex','fontsize', fonts.ylabel)
    if strcmp(plot_these{ii}, 'CDKtrans')
        title('Net CD $K^+$ transport ($\Phi_{cdKsec} - \Phi_{cdKreab}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    else
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
    end
    if plot_these{ii} == 15
        %ylim([0.45, 0.65])
        title('Filtered $K^+$ load ($\Phi_{filK}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    elseif plot_these{ii} == 18
        %ylim([0, 0.5])
        title('Distal Tubule $K^+$ secretion ($\Phi_{dtKsec}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    elseif plot_these{ii} == 28
        %ylim([0, 0.5])
        title('Urinary $K^+$ secretion ($\Phi_{uK}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    elseif strcmp(plot_these{ii}, 'CDKtrans')
        %ylim([0, 0.17])
        %     elseif plot_these{ii} == 28
        %         ylim([0,3])
    end
    %xlim([-exp_start, tf])
    hold off
end
legend(labels, 'fontsize', fonts.legend)

% Amounts : MKgut, MKplasma, MKinterstitial, MKmuscle
figure(102)
plot_these = {'K intake',1,2,3, 4};
for ii = 1:5
    s = subplot(2,3, ii);
    if strcmp(plot_these(ii),'K intake')
        y = zeros(days,3);
        delta_time1 = times1(3)-times1(2); % time interval between two discrete datapoints
        delta_time2 = times2(3)-times2(2);
        delta_time3 = times3(3)-times3(2);
%         total_k_in1a = delta_time1*sum(PhiKin_vals1);
%         total_k_in2a = delta_time2*sum(PhiKin_vals2);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = delta_time1*sum(PhiKin_vals1(start_id:end_id));
            y(i,2) = delta_time2*sum(PhiKin_vals2(start_id:end_id));
            y(i,3) = delta_time3*sum(PhiKin_vals3(start_id:end_id));
%             total_k_in1 = sum(y(1:days,1));
%             total_k_in2 = sum(y(1:days,2));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)', 'fontsize', fonts.xlabel)
        %ylabel('$\Phi_{Kin}$ (mEq)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        ylabel('mEq', 'fontsize', fonts.ylabel)
        title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        % xlim([-exp_start, tf])
        ylim ([0,140])
        hold off
    else
        vals1 = X{1}(:, plot_these{ii});
        vals2 = X{2}(:, plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        y = zeros(days,3);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = mean(vals1(start_id:end_id));
            y(i,2) = mean(vals2(start_id:end_id));
            y(i,3) = mean(vals3(start_id:end_id));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)', 'fontsize', fonts.xlabel)
        ylabel('Average (mEq)', 'fontsize', fonts.ylabel)
        if plot_these{ii} == 4
            %title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
            title('Muscle $K^+$ amount ($M_{Kmuscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([1800, 2800])
        elseif plot_these{ii} == 2
            title('Plasma $K^+$ amount ($M_{Kplasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([12, 19])
        elseif plot_these{ii} == 3
            title('Interstitial $K^+$ amount ($M_{Kinterstitial}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([25, 45])
        elseif plot_these{ii} == 1
            title('Gut $K^+$ amount ($M_{Kgut}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            %ylim([0,29])
        end
        %xlim([-exp_start, 1000])
        %xlim([-exp_start, tf])
        hold off
    end
end
legend(labels, 'fontsize', fonts.legend)

% Concentrations: K interstitial, Kmuscle, K_ECFtotal, C_AL
plot_these = {5,6,7,8,29};  % serum K is x = 5
figure(104)
for ii = 1:5
    s = subplot(2,3, ii);
    vals1 = X{1}(:,plot_these{ii});
    vals2 = X{2}(:,plot_these{ii});
    vals3 = X{3}(:,plot_these{ii});

    y = zeros(days,3);
    for i = 1:days
        start_id = find(times1 == (i-1)*1440+1);
        end_id = find(times1 == i*1440);
        y(i,1) = mean(vals1(start_id:end_id));
        y(i,2) = mean(vals2(start_id:end_id));
        y(i,3) = mean(vals3(start_id:end_id));
    end
    bar(y);

    ax = gca;
    ax.FontSize = fonts.tics;
    xlabel('time (days)', 'fontsize', fonts.xlabel)
    ylabel('Average (mEq/L)', 'fontsize', fonts.ylabel)
    title(varnames{plot_these{ii}}, 'fontsize', fonts.title)

    %xlim([-exp_start, tf])
    if plot_these{ii} == 8
        ylim([80, 160])
        title('Muscle $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
        ylabel('K_{muscle} (mEq/L)', 'fontsize', fonts.ylabel)
        %title('Muscle $K^+$ Concentration ($K_{muscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    elseif plot_these{ii} == 29
        %ylim([70,140])
        title('Aldosterone Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
        %title('Aldosterone Concentration ($C_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        %title('$K^+$ intake ($\Phi_{Kin}$)',           'interpreter', 'latex', 'fontsize', fonts.title)
        ylabel('C_{al} (ng/L)', 'fontsize', fonts.ylabel)
    elseif ismember(plot_these{ii}, [5,6,7])
        ylim([2.5, 4.5])
        if plot_these{ii}==5
            title('Plasma $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Plasma $K^+$ Concentration ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('K_{plasma} (mEq/L)', 'fontsize', fonts.ylabel)
        elseif plot_these{ii}==6
            title('Interstitial $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Interstitial $K^+$ Concentration ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('K_{interstitial} (mEq/L)', 'fontsize', fonts.ylabel)
        elseif plot_these{ii}==7
            title('Extracellular Fluid $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Extracellular Fluid $K^+$ Concentration ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('K_{ECFtotal} (mEq/L)', 'fontsize', fonts.ylabel)
        end
    end
    hold off
end
legend(labels, 'fontsize', fonts.legend)

% FF and FB effects: gamma_Kin 21, gamma_Ald 20, rho_Ald 12, rho_ins 11
figure(105)
plot_these = {29, 12, 20, 11, 21};
for ii = 1:5
    s = subplot(2,3,ii);
    vals1 = X{1}(:,plot_these{ii});
    vals2 = X{2}(:,plot_these{ii});
    vals3 = X{3}(:,plot_these{ii});
    plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
    plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '--')
    ax = gca;
    ax.FontSize = fonts.tics;
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
    xlim([-exp_start, tf])
    if plot_these{ii} == 11
        %ylim([1, 1.12])
    elseif plot_these{ii} == 29
        %ylim([60,90])
        title('Aldosterone Concentration C_{al}', 'fontsize', fonts.title)
        ylabel('ng/L', 'fontsize', fonts.ylabel)
    elseif ismember(plot_these{ii}, [12,20])
        %ylim([0.91, 1.01])
    elseif plot_these{ii} == 21
        %ylim([0, 7])
    end
    hold off
end
legend(labels, 'fontsize', fonts.legend)


% one long plot
figure(107)
plot_these = {'K intake',1,2,3,4,    5,6,7,8,29};   % phi uk = 28
for ii = 1:10
    s = subplot(4,3, ii);
    %xlim([-exp_start, tf])
    if strcmp(plot_these(ii),'K intake')
        y = zeros(days,3);
        delta_time1 = times1(3)-times1(2); % time interval between two discrete datapoints
        delta_time2 = times2(3)-times2(2);
        delta_time3 = times3(3)-times3(2);
%         total_k_in1a = delta_time1*sum(PhiKin_vals1);
%         total_k_in2a = delta_time2*sum(PhiKin_vals2);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = delta_time1*sum(PhiKin_vals1(start_id:end_id));
            y(i,2) = delta_time2*sum(PhiKin_vals2(start_id:end_id));
            y(i,3) = delta_time3*sum(PhiKin_vals3(start_id:end_id));
%             total_k_in1 = sum(y(1:days,1));
%             total_k_in2 = sum(y(1:days,2));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)', 'interpreter', 'latex', 'fontsize', fonts.xlabel)
        %ylabel('$\Phi_{Kin}$ (mEq)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        ylabel('mEq', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        % xlim([-exp_start, tf])
        ylim([0,140])
    elseif ismember(plot_these{ii},[1,2,3,4])
        vals1 = X{1}(:, plot_these{ii});
        vals2 = X{2}(:, plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        y = zeros(days,3);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = mean(vals1(start_id:end_id));
            y(i,2) = mean(vals2(start_id:end_id));
            y(i,3) = mean(vals3(start_id:end_id));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)','interpreter', 'latex', 'fontsize', fonts.xlabel)
        ylabel('Average (mEq)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        if plot_these{ii} == 4

            title('Muscle $K^+$ amount ($M_{Kmuscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([1800, 2900])
        elseif plot_these{ii} == 2
            title('Plasma $K^+$ amount ($M_{Kplasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([12, 21])
        elseif plot_these{ii} == 3
            title('Interstitial $K^+$ amount ($M_{Kinter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([25, 45])
        elseif plot_these{ii} == 1
            title('Gut $K^+$ amount ($M_{Kgut}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([0,8])
            %ylim([0,30])
            %ylim([0,29])
        end
    end
    if ismember(plot_these{ii}, [5,6,7,8,29])
        %xlim([-exp_start, 1000])
        %xlim([-exp_start, tf])
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:,plot_these{ii});

        y = zeros(days,3);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = mean(vals1(start_id:end_id));
            y(i,2) = mean(vals2(start_id:end_id));
            y(i,3) = mean(vals3(start_id:end_id));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)','interpreter', 'latex', 'fontsize', fonts.xlabel)
        ylabel('Average (mEq/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)

        %xlim([-exp_start, tf])
        if plot_these{ii} == 8
            ylim([80, 160])
            title('Muscle [$K^+$] ($K_{muscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Muscle $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('mEq/L', 'interpreter', 'latex','fontsize', fonts.ylabel)
            %ylabel('K_{muscle} (mEq/L)', 'fontsize', fonts.ylabel)
        elseif plot_these{ii} == 29
            %ylim([70,140])
            title('Aldosterone Concentration ($C_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('ng/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
%             title('Aldosterone Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
%             ylabel('C_{al} (ng/L)', 'fontsize', fonts.ylabel)
        elseif ismember(plot_these{ii}, [5,6,7])
            ylim([2.5, 4.5])
            if plot_these{ii}==5
                title('Plasma [$K^+$] ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Plasma $K^+$ Concentration ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
                %ylabel('K_{plasma} (mEq/L)', 'fontsize', fonts.ylabel)
            elseif plot_these{ii}==6
                title('Interstitial [$K^+$] ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Interstitial $K^+$ Concentration ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L',  'interpreter', 'latex', 'fontsize',fonts.ylabel)
                %ylabel('K_{interstitial} (mEq/L)', 'fontsize', fonts.ylabel)
            elseif plot_these{ii}==7
                title('Extracellular Fluid [$K^+$] ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Extracellular Fluid $K^+$ Concentration ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L',  'interpreter', 'latex', 'fontsize', fonts.ylabel)
                %ylabel('K_{ECFtotal} (mEq/L)', 'fontsize', fonts.ylabel)
            end
        end
    end
    hold off
end
legend(labels, 'fontsize', fonts.legend)




% one long plot but just the concentrations
figure(108)
plot_these = {'K intake',5,6,7,8,29};   % phi uk = 28
for ii = 1:6
    s = subplot(2,3, ii);
    %xlim([-exp_start, tf])
    if strcmp(plot_these(ii),'K intake')
        y = zeros(days,3);
        delta_time1 = times1(3)-times1(2); % time interval between two discrete datapoints
        delta_time2 = times2(3)-times2(2);
        delta_time3 = times3(3)-times3(2);
%         total_k_in1a = delta_time1*sum(PhiKin_vals1);
%         total_k_in2a = delta_time2*sum(PhiKin_vals2);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = delta_time1*sum(PhiKin_vals1(start_id:end_id));
            y(i,2) = delta_time2*sum(PhiKin_vals2(start_id:end_id));
            y(i,3) = delta_time3*sum(PhiKin_vals3(start_id:end_id));
%             total_k_in1 = sum(y(1:days,1));
%             total_k_in2 = sum(y(1:days,2));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)', 'interpreter', 'latex', 'fontsize', fonts.xlabel)
        %ylabel('$\Phi_{Kin}$ (mEq)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        ylabel('mEq', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        % xlim([-exp_start, tf])
        ylim([0,140])
    elseif ismember(plot_these{ii},[1,2,3,4])
        vals1 = X{1}(:, plot_these{ii});
        vals2 = X{2}(:, plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        y = zeros(days,3);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = mean(vals1(start_id:end_id));
            y(i,2) = mean(vals2(start_id:end_id));
            y(i,3) = mean(vals3(start_id:end_id));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)','interpreter', 'latex', 'fontsize', fonts.xlabel)
        ylabel('Average (mEq)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        if plot_these{ii} == 4

            title('Muscle $K^+$ amount ($M_{Kmuscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([1800, 2900])
        elseif plot_these{ii} == 2
            title('Plasma $K^+$ amount ($M_{Kplasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([12, 21])
        elseif plot_these{ii} == 3
            title('Interstitial $K^+$ amount ($M_{Kinter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([25, 45])
        elseif plot_these{ii} == 1
            title('Gut $K^+$ amount ($M_{Kgut}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylim([0,8])
            %ylim([0,30])
            %ylim([0,29])
        end
    end
    if ismember(plot_these{ii}, [5,6,7,8,29])
        %xlim([-exp_start, 1000])
        %xlim([-exp_start, tf])
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:,plot_these{ii});

        y = zeros(days,3);
        for i = 1:days
            start_id = find(times1 == (i-1)*1440+1);
            end_id = find(times1 == i*1440);
            y(i,1) = mean(vals1(start_id:end_id));
            y(i,2) = mean(vals2(start_id:end_id));
            y(i,3) = mean(vals3(start_id:end_id));
        end
        bar(y);
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (days)','interpreter', 'latex', 'fontsize', fonts.xlabel)
        ylabel('Average (mEq/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)

        %xlim([-exp_start, tf])
        if plot_these{ii} == 8
            ylim([80, 160])
            title('Muscle [$K^+$] ($K_{muscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Muscle $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('mEq/L', 'interpreter', 'latex','fontsize', fonts.ylabel)
            %ylabel('K_{muscle} (mEq/L)', 'fontsize', fonts.ylabel)
        elseif plot_these{ii} == 29
            %ylim([70,140])
            title('Aldosterone Concentration ($C_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('ng/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
%             title('Aldosterone Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
%             ylabel('C_{al} (ng/L)', 'fontsize', fonts.ylabel)
        elseif ismember(plot_these{ii}, [5,6,7])
            ylim([2.5, 4.5])
            if plot_these{ii}==5
                title('Plasma [$K^+$] ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Plasma $K^+$ Concentration ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
                %ylabel('K_{plasma} (mEq/L)', 'fontsize', fonts.ylabel)
            elseif plot_these{ii}==6
                title('Interstitial [$K^+$] ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Interstitial $K^+$ Concentration ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L',  'interpreter', 'latex', 'fontsize',fonts.ylabel)
                %ylabel('K_{interstitial} (mEq/L)', 'fontsize', fonts.ylabel)
            elseif plot_these{ii}==7
                title('Extracellular Fluid [$K^+$] ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Extracellular Fluid $K^+$ Concentration ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L',  'interpreter', 'latex', 'fontsize', fonts.ylabel)
                %ylabel('K_{ECFtotal} (mEq/L)', 'fontsize', fonts.ylabel)
            end
        end
    end
    hold off
end
legend(labels, 'fontsize', fonts.legend)

% fprintf('total k in = %f \n', total_k_in1)
% fprintf('total k X on = %f \n', total_k_in2)



end %plot_simulation