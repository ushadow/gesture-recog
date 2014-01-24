function viewtransition(hmm)
FONT_SIZE = 14;

totalNStates = length(hmm.prior);
n = 7;
figure;
subplot(1, n, 1);
imagesc(1, 1 : totalNStates, hmm.prior);
set(gca, 'XTick', 1);
xlabel('prior', 'FontSize', FONT_SIZE);

subplot(1, n, 2 : n - 1);
imagesc(hmm.transmat);
xlabel('transition', 'FontSize', FONT_SIZE);

subplot(1, n, n);
imagesc(1, 1 : totalNStates, hmm.term);
set(gca, 'XTick', 1);
xlabel('termination', 'FontSize', FONT_SIZE);

colormap(flipud(hot));
end