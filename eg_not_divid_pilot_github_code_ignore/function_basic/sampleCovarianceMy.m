function sampleCovarianceMatrix = sampleCovarianceMy(sampleMatrix)  % L-by-Mb matrix

% help cov
% If A is a matrix whose 【columns represent random variables】 and whose 【rows represent observations】, 
% C is the covariance matrix with the corresponding column variances along the diagonal.

cov1 = sampleMatrix*sampleMatrix';
y1 = zeros(L,Mb);
co = zeros(Mb,Mb,L);
for idc = 0:(-1+L)
    y1(idc+1,:) = yf2(idc+idr);
    t = y1(idc+1,:).';
    co(:,:,idc+1) = t*t';
end
sampleCovarianceMatrix = sum(co, 3);  % Mb-Mb matrix
end