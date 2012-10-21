function [ p ] = updatePopulation( p, input )
% Prune unreponsive neurons within a population
% Pruning of neurons within a population is performed to remove 
% unresponsive neurons. Pruning within a population removes neurons 
% that do not contribute to clustering of a given input and it is done 
% when the population response is above min. 

pL = length(p);
for k = 1:pL
    if length(p(k).center) > 1
        ft = p(k).evaluate(input);
        dev = std([p(k).center;ft]);
        sIndex = find (dev > NeuronConstants.cThreshold);
        if ~isempty(sIndex)
            tP = Population();
            tP.center = p(k).center(sIndex);
            tP.neurons = p(k).neurons(sIndex);
            p(k).center(sIndex) = [];
            p(k).neurons(sIndex) = [];
            tL = length(sIndex);
            for j = 1:tL
                value = repmat(tP.center(j),size(p(k).center));
                dC = spikedist(p(k).center, value);
                if dC/length(value) == 1
                    p(k).center = [p(k).center tP.center(j)];
                    p(k).neurons = [p(k).neurons tP.neurons(j)];
                end;
            end
        end
    end
end