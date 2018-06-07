function hipp_roi_split(nii_mask_file, Nseg, save_dir)
% Takes in entire hippocampal ROI (nifti file) and creates anterior, middle, posterior
% thirds hippocampal ROIs based on coronal slices. Has option to 
% create anterior/posterior halves (default # of segments = 3). Can modify
% coronal_idx if orientation of file is not correct

seg_nms = {'Post';'Mid';'Ant'};

if nargin==1; Nseg = []; end
if isempty(Nseg); Nseg = 3; end

if Nseg==3;
    seg_nms = {'Post';'Mid';'Ant'};
elseif Nseg==2;
    seg_nms = {'AP2_Post';'AP2_Ant'};
end

[p, f, e] = fileparts(nii_mask_file);
if isempty(p); p = pwd; end
nii_file = glob([f e], p);
assert(~iscell(nii_file), ['Multiple files found: ' p ' ' f])

to_zip = 0;
if isempty(nii_file) || strcmp('.gz',e);

    nii_file = glob([f '*.gz'], p);
    unix(['gunzip ' nii_file])

    nii_file = glob([f '*'], p);
    [p, f, e] = fileparts(nii_file);
    to_zip = 1;
end
    
info = spm_vol(nii_file);
data = spm_read_vols(info);

[cs_idx(:,1), cs_idx(:,2), cs_idx(:,3)] = ind2sub(size(data),find(data>0));
coronal_idx = 2;

ap = [min(cs_idx(:, coronal_idx)) max(cs_idx(:, coronal_idx))];
Nap = length(ap(1):ap(2));
Nper = Nap/Nseg;
    
if nargin > 2;
    if ~ismember(save_dir, p);
        p = save_dir;
    end
end

nii = '.nii';
if ~strcmp(p(end), '/'); p = [p '/']; end

for iseg = 1:Nseg

    curr = [ap(1)+((iseg-1)*floor(Nper)) ap(1)+((iseg-1)*floor(Nper))+floor(Nper-1)];
    if iseg==3 && curr(2)<ap(2); curr(2)=ap(2); end
    cs = cs_idx(:,2)>=curr(1) & cs_idx(:,2)<=curr(2);

    blank = zeros(size(data));
    idx = find(cs);
    for iidx = 1:length(idx)
        c = idx(iidx);
        blank(cs_idx(c,1),cs_idx(c,2),cs_idx(c,3)) = 1;
    end
        
    new_file = [seg_nms{iseg} '_' f];
    new_roi_file = [p new_file nii];
    info.fname = new_roi_file;
    spm_write_vol(info, blank)
    clear blank;

end

if to_zip==1; unix(['gzip ' nii_file]); end
