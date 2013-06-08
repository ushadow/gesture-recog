function plotinferencecomp
L = [0 1 2 4 8 16];
accuracy = [52.3 55.7 58.6 64.6 69.5 72.3];
plot(L, accuracy, L, ones(1, 6) * 74.6, 'r');
ylabel('average F1 score %', 'FontSize', 12);
xlabel('lag / frames', 'FontSize', 12);
axis([0, 16, 50, 76]);
legend('Fixed-lag smoothing', 'Fixed interval smoothing');
end