function [ P ] = generatePopulation( spiketimes, pSize  )
%   Generates a neuronal population for given spike time
%   Creates a population of spiking neurons with specified size

% set the number of inputs
if nargin < 3
    nInputs =  length(spiketimes);
end;

% Bounded synaptic weights
a = 0.2;
b = 1.0;

% Create a population of spiking neurons
q(pSize) = SpikingNeuron();
delay  = zeros(nInputs,1);
sti = zeros(1,pSize);

% Initialize the neurons and population center
for k = 1:pSize
    spike = [];
    while isempty(spike)
        %[st I] = sort(spiketimes,1,'descend');
        wt = (a + (b-a).*rand(1,nInputs));
        q(k).InputSpikeDelays = delay;
        q(k).SynapticWeights = wt;
        spike = q(k).simulate(spiketimes);
        if isempty(spike)
            sti(k) = 0;
        else
            sti(k) = spike(1);
        end
    end;
end;
P = Population();
P.neurons = q;
P.center = sti;
end

