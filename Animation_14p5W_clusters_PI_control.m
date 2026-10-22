clear all

load model_domain.mat
load local_domain.mat
load('PI_control_clustering_201_400.mat', 'SigmaThetaMeans', 'PVlocMeans', 'LatArray_clustered', 'LonArray_clustered', 'gdept_0_clustered', 'Cs')

%%
mkdir Animation_Clusters_14p5W_PI_control
numClusters=7;
YearOffset=200;

% Reordering the cluster labels for the PI control simulation changes
% nothing because the clusters are already labeled consistently.
% LatArray_clustered0=reorder_fun(SigmaThetaMeans,PVlocMeans,LatArray_clustered);
% LonArray_clustered0=reorder_fun(SigmaThetaMeans,PVlocMeans,LonArray_clustered);
% gdept_0_clustered0=reorder_fun(SigmaThetaMeans,PVlocMeans,gdept_0_clustered);


ColorScheme=[    0.6667    0.2667    0.6000
    0.9333    0.4667    0.2000
    0.8000    0.2000    0.0667
    0.8667    0.8784    0.4667
    0    0.6000    0.5333
    0.2000    0.1333    0.5333
    0.2000    0.7333    0.9333];


DisplayNames={...
    'Subtropical Mode Water',...
    'STW',...
    'SAMW',...
    'AAIW',...
    'UCDW',...
    'LCDW',...
    'AABW' ...
    };


for Year=1:length(Cs)

    % Create figure
    figure('OuterPosition',...
        [573 87.6666666666667 574.666666666667 507.333333333333]);

    % Create axes
    axes1 = axes('Position',[0.108327380952381 0.11 0.6 0.8]);
    hold(axes1,'on');
    % Create ylabel
    ylabel({'Depth [m]'});

    % Create xlabel
    xlabel({'Degrees Latitude'});

    % Create title
    title({'Section along 14.5^oW in the Preindustrial Clim.'});

    box(axes1,'on');
    grid(axes1,'on');
    axis(axes1,'ij');
    hold(axes1,'off');
    % Set the remaining axes properties
    set(axes1,'FontName','Arial','FontSize',11);
    % Create legend
    legend1 = legend(axes1,'show');
    set(legend1,'Location','southwest','LineWidth',1);
    ylim([200 3000])

    hold on

    for ClusterSel=1:numClusters
        X=LatArray_clustered{ClusterSel, Year}; Z=LonArray_clustered{ClusterSel, Year}; Y=gdept_0_clustered{ClusterSel, Year};
        Ysel=Y(-15<Z & Z <-14);
        Xsel=X(-15<Z & Z <-14);
        % Create plot
        plot(Xsel,Ysel,'DisplayName',DisplayNames{ClusterSel},'MarkerSize',8,...
            'Marker','*',...
            'LineWidth',2.5,...
            'LineStyle','none',...
            'Color',ColorScheme(ClusterSel,:));
        hold on
    end
    set(gca, 'ydir', 'reverse')

    saveas(gcf, strcat('Animation_Clusters_14p5W_PI_control\April_PIctrl_Clusters_Along_14p5W_Year_',num2str(YearOffset+Year)), 'png')
    hold off
    close all

end
