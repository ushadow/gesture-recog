function viewhiddenstates(hmm, modelNDX)
mu3 = hmm.mu{modelNDX};
mu = cat(2, mu3{:});
figure;
viewonestage(mu);
end

function viewonestage(mu)
mu = mean(mu, 3);

for i = 1 : 2
  baseNDX = (i - 1) * 3;
  xyz = {mu(baseNDX + 1, :), mu(baseNDX + 2, :), mu(baseNDX + 3, :)};
  subplot(1, 2, i)
  plot3(xyz{:}, 'bx-');
  xlabel('x');
  ylabel('y');
  zlabel('z');
  % # labels correspond to their order

  labels = cellstr(num2str((1 : size(mu, 2))'));

  text(xyz{:}, labels, 'VerticalAlignment','bottom', ...
                               'HorizontalAlignment','right')
end
end
