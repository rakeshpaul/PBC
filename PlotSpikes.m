function PlotSpikes(sr, mp, ist, ost, dt, height )
%   PLOTSPIKES Plots Spike response and membrane potential of spiking
%   neuron
%   sr = spikeresonse
%   mp = membrane potential
%   ist = input spike times
%   height = height of the input spike representation

if nargin < 6
    height = 0.4;
end
if nargin < 5
    dt = 0.1;
end

MPmax = max(mp);
SRmax = max(sr);
plotcleft = 1.0;

Y = MPmax + plotcleft*3 + SRmax +height*4;
AXIS = [0 length(mp) 0 Y];

plot(mp);
axis(AXIS);
hold on;
grid on;

slen = length(ist);
for k = 1: slen
    x = [ist(k)/dt, ist(k)/dt];
    y = [(Y-1) (Y -(1-height)) ];
    line(x,y);
end;

Yaxis = MPmax + plotcleft;
olen = length(ost);
for k = 1: olen
    x = [ost(k)/dt, ost(k)/dt];
    y = [(Yaxis) (Yaxis +height) ];
    line(x,y);
end;


SR = sr + Yaxis + plotcleft + height*2;
mlen = length(mp);
for k = 1: slen
    clear X; clear Y;
    xlen = length(ist(k)/dt:mlen);
    X = ist(k)/dt: mlen;
    Y = SR(1:xlen);
    plot(X,Y, 'r');
end;
end

