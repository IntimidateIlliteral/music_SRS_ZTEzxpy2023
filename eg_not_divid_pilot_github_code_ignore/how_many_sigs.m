function q_sig = how_many_sigs(covMatrix, Mb, N, impossible_more_than)
%HOW_MANY_SIGS Summary of this function goes here
%   Detailed explanation goes here
%% DETECTION OF SIGNALS BY INFORMATION THEORETIC CRITERIA;  MDL(k)
p = Mb;
E = eig(covMatrix);
E = sort(E, 'descend');

ratio2mean = @(k) geomean( abs(E(k+1 : p)) ) / ...
                     mean(     E(k+1 : p) );

MDL1 = @(k) -1*log((ratio2mean(k))^((p-k)*N)) + 1/2*k*(2*p-k)*log(N);
% power_exponential----multiple
MDL2 = @(k) -1*N*(p-k)*log((ratio2mean(k))) + 1/2*k*(2*p-k)*log(N);
% log(e) = 1 = ln(e);

ms = impossible_more_than; 
mdl = zeros(ms,1);
for k = 1:ms
    mdl(k) = MDL2(k);
end

mdl
[minv, mind] = min(mdl);

q_sig = mind;

end

