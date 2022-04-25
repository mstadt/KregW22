function plot_nicePreston(T, X, params, Kin_opts, MealInfo)  
% plots nice plots for run_Preston_exp that can be used in the manuscript
%% if want to remove the outlying datapoin in Meal UP experiment, use Meal_UK_scaled_nodatapoint data. Otherwise - use Meal_UK_scaled

close all
exp_start = params{1}.tchange + 60 + 6*60;
times1 = (T{1} - exp_start)/1;
times2 = (T{2} - exp_start)/1;
times3 = (T{3} - exp_start)/1;

varnames = set_params().varnames;

% color options
c1= [0.9290, 0.6940, 0.1250]; %yellow
c2 = [0.4940, 0.1840, 0.5560];%purple
c3 = [0.3010, 0.7450, 0.9330]; %blue

% which plots?
plt_separate= 0;
plt_together = 1;   %combined plots

% fontsizes
fonts.title = 17;
fonts.xlabel = 17;
fonts.ylabel = 17;
fonts.legend = 17;
fonts.tics = 16;

markersize = 15;

labels = {'K^+ deficient Meal', '35 mmol K^+ ingested orally', 'K^+ deficient Meal + 35 mmol K^+'};
data = load('./Data/PrestonData.mat');
data_times = data.time_UK_cmlt;

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

if plt_separate
    %% ALD
    figure(5)
    plot_these = {29, 32, 20, 25};
    for ii = 1:4
        s = subplot(2,2,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (min)', 'fontsize', fonts.xlabel)

        if plot_these{ii} == 29
            ylim([60,90])
            title('Aldosterone Concentration C_{al}', 'fontsize', fonts.title)
            ylabel('ng/L', 'fontsize', fonts.ylabel)
        elseif plot_these{ii} == 32
            ylim([0.5, 1.1])
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        elseif plot_these{ii} == 20
            ylim([0.92, 1.01])
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        elseif plot_these{ii} == 25
            ylim([0.85,1.01])
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end
        xlim([-exp_start, 1200])

        hold off
    end
    legend(labels, 'fontsize', fonts.legend)


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
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        if plot_these{ii}==28
            errorbar(data.time_UK, data.Meal_UK_scaled, data.Meal_UK_err,'.', 'markersize', markersize,'color',c1)
            plot(data_times, data.Meal_UK_scaled, '.', 'markersize', markersize, 'color', c1)  % - with the datapoint
            errorbar(data_times, data.KCL_UK_scaled, data.KCL_UK_err,'.', 'markersize', markersize,'color',c2)
            plot(data_times, data.KCL_UK_scaled, '.', 'markersize', markersize, 'color', c2)
            errorbar(data_times, data.MealKCL_UK_scaled, data.MealKCL_UK_err,'.', 'markersize', markersize,'color',c3)
            plot(data_times, data.MealKCL_UK_scaled, '.', 'markersize', markersize, 'color', c3)
        end
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (min)', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        if strcmp(plot_these{ii}, 'CDKtrans')
            title('Net CD $K^+$ transport ($\Phi_{cdKsec} - \Phi_{cdKreab}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        else
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end
        if plot_these{ii} == 15
            ylim([0.42, 0.58])
            title('Filtered $K^+$ load ($\Phi_{filK}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        elseif plot_these{ii} == 18
            ylim([0, 0.3])
            title('Distal Tubule $K^+$ secretion ($\Phi_{dtKsec}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        elseif strcmp(plot_these{ii}, 'CDKtrans')
            ylim([0, 0.17])
            %     elseif plot_these{ii} == 28
            %         ylim([0,3])
        elseif plot_these{ii} == 28
            title('Urinary $K^+$ secretion ($\Phi_{uK}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        end
        xlim([-420, 1020])
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)

    % Amounts : MKgut, MKplasma, MKinterstitial, MKmuscle
    figure(102)
    plot_these = {'K intake',1,2,3, 4};
    for ii = 1:5
        s = subplot(2,3, ii);
        if strcmp(plot_these{ii},'K intake')
            plot(times1, PhiKin_vals1, 'linewidth', 2, 'color', c1)
            hold on
            plot(times2, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
            plot(times3, PhiKin_vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
            ax = gca;
            ax.FontSize = fonts.tics;
            xlabel('time (min)', 'fontsize', fonts.xlabel)
            ylabel('$\Phi_{Kin}$ (mEq/min)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)

            xlim([-420, 1020])
        else
            vals1 = X{1}(:, plot_these{ii});
            vals2 = X{2}(:, plot_these{ii});
            vals3 = X{3}(:, plot_these{ii});
            plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
            hold on
            plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
            plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
            ax = gca;
            ax.FontSize = fonts.tics;
            xlabel('time (min)', 'fontsize', fonts.xlabel)
            ylabel('mEq', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            if plot_these{ii} == 4
                %title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
                title('Muscle $K^+$ amount ($M_{Kmuscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([2650, 2750])
            elseif plot_these{ii} == 2
                title('Plasma $K^+$ amount ($M_{Kplasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([15, 22])
            elseif plot_these{ii} == 3
                title('Interstitial $K^+$ amount ($M_{Kinter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([35, 45])
            elseif plot_these{ii} == 1
                title('Gut $K^+$ amount ($M_{Kgut}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([0,29])
            else
                title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
                ylim([0,29])
            end
            %xlim([-exp_start, 1000])
            xlim([-420,1020])
            hold off
        end
    end
    legend(labels, 'fontsize', fonts.legend)

    % % Phi_kin
    % figure(103)
    % plot(times1, PhiKin_vals1, 'linewidth', 2, 'color', c1)
    % hold on
    % plot(times2, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
    % plot(times3, PhiKin_vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
    % ax = gca;
    % ax.FontSize = fonts.tics;
    % xlabel('time (min)', 'fontsize', fonts.xlabel)
    % ylabel('$\Phi_{Kin}$ (mEq/min)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
    % title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    % legend(labels, 'fontsize', fonts.legend)
    % xlim([-420, 1020])
    % hold off

    % Concentrations: K interstitial, Kmuscle, K_ECFtotal
    plot_these = {5,6,7,8, 29};  % serum K is x = 5; C_al = 29
    figure(104)
    for ii = 1:5
        s = subplot(2,3, ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        if plot_these{ii}==5
            errorbar(data.time_serum, data.Meal_serum_scaled, data.Meal_serum_err,'.', 'markersize', markersize,'color',c1)
            plot(data.time_serum, data.Meal_serum_scaled, '.', 'markersize', markersize, 'color', c1)
            errorbar(data.time_serum, data.KCL_serum_scaled, data.KCL_serum_err,'.', 'markersize', markersize,'color',c2)
            plot(data.time_serum, data.KCL_serum_scaled, '.', 'markersize', markersize, 'color', c2)
            errorbar(data.time_serum, data.MealKCL_serum_scaled, data.MealKCL_serum_err,'.', 'markersize', markersize,'color',c3)
            plot(data.time_serum, data.MealKCL_serum_scaled, '.', 'markersize', markersize, 'color', c3)
        end
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (min)', 'fontsize', fonts.xlabel)
        ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-420,1020])
        if plot_these{ii} == 8
            ylim([140, 150])
            title('Muscle $[K^+]$', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Muscle $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$K_{muscle}$ (mEq/L)', 'fontsize', fonts.ylabel)
        elseif ismember(plot_these{ii}, [5,6,7])
            if plot_these{ii}==5
                title('Plasma $[K^+]$', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Plasma $K^+$ Concentration ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$K_{plasma}$ (mEq/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            elseif plot_these{ii}==6
                title('Interstitial $[K^+]$', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Interstitial $K^+$ Concentration ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$K_{interstitial}$ (mEq/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            elseif plot_these{ii}==7
                title('Extracellular Fluid $[K^+]$', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Extracellular Fluid $K^+$ Concentration ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$K_{ECFtotal}$ (mEq/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            end
            ylim([3.3, 4.7])
        elseif plot_these{ii} == 29
            ylim([60,90])
            title('Aldosterone Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$C_{al}$ (ng/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        end
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)

    % FF and FB effects: gamma_Kin 21, gamma_Ald 20, rho_Ald 12, rho_ins 11
    figure(105)
    plot_these = {12, 20, 11, 21};
    for ii = 1:4
        s = subplot(2,2,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (min)', 'fontsize', fonts.xlabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-420, 1020])
        if plot_these{ii} == 11
            ylim([1, 1.12])
            title('Effect of [insulin] on $Na^+K^+ATPase$ activity', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$\rho_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        elseif plot_these{ii} == 29
            ylim([60,90])
            title('Aldosterone Concentration C_{al}', 'fontsize', fonts.title)
            ylabel('ng/L', 'fontsize', fonts.ylabel)
        elseif ismember(plot_these{ii}, [12,20])
            ylim([0.91, 1.01])
            if plot_these{ii} == 12
                title('Effect of [ALDO] on $Na^+K^+ATPase$ activity', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$\rho_{al}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            elseif plot_these{ii} == 20
                title('Effect of [ALDO] on distal tubule $K^+$ secretion', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Effect of [ALDO] on distal tubule $K^+$ secretion ($\gamma_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$\gamma_{al}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            end
        elseif plot_these{ii} == 21
            ylim([0, 7])
            title('Gastrointestinal Feedforward Effect', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Gastrointestinal Feedforward Effect ($\gamma_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$\gamma_{Kin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        end
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)


    % one big one
    figure(200)

    plot_these = {12, 20, 11, 21};
    for ii = 1:4
        s = subplot(2,3,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (min)', 'fontsize', fonts.xlabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-420, 1020])
        if plot_these{ii} == 11
            ylim([1, 1.12])
            title('Effect of [insulin] on $Na^+K^+ATPase$ activity', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$\rho_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        elseif plot_these{ii} == 29
            ylim([60,90])
            title('Aldosterone Concentration C_{al}', 'fontsize', fonts.title)
            ylabel('ng/L', 'fontsize', fonts.ylabel)
        elseif ismember(plot_these{ii}, [12,20])
            ylim([0.91, 1.01])
            if plot_these{ii} == 12
                title('Effect of [ALDO] on $Na^+K^+ATPase$ activity', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$\rho_{al}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            elseif plot_these{ii} == 20
                title('Effect of [ALDO] on distal tubule $K^+$ secretion', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Effect of [ALDO] on distal tubule $K^+$ secretion ($\gamma_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$\gamma_{al}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            end
        elseif plot_these{ii} == 21
            ylim([0, 7])
            title('Gastrointestinal Feedforward Effect', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Gastrointestinal Feedforward Effect ($\gamma_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$\gamma_{Kin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        end
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end


%% two big plots with everything
if plt_together
    % 1 - all concentrations and amounts
    figure(111)
    plot_these = {'K intake',1,2,3,4,     5,6,7,8,29};
    for ii = 1:10
        s = subplot(4,3, ii);
        if strcmp(plot_these{ii},'K intake')
            plot(times1, PhiKin_vals1, 'linewidth', 2, 'color', c1)
            hold on
            plot(times2, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
            plot(times3, PhiKin_vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
            ax = gca;
            ax.FontSize = fonts.tics;
            xlabel('time (min)', 'interpreter', 'latex', 'fontsize', fonts.xlabel)
            ylabel('mEq/min', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            xlim([-420, 1020])
        elseif ismember(plot_these{ii},[1,2,3,4])   % amounts
            vals1 = X{1}(:, plot_these{ii});
            vals2 = X{2}(:, plot_these{ii});
            vals3 = X{3}(:, plot_these{ii});
            plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
            hold on
            plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
            plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
            ax = gca;
            ax.FontSize = fonts.tics;
            xlabel('time (min)', 'interpreter', 'latex', 'fontsize', fonts.xlabel)
            ylabel('mEq', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            if plot_these{ii} == 4
                %title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
                title('Muscle $K^+$ amount ($M_{Kmuscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([2650, 2750])
            elseif plot_these{ii} == 2
                title('Plasma $K^+$ amount ($M_{Kplasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([15, 22])
            elseif plot_these{ii} == 3
                title('Interstitial $K^+$ amount ($M_{Kinter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([35, 45])
            elseif plot_these{ii} == 1
                title('Gut $K^+$ amount ($M_{Kgut}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylim([0,29])
            else
                title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
                ylim([0,29])
            end
            %xlim([-exp_start, 1000])
            xlim([-420,1020])
        elseif ismember(plot_these{ii},[5,6,7,8,29])
            vals1 = X{1}(:,plot_these{ii});
            vals2 = X{2}(:,plot_these{ii});
            vals3 = X{3}(:,plot_these{ii});
            plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
            hold on
            plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
            plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
            if plot_these{ii}==5
                errorbar(data.time_serum, data.Meal_serum_scaled, data.Meal_serum_err,'.', 'markersize', markersize,'color',c1)
                plot(data.time_serum, data.Meal_serum_scaled, '.', 'markersize', markersize, 'color', c1)
                errorbar(data.time_serum, data.KCL_serum_scaled, data.KCL_serum_err,'.', 'markersize', markersize,'color',c2)
                plot(data.time_serum, data.KCL_serum_scaled, '.', 'markersize', markersize, 'color', c2)
                errorbar(data.time_serum, data.MealKCL_serum_scaled, data.MealKCL_serum_err,'.', 'markersize', markersize,'color',c3)
                plot(data.time_serum, data.MealKCL_serum_scaled, '.', 'markersize', markersize, 'color', c3)
            end
            ax = gca;
            ax.FontSize = fonts.tics;
            xlabel('time (min)', 'interpreter', 'latex','fontsize', fonts.xlabel)
            ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
            xlim([-420,1020])
            if plot_these{ii} == 8
                ylim([140, 150])
                title('Muscle $[K^+]$ ($K_{muscle}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Muscle $K^+$ Concentration', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('mEq/L', 'fontsize', fonts.ylabel)
                %ylabel('$K_{muscle}$ (mEq/L)', 'fontsize', fonts.ylabel)
            elseif ismember(plot_these{ii}, [5,6,7])
                if plot_these{ii}==5
                    title('Plasma $[K^+]$ ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                    %title('Plasma $K^+$ Concentration ($K_{plasma}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                    ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
                    %ylabel('$K_{plasma}$ (mEq/L)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
                elseif plot_these{ii}==6
                    title('Interstitial $[K^+]$ ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                    %title('Interstitial $K^+$ Concentration ($K_{inter}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                    ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
                elseif plot_these{ii}==7
                    title('Extracellular Fluid $[K^+]$ ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                    %title('Extracellular Fluid $K^+$ Concentration ($K_{ECFtotal}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                    ylabel('mEq/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
                end
                ylim([3.3, 4.7])
            elseif plot_these{ii} == 29
                ylim([60,90])
                title('Aldosterone Concentration ($C_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('ng/L', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            end
        end
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)

    % 2 - effects and kidney
    figure(112)
    plot_these = {15,18,'CDKtrans',28,    12,20,11,21};   % phi uk = 28
    for ii = 1:8
        s = subplot(3,3, ii);
        if strcmp(plot_these{ii}, 'CDKtrans')
            vals1 = X{1}(:, 26) - X{1}(:, 23); % reab - sec, positive means net reab
            vals2 = X{2}(:, 26) - X{2}(:, 23);
            vals3 = X{3}(:, 26) - X{3}(:, 23);
        elseif ismember(plot_these{ii},[15,18,28,12,20,11,21])
            vals1 = X{1}(:,plot_these{ii});
            vals2 = X{2}(:,plot_these{ii});
            vals3 = X{3}(:,plot_these{ii});
        end
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        if plot_these{ii}==28
            errorbar(data.time_UK, data.Meal_UK_scaled, data.Meal_UK_err,'.', 'markersize', markersize,'color',c1)
            plot(data_times, data.Meal_UK_scaled, '.', 'markersize', markersize, 'color', c1)  % - with the datapoint
            errorbar(data_times, data.KCL_UK_scaled, data.KCL_UK_err,'.', 'markersize', markersize,'color',c2)
            plot(data_times, data.KCL_UK_scaled, '.', 'markersize', markersize, 'color', c2)
            errorbar(data_times, data.MealKCL_UK_scaled, data.MealKCL_UK_err,'.', 'markersize', markersize,'color',c3)
            plot(data_times, data.MealKCL_UK_scaled, '.', 'markersize', markersize, 'color', c3)
        end
        ax = gca;
        ax.FontSize = fonts.tics;
        xlabel('time (min)', 'interpreter', 'latex', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        if strcmp(plot_these{ii}, 'CDKtrans')
            title('Net CD $K^+$ Transport ($\Phi_{cdKsec} - \Phi_{cdKreab}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        else
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end

        if plot_these{ii} == 15
            ylim([0.42, 0.58])
            title('Filtered $K^+$ Load ($\Phi_{filK}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        elseif plot_these{ii} == 18
            ylim([0, 0.3])
            title('Distal Tubule $K^+$ Secretion ($\Phi_{dtKsec}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        elseif strcmp(plot_these{ii}, 'CDKtrans')
            ylim([0, 0.17])
            %     elseif plot_these{ii} == 28
            %         ylim([0,3])
        elseif plot_these{ii} == 28
            title('Urinary $K^+$ Secretion ($\Phi_{uK}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
        elseif plot_these{ii} == 11
            ylim([1, 1.12])
            title('[Insulin] Effect on $Na^+$-$K^+$-$ATPase$', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Effect of [insulin] on $Na^+K^+ATPase$ activity', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$\rho_{insulin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        elseif plot_these{ii} == 29
            ylim([60,90])
            title('Aldosterone Concentration (C_{al})', 'fontsize', fonts.title)
            ylabel('ng/L', 'fontsize', fonts.ylabel)
        elseif ismember(plot_these{ii}, [12,20])
            ylim([0.91, 1.01])
            if plot_these{ii} == 12
                title('[ALDO] Effect on $Na^+$-$K^+$-$ATPase$', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Effect of [ALDO] on $Na^+K^+ATPase$ activity', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$\rho_{al}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            elseif plot_these{ii} == 20
                title('[ALDO] Effect on DT $K^+$ Secretion', 'interpreter', 'latex', 'fontsize', fonts.title)
                %title('Effect of [ALDO] on distal tubule $K^+$ secretion ($\gamma_{al}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
                ylabel('$\gamma_{al}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
            end
        elseif plot_these{ii} == 21
            ylim([0, 7])
            title('Gastrointestinal Feedforward Effect', 'interpreter', 'latex', 'fontsize', fonts.title)
            %title('Gastrointestinal Feedforward Effect ($\gamma_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
            ylabel('$\gamma_{Kin}$', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
        end
        xlim([-420, 1020])
    end
    legend(labels, 'fontsize', fonts.legend)
end
end