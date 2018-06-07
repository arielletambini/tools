function [p, diff_true, sim_diff] = perm_test(x, y, paired, Nsim, Ntails)
% compare data in x and y, get p-value out
% paired: 1 = paired, 2 = unpaired, 3 = correlation
% Nsim = 10000 by default, Ntails = 2 (two-tailed test)

if nargin < 5; Ntails = 2; end
if nargin < 4; Nsim = []; end

if isempty(Nsim); Nsim = 10000; end

if paired==1;
    
    idx = ~isnan(x-y);
    x = x(idx);
    y = y(idx);
    
    assert(length(x)==length(y))
    diff_true = mean(x-y);
    Ns = length(x);
    
    data = [reshape(x,length(x),1) reshape(y,length(y),1)];
    
    sim_diff = NaN(Nsim,1);
    for isim = 1:Nsim
    
        temp = NaN(Ns,1);
        for iss = 1:Ns
           
            idx = randperm(2);
            temp(iss) = data(iss,idx(1)) - data(iss,idx(2));
            
        end
        sim_diff(isim) = mean(temp);
        
    end
    
    p = np_test(sim_diff, diff_true, Ntails);
    
elseif paired==2;
    
    x = x(~isnan(x));
    y = y(~isnan(y));
    
    diff_true = mean(x) - mean(y);
   
%     assert(size(data,2)==2)
    Ns = [length(x) length(y)];
    data = cat(1,reshape(x,length(x),1),reshape(y,length(y),1));
    Ntot = length(data);
    
    sim_diff = NaN(Nsim,1);
    for isim = 1:Nsim
    
        reshuff = randperm(Ntot);
        sim_diff(isim) = mean(data(reshuff(1:Ns(1)))) - mean(data(reshuff(Ns(1)+1:end)));
        
    end
    
    p = np_test(sim_diff, diff_true, Ntails);
    
elseif paired==3; %robust regression

    x = x(~isnan(x));
    y = y(~isnan(y));
    
    coeff_true = robustfit(x,y);
    diff_true = coeff_true(2);
    
    sim_diff = NaN(Nsim,1);

    for isim = 1:Nsim
        jnk = randperm(length(x));
        out = robustfit(x(jnk),y);
        
        sim_diff(isim,1) = out(2); 
        clear out
    end

end
    
p = np_test(sim_diff, diff_true, Ntails);

