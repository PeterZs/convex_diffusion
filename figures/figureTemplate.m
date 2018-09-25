%% This scripts reads input parameters and resulting metrics values from 
% several files from a parameter evaluation output folder and generates a
% figure which is stored in several file formats


%% Initialize
clear
close all
addpath(genpath('.'));
inFolder = '../Trunk/output/Fig6/';
range = reshape(1:60,6,10).';
fieldX = 'nrSmpl';
fieldY = 'metrics.dnr.all';


%% Read input
x = cell2mat(readValues(inFolder, range, fieldX));
y = cell2mat(readValues(inFolder, range, fieldY));
Legend = {'Zero-filling','1D-Interpolation','2D-Interpolation', ...
          'Conj. Grad. (spatial TV)','Conj. Grad. (FT)','Soft-Tresh. (FT)'};


%% Generate plots
set(groot,'defaultAxesColorOrder','remove');
cm = get(groot,'defaultAxesColorOrder');
set(groot,'defaultAxesColorOrder',[0 0 0; cm([3 1 2 5 7],:)]);
figure, h = plot(x,y,'-s');

set(h,'Linewidth',3,'MarkerSize',4);

set(gca,'TickDir','out', ...
        'Box','off', ...
        'FontSize',20, ...
        'LineWidth',3);
    
set(gcf,'Renderer','Painters', ...
        'PaperPositionMode','auto', ...
        'Position', [6 6 1000 860], ...
        'InvertHardcopy','on');

title({'a                                  Sampling rate                                   ', ...
       ['Coils: ', num2str(cell2mat(readValues(inFolder,1,'nrCoil'))), ...
       '  |  Respiratory Bins: ', num2str(cell2mat(readValues(inFolder,1,'nrState')))]});
   
xlabel('Number of Samples');
ylabel('Displacement-to-Noise Ratio');
ylabel(['Displacement-to-Noise Ratio (DNR_{full} = ' num2str(cell2mat(struct2cell(load('dnrFull.mat','all'))),'%1.2f)')]);


%% Save plot
fileName = '../Trunk/figures/Fig6/Figure 6a';
print('-depsc2','-tiff',[fileName '.eps']);
saveas(gcf,[fileName '.png']);
savefig([fileName '.fig']);
close(gcf);