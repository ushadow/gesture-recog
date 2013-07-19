function h = imdisplay(im, varargin)
%h = imdisplay( im, h, ttl )
% Display grayscale images.

% Isabelle Guyon -- isabelle@clopinet.com -- April 2012

ttl = ' ';
xLabel = ' ';
yLabel = ' ';

for i = 1 : 2 : length(varargin)
  switch varargin{i}
    case 'ttl'
      ttl = varargin{i + 1};
    case 'xlabel'
      xLabel = varargin{i + 1};
    case 'ylabel'
      yLabel = varargin{i + 1};
  end
end

h = figure;

[ISKINECT, im]=is_depth(im);

if isa(im, 'double')
    mini=min(im(:));
    maxi=max(im(:));
    im=(im-mini)./(maxi-mini);
end
imagesc(im); % data is scaled.

if ISKINECT
    colormap(flipud(hot));
    colorbar;
end

title(ttl, 'Fontsize', 16, 'FontWeight', 'bold'); 
xlabel(xLabel, 'Fontsize', 16);
ylabel(yLabel, 'Fontsize', 16);