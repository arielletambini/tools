function [xs,ys] = linregplotdata_robust_corrtext(x, y, weight_shade, ...
    bnd, mk, linecolor, dotcolor, linestyle)
% plots x versus y with fit information from robust regression (other
% inputs are optional)
% weight_shade sets if data point color is shaded based on its contribution
% to the regression (weights assigned from robustfit): 0 (off) or 1 (on)
% bnd is buffer space on axes beyond the individual data points (defaults
% to .1)
% mk = marker size (defaults to 20)
% line or dotcolor = rgb vector specifying line/dot color ([.6 0 0] is nice)
% linestyle specifies style, e.g. '-' for solid line
% outputs are x and y axis bounds

if nargin < 8; linestyle = [];
    if nargin < 7; dotcolor = [];
        if nargin < 6; linecolor = [];
            if nargin < 5; mk = [];
                if nargin < 4; bnd = []; 
                    if nargin < 3; weight_shade = []; end
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
if isempty(weight_shade); weight_shade = 0; end
if weight_shade==1; dotcolor = [.2 .3 1]; end

if weight_shade~=0 && weight_shade ~=1; error('Weight shade should be set to 0 or 1'); end

if sum(isnan(x))>0 || sum(isnan(y))>0;
    ind = ~isnan(x) & ~isnan(y);
    x = x(ind); y = y(ind);
end

[coeff,stats,r] = arobustfit(x,y);

slope_idx = 2;
mn = min(x)-bnd; 
mx = max(x)+bnd;
plot([mn mx],coeff(1)+(coeff(slope_idx)*[mn mx]),linestyle,'Color',linecolor,'LineWidth',1.5)
hold on; 

if weight_shade==0;
    plot(x,y,'.','MarkerSize',mk,'Color',dotcolor)
elseif weight_shade==1; 
    for j = 1:length(x)
        plot(x(j),y(j),'.','MarkerSize',mk,'Color',dotcolor*stats.w(j))
    end
end
xlim([mn mx])

if nargout > 0;
    xs = [mn mx];
    if nargout > 1;
        ys = coeff(2)+(coeff(1)*[mn mx]); 
    end    
end

xl = xlim;
yl = ylim;

% yl = [.9*min(y(:)) 1.08*max(y(:))];
% ylim(yl)
    
text(xl(1)+(diff(xl)*.03),yl(2)-(diff(yl)*.04),...
    ['r = ' num2str(around(r,4)) ' (p=' ...
    num2str(around(stats.p(slope_idx),4)) ')'],'FontSize',16)


function newstr = around(x,num)

if nargin==1; num=[]; end
if isempty(num); num=4; end
newstr = num2str(round(10^(num)*x)/(10^num));