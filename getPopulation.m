function [ p ] = getPopulation( p, input, dist, limit, pSize )
% getPopulation creates a new population by modifying existing population
% or by creating totally new population

% Generate a neuronal population for given spike time
nP = generatePopulation(input, pSize);
newPopulation = 'Yes';

% Identify the existing population with max response
maxP = find(dist == max(dist));
mL = length(maxP);
for m=1:mL
    h = maxP(m);
    tP = Population();
    % Check if the reponsiveness of the max population can be enhanced
    % above threshold
    for k = 1:pSize;
        tP.center = [p(h).center nP.center(k)];
        tP.neurons = [p(h).neurons nP.neurons(k)];
        ft =  tP.evaluate(input);
        sd = spikedist(tP.center, ft)/length(tP.center);
        if sd >=limit
            p(h) = tP;
            p(h).adjustcenter(ft);
            newPopulation = 'No';
            break;
        end;
    end;
    if strcmp(newPopulation,'No')
        break;
    end;
end;
% if the reponsiveness of the max population cannot be enhanced
% above threshold add the new population to the end of existing populations

if strcmp(newPopulation,'Yes')
    p(end+1) = nP;
end;
end
