function [xs,ys] = linregplotdata_corrtext(x, y, to_rank, bnd, mk, ...
    linecolor, dotcolor, linestyle)

% plots x versus y with fit information from regression
% bnd is buffer space on axes beyond the individual data points (defaults
% to .1)
% mk = marker size (defaults to 20)
% to_rank specifies whether or not to use rank (Spearman rank) correlation
% rather than linear regression/Pearson correlation (default)
% line or dotcolor = rgb vector specifying line/dot color ([.6 0 0] is nice)
% linestyle specifies style, e.g. '-' for solid line
% outputs are x and y axis bounds

if nargin < 8; linestyle = [];
    if nargin < 7; dotcolor = [];
        if nargin < 6; linecolor = [];
            if nargin < 5; mk = [];
                if nargin < 4; bnd = []; 
                    if nargin < 3; to_rank = []; end
                end
            end
        end
    end
end

if isempty(bnd); bnd = .1; end
if isempty(mk); mk = 20; end
if isempty(linecolor); linecolor = [.6 0 0]; end
if isempty(linestyle); linestyle = '--'; end
if isempty(dotcolor); dotcolor = [.2 .2 .8]; end
if isempty(to_rank); to_rank = 0; end

if sum(isnan(x))>0 || sum(isnan(y))>0;
    ind = ~isnan(x) & ~isnan(y);
    x = x(ind); y = y(ind);
end

coeff = polyfit(x,y,1);
mn = min(x)-bnd; 
mx = max(x)+bnd;
plot([mn mx],coeff(2)+(coeff(1)*[mn mx]),linestyle,'Color',linecolor,'LineWidth',1.5)
hold on; plot(x,y,'.','MarkerSize',mk,'Color',dotcolor)
xlim([mn mx])

if nargout > 0;
    xs = [mn mx];
    if nargout > 1;
        ys = coeff(2)+(coeff(1)*[mn mx]); 
    end    
end

if to_rank==0;
    [r,p]=corr(x,y); % Pearson by default
elseif to_rank==1;
    [r,p]=corr(x,y,'type','Spearman');
end

xl = xlim;
yl = ylim;

text(xl(1)+(diff(xl)*.03),yl(2)-(diff(yl)*.04),...
    ['r = ' num2str(around(r,4)) ' (p=' ...
    num2str(around(p,4)) ')'],'FontSize',16)