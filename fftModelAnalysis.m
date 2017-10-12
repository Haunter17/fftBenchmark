function [ output_args ] = fftModelAnalysis( modelfile, artist, nbit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% load model
m = load(modelfile);

%% step 1: generating grid plot for the images
img = zeros(60, 10);
img(m.I_top) = 1;
colormap(flipud(gray));
imagesc(img);
colorbar
title('Selected Bits (in black)');
saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'sb.png'));
close(gcf);

% % %% step 2: distribution of top 16 features
% for i = 1 : 16
%     subplot(4,4,i);
%     histogram(m.agg_top(i, 1, :));
% end
% saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'distb.png'));
% close(gcf);

%% step 3: show variance by magnitude
stem(m.var_agg(m.I_top));
title('Variance of top variance');
saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'var.png'));
close(gcf);

%% step 4: show top filters
for i = 1 : 8
    subplot(4, 4, 2 * i - 1);
    filter_real = reshape(m.filters(:,2 * i - 1), 121, []);
    colormap(jet);
    imagesc(filter_real);
    
    subplot(4, 4, 2 * i);
    filter_im = reshape(m.filters(:, 2 * i), 121, []);
    imagesc(filter_im);
end
saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'filters.png'));
close(gcf);

