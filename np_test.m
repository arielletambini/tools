function Pval = np_test(sim_data, true_data, Ntails)
% Compare true_data value to the distribution of values in sim_data, output
% is P-value. Meant to be used for non-parametric significance test, where
% sim_data is generated via permutation shuffles (see perm_test). 
% Ntails=2 by default (two-tailed test).

if nargin < 3;
    Ntails = [];
end

if isempty(Ntails) || Ntails==2;
    factor = 2;
elseif Ntails==1; factor = 1;
end

if true_data > mean(sim_data);
    Pval = factor * mean(squeeze(sim_data) >= true_data);
elseif true_data < mean(sim_data);
    Pval = factor * mean(squeeze(sim_data) <= true_data);
end