classdef Population < handle
    % POPULATION of Spiking neurons
    % Object oriented implementation of a population of spiking neuron
    % Includes methods to learn an input and adjust center
    
    properties
        features = [];
        neurons = [];
        center = [];
        synapticWeights = [];
    end
    
    methods
        % evaluates population firing times for a given input
        function [firingtimes] = evaluate(P,input)
            nNeurons = length(P.neurons);
            firingtimes = zeros(1,nNeurons);
            for k=1:nNeurons
                if isempty(P.features)
                    ist = input;
                else
                    feat = P.features(k,:);
                    ist = input(feat);
                end;
                % simulate neurons within a population to the given input
                spike = P.neurons(k).simulate(ist);
                if isempty(spike)
                    firingtimes(k) = 0;
                else
                    firingtimes(k) = spike(1);
                end
            end;
            if isempty(P.center)
                P.center = firingtimes;
            end
        end;
        % Learn the given input 
        function [dw] = learninput(P,input,firingtimes)
            iL = length(P);
            for k=1:iL
                id = k;
                delay = P.neurons(id).InputSpikeDelays;
                spiketimes = input + delay;
                wt = P.neurons(k).SynapticWeights;
                dw = WeightUpdate(spiketimes,firingtimes(id),wt);
                P.neurons(k).SynapticWeights =  dw;
            end;
        end
        % Adjust population center after learning
        function adjustcenter(P,firingtimes)
            P.center = round(mean([P.center;firingtimes])*10)/10;
        end;
    end
end

