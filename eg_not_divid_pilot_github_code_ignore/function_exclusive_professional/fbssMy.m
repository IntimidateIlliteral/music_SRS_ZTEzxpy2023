function yf2_fbss = fbssMy(...
    yf2,...  % 1-by-M0 row vector,  array samples
    L)       % scalar,              how many sub_arrays   

    M0 = length(yf2);  % array
    Mb = M0 - L + 1;   % one sub_array
    idc = (0:(L-1)).';
    idr = 1:Mb;
    id = idc+idr;

    % Mb-by-Mb matrix
    yf2_fbss = yf2(id);
end