function q_sig = how_many_sigs(E, Mb, N, upper_boundary)
%% 《DETECTION OF SIGNALS BY INFORMATION THEORETIC CRITERIA》信源数估计
% output:
%   q_sig:          scalar, how many signals est. for the input covMatrix.
% input:
%   E:              column_vector, eigenvalues of the sample-covariance matrix.
%   upper_boundary: scalar, for q_sig.

p = Mb;
E = sort(E, 'descend');

ratio2mean = @(k) geomean( abs(E(k+1 : p)) ) / ...
                     mean(     E(k+1 : p) );
%% 
AIC1 = @(k) -2*log((ratio2mean(k))^((p-k)*N)) +   2*k*(2*p-k);
MDL1 = @(k) -1*log((ratio2mean(k))^((p-k)*N)) + 1/2*k*(2*p-k)*log(N);

% power_exponential----multiple
AIC2 = @(k) -2*(p-k)*N*log((ratio2mean(k)))   +   2*k*(2*p-k);
MDL2 = @(k) -1*(p-k)*N*log((ratio2mean(k)))   + 1/2*k*(2*p-k)*log(N);

%%
mdl = zeros(upper_boundary,1);
for k = 1:upper_boundary
    mdl(k) = MDL2(k);
end
%
diff(mdl);
[min_value, min_point] = min(mdl);
q_sig = min_point;

end

