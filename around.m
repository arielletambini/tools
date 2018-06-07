function newstr = around(x,num)

if nargin==1; num=[]; end
if isempty(num); num=4; end
newstr = num2str(round(10^(num)*x)/(10^num));