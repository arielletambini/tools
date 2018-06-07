function abar_dat(dat,x,barclr,barwidth)
% creates bar plot w error bars of the data in dat
% dat is columnwise data

mn = nanmean(dat);
sem = nanstd(dat)./sqrt(sum(~isnan(dat)));

if nargin>1;
    if isempty(x); x = 1:length(mn); end
    if nargin>3;
        if isempty(barclr);
            bar(x,mn,barwidth)
        else
            if ischar(barclr);
                bar(x,mn,barwidth,barclr);
            else
                bar(x,mn,barwidth,'FaceColor',barclr);
            end
        end
    elseif nargin>2; 
        bar(x,mn,'FaceColor',barclr); 
    else bar(x,mn); 
    end
    hold on;
    errorbar(x,mn,sem,'k','LineStyle','none','LineWidth',3)
else bar(mn); hold on
    errorbar(mn,sem,'k','LineStyle','none','LineWidth',3)
end