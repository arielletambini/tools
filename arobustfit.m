function [ b, stats, r, Rsq ] = arobustfit( X, y )
% robust fit wrapper that outputs correlation value (r) and Rsquared
% correlation value (r) is correct if one predictor is provided in X
% X is columnwise matrix of predictors (just 1 column to evaluate r)
% y is observations to be predicted by X

idx = sum(isnan(X),2)==0 & isnan(y)==0;

[b, stats] = robustfit(X, y);
sse = stats.dfe * stats.robust_s^2;
phat = b(1) + b(2:end)'*X(idx,:)';
ssr = norm(phat-mean(phat))^2;
Rsq = 1 - sse / (sse + ssr);
r = sqrt(Rsq) * sign(stats.t(end));

% https://www.mathworks.com/matlabcentral/answers/93865-how-do-i-compute-the-r-square-statistic-for-robustfit-using-statistics-toolbox-7-0-r2008b
% above Rsquared is also equivalent to Rsq = t^2 / (t^2 + dfe)

end

