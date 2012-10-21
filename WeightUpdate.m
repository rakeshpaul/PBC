function [ dw ] = WeightUpdate( to, tin, wt )
% WEIGHTUPDATE STDP based Hebbian learning
% Find the new weights after applying STDP

Ta = 10;
Tb = 10;
A = 2.0;
n = 0.005;
wMax = 1.0;
wMin = 0.0;

s = to-tin;
len = length(s);
dw = zeros(1,len);
for k=1:len
    value = s(k);
    if value > 0
        nwt = wt(k) + (n*exp(value/Tb));
        dw(k) =  min(wMax, nwt);
    elseif value < 0
        nwt = wt(k) + (-A*n*exp(-value/Ta));
        dw(k) =  max(wMin,nwt);
    end;
end;
end

