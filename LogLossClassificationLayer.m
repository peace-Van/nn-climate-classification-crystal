classdef LogLossClassificationLayer < nnet.layer.RegressionLayer
    % Example custom classification layer.

    methods
        function layer = LogLossClassificationLayer(name)
    
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Binary Cross Entropy Loss';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % loss = forwardLoss(layer, Y, T) returns the log loss between
            % the predictions Y and the training targets T.
            loss = crossentropy(Y, T, 'TargetCategories', 'independent', 'DataFormat', 'CB') / size(Y, 1);
        end
    end
end
