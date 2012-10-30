% Clustering with population of spiking neurons
% Options to cluster 3 different datasets. Parameters of clustering can be
% modified in the file NeuronConstants

clear;
ds = 0;
disp('        UNSUPERVISED CLUSTERING USING POPULATION OF SPIKING NEURONS');
disp(' ');
disp(' ');

while isempty(find(ds > 0) & find(ds < 5))
    disp('        TWO DIMENSIONAL SYNTHETIC DATASET:            1');
    disp('        IRIS:                                         2');
    disp('        BREAST CANCER WISCONSIN (DIAGNOSTIC) DATASET  3');
    disp('        SYNTHETIC 10 CLUSTER DATASET                  4');
    disp(' ');
    disp(' ');
    ds = input('        PLEASE SELECT A DATASET FOR CLUSTERING:       ');
    switch ds
        case 1
            disp('        CLUSTERING TWO DIMENSIONAL SYNTHETIC DATASET, PLEASE WAIT!');
            % Load two dimensional synthetic dataset
            load sdInput;
            samples = sdInput;
            %sample size
            sz= 150;
            % minimum population response
            limit = .5;
        case 2
            disp('        CLUSTERING IRIS, PLEASE WAIT...');
            % Load Iris dataset
            load iris_dataset;
            samples = irisInputs';
            % sample size
            sz= 75;
            % minimum population response
            limit = .7;
        case 3
            disp('        CLUSTERING BREAST CANCER WISCONSIN (DIAGNOSTIC) DATASET, PLEASE WAIT!');
            % Load Breast Cancer Wisconsin (Diagnostic) dataset
            load breast_cancer_dataset.csv
            [bcClass I] = sort(breast_cancer_dataset(:,end));
            samples = breast_cancer_dataset(I, 2:end-1);
            %sample size
            sz= 200;
            % minimum population response
            limit = .65;
        case 4
            disp('        CLUSTERING SYNTHETIC 10 CLUSTER DATASET, PLEASE WAIT!');
            % Load synthetic 10 cluster dataset
            load syntheticdata
            samples = syntheticdata(1:500,:);
            %sample size
            sz= 100;
            % minimum population response
            limit = .65;
        otherwise
            clc
            disp('        UNSUPERVISED CLUSTERING USING POPULATION OF SPIKING NEURONS');
            disp(' ');
            disp(' ');
            disp('        PLEASE ENTER A VALID DATASET!');
    end
end;

% Encode continuous analogue valued inputs as spike times
[r c] = size(samples);
rf = zeros(r,c);
Imax = max(samples);
Imin = min(samples);
for k = 1:r
    value = (samples(k, :) - Imin)./(Imax-Imin);
    ist = ((1-value)*NeuronConstants.t_inputwindow);
    rf(k, :) = round(ist.*10)/10;
end

%Select random samples by creating a random permution
index = randperm(r);
% Initialize default Population size
pSize = 1;

% Initialize an empty Population of size 3
p = Population.empty(3,0);

% Variable to hold the total number of population at each iteration
pLength = zeros(1,sz);
tic
for i=1:sz
    % Take the data sample for online clustering
    input = rf(index(i),:)';
    % If there no populations create one
    if isempty(p)
        p(1) = generatePopulation(input,pSize);
    end;
    
    % Evaluate Population Reponse for all existing populations
    pL = length(p);
    dist = zeros(pL,1);
    for k=1:pL
        ft = p(k).evaluate(input);
        d = spikedist(p(k).center, ft)/length(p(k).center);
        dist(k) = d;
    end;
    
    % Display Sample and population reponse for all existing populations
    disp(' ');
    disp(' ');
    disp(['        SAMPLE: ' num2str(index(i))]);
    disp(['        POPULATION RESPONSE: ' num2str(dist')]);
    
    %Find populations showing responsiveness above threshold
    clz = find(dist >= limit);
    cL = length(clz);
    
    % if there are no populations showing responsiveness above threshold
    % create a new population
    if isempty(clz)
        p = getPopulation( p, input, dist, limit, pSize );
    else
        % Apply STDP based learning
        for k=1:cL
            id = clz(k);
            ft =  p(id).evaluate(input);
            p(id).learninput(input,ft);
            ft =  p(id).evaluate(input);
            p(id).adjustcenter(ft);
        end;
        % Perform pruning of unresponsive neurons
        p(clz) = updatePopulation( p(clz), input);
        clz = find(dist > 0);
        cL = length(clz);
        
        % Merge Population whose centers are close to each other
        if cL > 1
            nP = mergePopulation(p(clz), dist(clz));
            p(clz(1)) = nP(1);
            p(clz(2:end)) = [];
            if length(nP) > 1
                p = [p nP(2:end)];
            end;
        end;
    end;
    pLength(i) = length(p);
end;
toc

% Test the Population again with training samples to identify the classes
class = zeros(1,sz);
test = index(1:sz);
tL = length(test);
pL = length(p);

disp('   ');
disp('   ');
disp('        CLUSTERING TESTING SAMPLES, PLEASE WAIT!');
for i=1:tL
    input = rf(test(i),:)';
    dist = zeros(pL,1);
    for k=1:pL
        ft = p(k).evaluate(input);
        d = spikedist(p(k).center, ft)/length(p(k).center);
        dist(k) = d;
    end;
    m = find(dist == max(dist));
    if ~isempty(find(dist > 0,1))
        class(i) = m(1);
    end;
end;

% % Test the Population created with rest of the samples
% class = zeros(1,sz);
% test = index(sz+1:end);
% tL = length(test);
% pL = length(p);
% 
% disp('   ');
% disp('   ');
% disp('        CLUSTERING TESTING SAMPLES, PLEASE WAIT!');
% for i=1:tL
%     input = rf(test(i),:)';
%     dist = zeros(pL,1);
%     for k=1:pL
%         ft = p(k).evaluate(input);
%         d = spikedist(p(k).center, ft)/length(p(k).center);
%         dist(k) = d;
%     end;
%     m = find(dist == max(dist));
%     if ~isempty(find(dist > 0,1))
%         class(i) = m(1);
%     end;
% end;
% 
% % Display appropriate classes for the test samples
% clc
% for k=0:pL
%     if k == 0
%         if isempty(find(test(class == k), 1))
%             disp('NO UNIDENTIFIABLE DATA SAMPLES: ');
%         else
%             disp('UNIDENTIFIED DATA SAMPLES: ');
%             disp(sort(test(class == k)))
%         end
%     else
%         disp('   ');
%         disp(['CLASS ' int2str(k) ' SAMPLES']);
%         Y = sort(test(class == k));
%         if isempty(Y)
%             disp('NO SAMPLES, UNRESPONSIVE POPULATION ');
%         else
%             disp(Y);
%         end
%         disp('   ');
%         disp('POPULATION CENTER: ');
%         disp((p(k).center));
%         disp('   ');
%     end;
% end;
% 
% % Plot evolution of population
% plot(pLength, 'r.:');
% title('Evolution of Population during clustering')
% xlabel('No of Samples');
% ylabel('No of Populations');
% axis([0 sz 0 max(pLength)+1]);

