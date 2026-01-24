function jidazhidian = findJiDaZhiDianMy(pm)
% findpeaks()
dpm = diff(pm);  % derivative

l = length(dpm);

t = 1:(l-1);

dpm = (dpm(t)>0) .* (dpm(t+1))<0;  % parentheses

jidazhidian = 1 + find(dpm==1);

end