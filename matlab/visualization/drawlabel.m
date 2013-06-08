function drawlabel(Y, R)
%%
% Args:
% - Ytrue: one sequence

split = R.split;
Ytrue = Y{split{2}};
nframe = size(Ytrue, 2);
Ytrue = cell2mat(Ytrue(1, :));
R = cell2mat(R.prediction.validate{1});
plot(1 : nframe, Ytrue, 1 : nframe, R, '--r');
axis([0 nframe 0 max(Ytrue) + 1]);
set(gca, 'YTick', unique(Ytrue));
set(gca,'yticklabel', {'P', 'R', 'NC'});
xlabel('time frame', 'FontSize', 12);
ylabel('gesture phase label', 'FontSize', 12);
legend('ground truth', 'predicted');
end