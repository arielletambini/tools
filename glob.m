function X = glob(str, dirname, convert_to_cell)
% functions similarly to ls (using a wildcard*) and glob in python
% str can be any string, either a full path to the desired file(s) or the
% string corresponding to the name of file (without full path). If no path
% is provided in str, can be given in dirname or is assumed to be the
% current directory

if nargin==1;
    d = dir(str);
    [p] = fileparts(str);
    
    if isempty(p); dirname = [pwd '/']; 
    else dirname = p; 
    end
else    
    if isempty(strmatch(dirname(end),'/'));%==1;
        dirname = [dirname '/'];
    end
    
    d = dir([dirname str]);
    
    if nargin < 3; convert_to_cell = 0; end    
end

if ~isempty(d);
    [X{1:length(d)}] = deal(d.name);
    X = X';
    if length(X)==1;
        X = [dirname X{1}];
        if convert_to_cell==1;
            Out{1} = X; clear X;
            X = Out; clear Out;
        end
    else
        for irow = 1:length(X)
            X{irow} = [dirname X{irow}];
        end
    end
else
    warning('No desired files in directory')
    X = {};
end
    