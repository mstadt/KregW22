function plot_Preston_exp(T, X, params, Kin_opts)
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
plt_amt = 1;
plt_con = 1;
plt_PhiKin = 1;
plt_flux = 0;
plt_effects = 1;
plt_kidney = 1;
plt_ALD = 1;
plt_exp = 1;
plt_uK_sum = 0;

% fontsizes
fonts.title = 15;
fonts.xlabel = 15;
fonts.ylabel = 15;
fonts.legend = 15;

markersize = 15;

labels = {'Meal (insulin only)', 'KCL (FF only)', 'Meal + KCL (insulin + KCL)'};

%% plot Phi_Kin
if plt_PhiKin
    PhiKin_vals1 = zeros(size(T{1}));
    for ii = 1:length(T{1})
        [PhiKin_vals1(ii), ~] = get_PhiKin(T{1}(ii), 0, params{1}, Kin_opts{1});
    end % for ii
    PhiKin_vals2 = zeros(size(T{2}));
    for ii = 1:length(T{2})
        [PhiKin_vals2(ii), ~] = get_PhiKin(T{2}(ii), 0, params{2}, Kin_opts{2});
    end %for ii
    PhiKin_vals3 = zeros(size(T{3}));
    for ii = 1:length(T{3})
        [PhiKin_vals3(ii), ~] = get_PhiKin(T{3}(ii), 0, params{3}, Kin_opts{3});
    end %for ii
    figure(99)
    plot(times1, PhiKin_vals1, 'linewidth', 2, 'color', c1)
    hold on
    plot(times2, PhiKin_vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
    plot(times3, PhiKin_vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
    xlabel('time (mins)', 'fontsize', fonts.xlabel)
    ylabel('$\Phi_{Kin}$ (mEq/min)', 'interpreter', 'latex', 'fontsize', fonts.ylabel)
    title('$K^+$ intake ($\Phi_{Kin}$)', 'interpreter', 'latex', 'fontsize', fonts.title)
    legend(labels, 'fontsize', fonts.legend)
    xlim([-exp_start, 900])
    hold off
end

%% amounts
if plt_amt
    figure(1)
    plot_these = {1,2,...
                    3, 4 ,...
                    'totalECF','totalbodyK'};
    for ii = 1:6
        s = subplot(3,2, ii);
        if strcmp(plot_these{ii}, 'totalECF')
            vals1 = X{1}(:, 2) + X{1}(:, 3);
            vals2 = X{2}(:, 2) + X{2}(:,3);
            vals3 = X{3}(:, 2) + X{3}(:,3);
        elseif strcmp(plot_these{ii}, 'totalbodyK') % not including gut
            vals1 = X{1}(:, 2) + X{1}(:,3) + X{1}(:,4);
            vals2 = X{2}(:,2) + X{2}(:,3) + X{2}(:,4);
            vals3 = X{3}(:,2) + X{3}(:,3) + X{3}(:, 4);
        else
            vals1 = X{1}(:, plot_these{ii});
            vals2 = X{2}(:, plot_these{ii});
            vals3 = X{3}(:, plot_these{ii});
        end
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        ylabel('mEq', 'fontsize', fonts.ylabel)
        if strcmp(plot_these{ii}, 'totalECF')
            title('Total ECF K', 'fontsize', fonts.title)
            ylim([50, 70])
        elseif strcmp(plot_these{ii}, 'totalbodyK')
            title('Total body K', 'fontsize', fonts.title)
            %ylim([2750, 3000])
        elseif plot_these{ii} == 4
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
            %ylim([2750, 3000])
        elseif plot_these{ii} == 2
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
            ylim([15, 25])
        elseif plot_these{ii} == 3
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
            ylim([35, 50])
        else
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end
        xlim([-exp_start, 1000])
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end

%% concentrations
if plt_con
    plot_these = {5,6,7,8};
    figure(10)
    for ii = 1:4
        s = subplot(2,2, ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:,plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start,1000])
        if plot_these{ii} == 8
            ylim([135, 160])
        elseif ismember(plot_these{ii}, [5,6,7])
            ylim([3.3, 5.5])
        end
%         if ismember(plot_these{ii}, [9,10])
%             ylim([135, 145])
%         elseif plot_these{ii} == 11
%             ylim([110, 125])
%         elseif ismember(plot_these{ii}, [6,7,8])
%             ylim([3.0, 5.0])
%         end
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end 


%% fluxes
if plt_flux
    figure(2)
    plot_these = {9, 13, 14};
    for ii = 1:3
        s = subplot(2,2,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'fontsize', fonts.ylabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start, 1440])
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end

%% effects
if plt_effects
    figure(3)
    plot_these = {10, 11, 12, 20, 21, 25,33};
    for ii = 1:7
        s = subplot(3,3,ii);
        vals1 = X{1}(:,plot_these{ii});
        vals2 = X{2}(:,plot_these{ii});
        vals3 = X{3}(:, plot_these{ii});
        plot(s, times1, vals1, 'linewidth', 2, 'color', c1)
        hold on
        plot(s, times2, vals2, 'linewidth', 2, 'color', c2, 'linestyle', '--')
        plot(s, times3, vals3, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start, 1200])
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end


%% kidney
if plt_kidney
    figure(4)
    plot_these = {15, 16, 17, 18, 22, 23, 24, 'CDKtrans', 28};
    for ii = 1:9
        s = subplot(3,3, ii);
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
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        ylabel('mEq/min', 'fontsize', fonts.ylabel)
        if strcmp(plot_these{ii}, 'CDKtrans')
            title('Net CD K transport', 'fontsize', fonts.title)
        else
            title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        end
        xlim([-exp_start, 1200])
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end

%% ALD
if plt_ALD
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
        xlabel('time (mins)', 'fontsize', fonts.xlabel)
        title(varnames{plot_these{ii}}, 'fontsize', fonts.title)
        xlim([-exp_start, 1200])
        hold off
    end
    legend(labels, 'fontsize', fonts.legend)
end

%% compare simulations to experiment data
if plt_exp
    data = load('./Data/PrestonData.mat');
    % plot serum [K+] data
    figure(25)
    vals1 = X{1}(:,5);
    vals2 = X{2}(:,5);
    vals3 = X{3}(:,5);
    data_times = data.time_serum;
    plot(times1, vals1, 'linewidth', 2, 'color' ,c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'linestyle', '--', 'color', c2)
    plot(times3, vals3, 'linewidth', 2, 'linestyle', '-.', 'color', c3)
    
    plot(data_times, data.Meal_serum_scaled, '.', 'markersize', markersize, 'color', c1)
    plot(data_times, data.KCL_serum_scaled, '.', 'markersize', markersize, 'color', c2)
    plot(data_times, data.MealKCL_serum_scaled, '.', 'markersize', markersize, 'color', c3)
    
    xlabel('time (mins)')
    ylabel('mEq/L')
    ylim([3.5, 5.0])
    title('Plasma concentration')
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', fonts.legend)
    hold off
    
    % plot UK data
    figure(26)
    vals1 = X{1}(:,28);
    vals2 = X{2}(:,28);
    vals3 = X{3}(:,28);
    data_times = data.time_UK;
    plot(times1, vals1, 'linewidth', 2, 'color' ,c1)
    hold on
    plot(times2, vals2, 'linewidth', 2, 'linestyle', '--', 'color', c2)
    plot(times3, vals3, 'linewidth', 2, 'linestyle', '-.', 'color', c3)
    
    plot(data_times, data.Meal_UK_scaled, '.', 'markersize', markersize, 'color', c1)
    plot(data_times, data.KCL_UK_scaled, '.', 'markersize', markersize, 'color', c2)
    plot(data_times, data.MealKCL_UK_scaled, '.', 'markersize', markersize, 'color', c3)
    
    xlabel('time (mins)')
    ylabel('mEq/min')
    title('Urinary K excretion')
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', fonts.legend)
    hold off
end %plt_exp

if plt_uK_sum
    disp('Warning: Cumulative uK may be off from Preston because my uK excretion is scaled.')
    data = load('./Data/PrestonData.mat');
    vals1 = X{1}(:,28);
    vals2 = X{2}(:,28);
    vals3 = X{3}(:,28);
    exp_start_idx1 = find(T{1} == exp_start);
    exp_end_idx1 = find(T{1} == exp_start + 300);
    exp_start_idx2 = find(T{2} == exp_start);
    exp_end_idx2 = find(T{2} == exp_start + 300);
    exp_start_idx3 = find(T{3} == exp_start);
    exp_end_idx3 = find(T{3} == exp_start + 300);
    % cumulative urine excretion over the experiment
    uK_Meal = vals1(exp_start_idx1:exp_end_idx1);
    uK_KCL = vals2(exp_start_idx2:exp_end_idx2);
    uK_MealKCL = vals3(exp_start_idx3:exp_end_idx3);
    
    Meal_sum = zeros(size(uK_Meal));
    KCL_sum = zeros(size(uK_KCL));
    MealKCL_sum = zeros(size(uK_MealKCL));
    
    for ii = 1:length(Meal_sum)
        Meal_sum(ii) = sum(uK_Meal(1:ii));
        KCL_sum(ii) = sum(uK_KCL(1:ii));
        MealKCL_sum(ii) = sum(uK_MealKCL(1:ii));
    end
    
    times = linspace(0, 300, length(Meal_sum));
    figure(50)
    plot(times, Meal_sum, 'linewidth', 2, 'color', c1)
    hold on
    plot(times, KCL_sum, 'linewidth', 2, 'color', c2, 'linestyle', '--')
    plot(times, MealKCL_sum, 'linewidth', 2, 'color', c3, 'linestyle', '-.')
    plot(data.time_sumUK, data.Meal_sumUK, '.', 'markersize', markersize, 'color', c1)
    plot(data.time_sumUK, data.KCL_sumUK, '.', 'markersize', markersize, 'color', c2)
    plot(data.time_sumUK, data.MealKCL_sumUK, '.', 'markersize', markersize, 'color', c3)
    xlabel('experiment time (mins)', 'fontsize', fonts.xlabel)
    ylabel('Cumulative excretion of K (mEq)', 'fontsize', fonts.ylabel)
    title('Cumulative urinary K excretion', 'fontsize', fonts.title)
    legend(labels{1}, labels{2}, labels{3}, 'fontsize', fonts.legend)
    hold off
end % end plt_uK_sum
end