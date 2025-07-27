function q_sig = how_many_sigs(cov, N)
%HOW_MANY_SIGS Summary of this function goes here
%   Detailed explanation goes here

%% DETECTION OF SIGNALS BY INFORMATION THEORETIC CRITERIA;  MDL(k)
ms = 20;
p = length(cov);
[V, D] = eig(cov);

MDL = @(k) k;

k = 1:ms;
mdl = MDL(k);
[minv, mind] = min(mdl);

q_sig = mind;

end

