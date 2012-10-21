clear;

% Generate 2D clusters, samples in each cluster are normally distributed
% the mean of each cluster is represented with variable meani
 covm=[.5 0; 0 .5]; % covariance matrix
 clusterSize=100;   % number of samples in each cluster
 
 % set the mean vector for each cluster, 10 clusters in this case
 mean_1 = [5 5];    mean_2 = [20 5];      mean_3 = [5 20];   mean_4 = [20 20];    mean_5 = [12 12];  
 mean_6 =-mean_1;   mean_7 =-mean_2;     mean_8 =-mean_3;  mean_9 =-mean_4;    mean_10 =-mean_5; 
  
% generate the 2D clusters (10 clusters of 400 points, each cluster has different mean point but allclusters have the same covariance matrix) 
C1 = [mvnrnd(mean_1,covm,clusterSize)]; C2 = [mvnrnd(mean_2,covm,clusterSize)]; C3 = [mvnrnd(mean_3,covm,clusterSize)]; C4 = [mvnrnd(mean_4,covm,clusterSize)]; C5 = [mvnrnd(mean_5,covm,clusterSize)];
C6 = [mvnrnd(mean_6,covm,clusterSize)]; C7 = [mvnrnd(mean_7,covm,clusterSize)]; C8 = [mvnrnd(mean_8,covm,clusterSize)]; C9 = [mvnrnd(mean_9,covm,clusterSize)]; C10 = [mvnrnd(mean_10,covm,clusterSize)]; 

%scatter plot the generated clusters
scatter(C1(:,1),C1(:,2),'.', 'r'); hold on
scatter(C2(:,1),C2(:,2),'.', 'g');
scatter(C3(:,1),C3(:,2),'.', 'b');
scatter(C4(:,1),C4(:,2),'.', 'c');
scatter(C5(:,1),C5(:,2),'.', 'm');

scatter(C6(:,1),C6(:,2),'.', 'r');
scatter(C7(:,1),C7(:,2),'.', 'g');
scatter(C8(:,1),C8(:,2),'.', 'b');
scatter(C9(:,1),C9(:,2),'.', 'c');
scatter(C10(:,1),C10(:,2),'.', 'm');

syntheticdata = [C1;C2;C3;C4;C5;C6;C7;C8;C9;C10];
save syntheticdata.mat 'syntheticdata'

grid on
