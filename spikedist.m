function [ dist ] = spikedist(spiketrain1, spiketrain2  )
% Evaluates the number of neurons that fire with maximum allowed threshold
X = [spiketrain1;spiketrain2];
dist = length(find(std(X)<NeuronConstants.cThreshold));
end

