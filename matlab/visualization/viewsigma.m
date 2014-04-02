function viewsigma(sigma1, sigma2)
sigma = cat(3, sigma1, sigma2);
sigma = normalise(sigma, 3);
figure;
imagesc(sigma(:, :, 1));
set(gca, 'FontSize', 14);
colormap(flipud(hot));
figure;
imagesc(sigma(:, :, 2));
set(gca, 'FontSize', 14);
colormap(flipud(hot));
end