% Simulate the evolution of Membrane potential of a SRM based spiking
% neuron
clear; clf;

% Constants
tau = 3;                    % time constant of spike response function
delay = 0;%randi(10,1,1);	% default synaptic delay
time = 0;                   % start time
dt = 0.1;                   % integration time interval
Tmax = 100;                 % maximum time of integration
threshold = 1.2;            % Spike threshold
rp =0;                      % absolute refractory period

%
len = length(time:0.1:Tmax);
spiketimes = [11  26 30:3:40 49 74];
weight = ones(1,length(spiketimes));
ost = [];
lastspike = Inf;
u = zeros(1,len);
v = zeros(1,len);

for k = 2:len
    time = time + dt;
    v(k) = EPSP(time,tau);
    resting = (lastspike ~= Inf && (lastspike < time) &&  (time <  (lastspike + rp)));
    if resting
        mp = 0;
    else
        if lastspike == Inf
            effectivespikes = spiketimes;
        else
            effectivespikes = spiketimes;
            effectivespikes(effectivespikes < (lastspike + rp)) = time;
        end
        t_ = time - effectivespikes;
        dV = EPSP(t_,tau);
        mp = sum(weight*dV');
    end
    u(k) = mp;
    if mp > threshold
        lastspike = time;
        if isempty(ost)
            ost(1) = time;
        else
            ost(end+1) = time;
        end;
    end;
end

% Plot the membrane potential and spike reponse function for inputs
PlotSpikes(v,u,spiketimes, ost);
line([0 len], [threshold, threshold]);

