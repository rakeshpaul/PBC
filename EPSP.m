function [ potential ] = EPSP( t, tau )
% Spike response function e(t) = (t/tau)e(1-t/tau)

% Set default delay
if nargin < 2, tau = 10; end

t(t<0) = 0;
eta = t/tau;
potential = eta.*exp(1-eta);
end
