function [ output_args ] = fftModelAnalysis( modelfile, artist, nbit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% load model
m = load(modelfile);

%% step 1: generating grid plot for the images
img = zeros(120, 240);
img(m.I_top) = 1;
img = [zeros(120, 1) img];
colormap(flipud(gray));
imagesc(img(1 : size(img, 1) / 2, :));
colorbar
title('Selected Bits (in black)');
saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'sb.png'));
close(gcf);

% %% step 2: distribution of top 16 features
for i = 1 : 16
    subplot(4,4,i);
    histogram(m.agg_top(i, 1, :));
end
saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'distb.png'));
close(gcf);

%% step 3: show variance by magnitude
stem(m.var_agg(m.I_top));
title('Variance of top variance');
saveas(gcf, strcat('./analysis/', artist, '_', num2str(nbit), 'var.png'));
close(gcf);

end

