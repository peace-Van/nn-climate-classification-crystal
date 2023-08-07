classdef MyCircularPaddingLayer < nnet.layer.Layer

    methods
        function layer = MyCircularPaddingLayer(name) 

            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = "Circular Padding Layer";
        end
        
        function Z = predict(layer, X)
            % Z = predict(layer, X) forwards the input data X through the
            % layer and outputs the result Z.
            Z = cat(2, X(:, size(X, 2), :, :), X, X(:, 1, :, :));
            %Z = [Z(size(Z, 1), :, 1, :); Z; Z(1, :, 1, :)];
            %Z(:, 1, 1, :) = Z(:, 13, 1, :);
            %Z(:, 14, 1, :) = Z(:, 2, 1, :);
            %Z = [Z(:, 12, 1) Z Z(:, 1, 1)];
            %Z = reshape(Z, 11, 14, 1);
            %Z = dlarray(Z, 'SSC');
        end
    end
end