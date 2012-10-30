classdef NeuronConstants
    %   NEURONCONSTANTS Spiking neuron constants
    %   Various parameters of spiking neuron and population
    
    properties(Constant)
        tau = 3;                    % time constant of spike response function
        dt = 0.1;                   % integration time interval
        Tmax = 30;                  % maximum time of integration
        threshold = 0.8;            % Spike threshold
        rp = 0;                     % absolute refractor period
        t_inputwindow = 10;         % input temporal encoding window
        cThreshold = 0.8;           % cluster threshold
    end
end

