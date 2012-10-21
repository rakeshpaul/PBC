classdef SpikingNeuron < handle
    % SPIKINGNEURON 
    % Object oriented implementation of a Spike Response Model based 
    % spiking neuron
    
    properties
        InputSpikeDelays = [];
        SynapticWeights = [];
    end
    methods
        function [OutputSpike vmax] = simulate(SN,InputSpikes)
            time = 0;                                       % start time
            spiketimes = InputSpikes + SN.InputSpikeDelays;
            len = length(time:NeuronConstants.dt:NeuronConstants.Tmax);
            ost = [];
            lastspike = Inf;
            u = zeros(1,len);
            for k = 2:len
                time = time + NeuronConstants.dt;
                resting = (lastspike ~= Inf && (lastspike < time) &&  (time <  (lastspike + NeuronConstants.rp)));
                if resting
                    mp = 0;
                else
                    if lastspike == Inf
                        effectivespikes = spiketimes;
                    else
                        effectivespikes = spiketimes;
                        effectivespikes(spiketimes < (lastspike + NeuronConstants.rp)) = time;
                    end
                    t_ = time - effectivespikes;
                    dV = EPSP(t_,NeuronConstants.tau);
                    mp = SN.SynapticWeights*dV;
                end
                u(k) = mp;
                if mp > NeuronConstants.threshold
                    lastspike = time;
                    if isempty(ost)
                        ost(1) = time;
                    else
                        ost(end+1) = time;
                    end;
                end;
            end
            vmax= max(u);
            OutputSpike = ost;
        end
    end
end
