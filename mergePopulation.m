function [ p ] = mergePopulation(p, dist)
% Merge Population
% Merges populations whose centres are near each other. Populations are
% merged when at least one neuron from each population fire with in the
% minimum distance i.e. populations with ? > 0. Populations are merged
% to the population with maximum response to a given input.

% Identify the population with maximum reponse
[d I] = sort(dist,1,'descend');
p = p(I);
nP = Population();
nP.neurons = p(1).neurons;
nP.center = p(1).center;
pL = length(p);

% Find reponsive neurons from other populations and merge to population
% with maximum reponse.
pI = zeros(1,pL);
for k=2:pL
    len = length(p(k).neurons);
    I = zeros(1,len);
    for j=1:len
        value = repmat(p(k).center(j),size(nP.center));
        dC = spikedist(nP.center, value);
        if dC/length(value) == 1
            I(j) = j;
        end;
    end;
    % Merge reponsive neurons from other populations to 
    % population with maximum reponse.
    if ~isempty(find(I > 0,1))
        L = I(I~=0);
        nP.neurons = [nP.neurons p(k).neurons(L)];
        nP.center = [nP.center p(k).center(L)];
        p(k).neurons(L) = [];
        p(k).center(L) = [];
    end;
    if isempty(p(k).neurons)
        pI(k) = k;
    end;
end;
if ~isempty(find(pI > 0,1))
    L = pI(pI~=0);
    p(L) = [];
end;
p(1) = nP;
end
