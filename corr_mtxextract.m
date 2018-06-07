function [r_full, r_ext, p_full, p_ext] = corr_mtxextract(mtx)
% extracts unique elements in correlation matrix (r_ext) and significance
% values (p_ext), also outputs full matrix (r_full)
% mtx is columnwise data matrix

[r_full,p_full] = corr(mtx);

ud = triu(r_full,1);
udall = ud(:);
r_ext = udall(udall~=0);

if nargout > 3;
    ud = triu(p_full,1);
    udallp = ud(:);
    p_ext = udallp(udall~=0);
end