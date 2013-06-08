function MS = show_circle_stip( M, features, labels, stepflag, i1, i2, linewidth, outputpath)
%MS = show_circle_stip( M, features, labels, stepflag, i1, i2, linewidth, outputpath)
% M --              A Matlab movie.
% features --       The position part of the STIP features
% labels --         Labels for features, which are then mapped to a
%                   different color code.
% stepflag --       If 1, steps frame by frame
% i1:i2 --          Range of frames displayed
% linewidth --      Line widthe for the circles
% outputpath --        Save single frames to 'outputpath'
% 
%   displays movie M with spatio-temporal
%   features=[x,y,t,sx,st] drawn by circles with colors fcol=[r,g,b];
%
% Returns:
% MS --             A movie with STIP features ovelaid.

%   Code adapted from Ivan Laptev: http://www.di.ens.fr/willow/events/cvml2010/materials/practical-laptev/

if nargin<3 || isempty(labels), labels=ones(1,size(features,1)); end
if length(labels)==1, labels=labels*ones(1,size(features,1)); end
  
%ccol=hsv(length(unique(labels)));
ccol=hsv(max(labels(:)));
fcol=ccol(labels(:),:);
  


if nargin<4 || isempty(stepflag), stepflag=0; end
if nargin<5 || isempty(i1), i1=1; end
if nargin<6 || isempty(i2) 
  if i1>1 
      i2=i1; 
  else
      i2=length(M);
  end
end
if i1<0 || i2<0 i1=1; i2=length(M); end
if nargin<7; linewidth=3; end
if nargin<8, outputpath=[]; end

h=figure; hold on

for i=i1:i2 

    clf
    imagesc(M(i).cdata);
    showcirclefeaturesframe_xyt(i,features,fcol,linewidth)
    title(sprintf('frame %d of %d',i,length(M)), 'FontSize', 16, 'FontWeight', 'bold');
    if stepflag
      st=input('Next [y/n]? ', 's');
      if strcmp(st , 'n'), MS=[]; return; end
    end

    if nargout>0
        MS(i)=getframe(h);
    else
        pause(0.01);
    end

    if ~isempty(outputpath) % save single frames to 'outputpath'
      fh=figure(gcf);
      printed_size = 100; % centimeters
      set(gca,'Position',[0 0 1 1])
      set(gcf,'PaperSize',[4 4]);
      title('')
      imgfname=sprintf('%s/frame_%03d.bmp',outputpath,i);
      fprintf('%s\n',imgfname);
      print('-dbmp',imgfname)
      eval(['!convert -crop 0x0 ' imgfname ' ' imgfname]);
    end

end




