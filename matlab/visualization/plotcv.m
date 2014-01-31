function plotcv(cvResult)
figure;
x = cellfun(@(x) x.param.nprincomp, cvResult);
y = cellfun(@(x) x.stat('VaError'), cvResult);
plot(x, y);
xlabel('number of principal components', 'FontSize', 14);
ylabel('validation frame error', 'FontSize', 14);
end