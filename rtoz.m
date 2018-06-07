function [z] = rtoz(r)
z = .5*log((1+r)./(1-r));