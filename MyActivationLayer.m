classdef MyActivationLayer < nnet.layer.Layer

    properties (Learnable)
        % Layer learnable parameters
            
        temp_mu
        temp_sigma
        precip_mu
        precip_sigma
    end
    
    methods
        function layer = MyActivationLayer(name) 

            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = "My Activation Layer for Climate Classification";
            %layer.NumOutputs = 1;
        
            % Initialize parameters.
            layer.temp_mu = [-18 0 10 22];
            layer.temp_sigma = 4;
            layer.precip_mu = [10 40 100];
            layer.precip_sigma = [10 20 30];
        end
        
        function Zt = predict(layer, X)
            % Z = predict(layer, X) forwards the input data X through the
            % layer and outputs the result Z.
            Zt = zeros([10 12 1 size(X, 4)], 'like', X);
            %Z1 = dlarray(zeros(10, 12, 1, size(X, 4), 'single'));
            %Z(1, 2:13, 1, :) = tanh((X(3, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma);
            Zt(1, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(1)) ./ layer.temp_sigma;
            Zt(2, :, 1, :) = (X(2, :, 1, :) - layer.precip_mu(1)) ./ layer.precip_sigma(1);
            Zt(3, :, 1, :) = (X(3, :, 1, :) - layer.precip_mu(1)) ./ layer.precip_sigma(1);
            Zt(4, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(2)) ./ layer.temp_sigma;
            Zt(5, :, 1, :) = (X(2, :, 1, :) - layer.precip_mu(2)) ./ layer.precip_sigma(2);
            Zt(6, :, 1, :) = (X(3, :, 1, :) - layer.precip_mu(2)) ./ layer.precip_sigma(2);
            Zt(7, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(3)) ./ layer.temp_sigma;
            Zt(8, :, 1, :) = (X(2, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma(3);
            Zt(9, :, 1, :) = (X(3, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma(3);
            Zt(10, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(4)) ./ layer.temp_sigma;
            %Z1 = tanh(Zt);
%             
%             Zt = zeros([8 12 1 size(X, 4)], 'like', X);
%             Zt(1, :, 1, :) = relu((X(2, :, 1, :) - layer.precip_mu(1)) ./ layer.precip_sigma);
%             Zt(2, :, 1, :) = relu((X(3, :, 1, :) - layer.precip_mu(1)) ./ layer.precip_sigma); 
%             Zt(3, :, 1, :) = relu((X(1, :, 1, :) - layer.temp_mu(2)) ./ layer.temp_sigma); 
%             Zt(4, :, 1, :) = relu((X(2, :, 1, :) - layer.precip_mu(2)) ./ layer.precip_sigma);
%             Zt(5, :, 1, :) = relu((X(3, :, 1, :) - layer.precip_mu(2)) ./ layer.precip_sigma);
%             Zt(6, :, 1, :) = relu((X(1, :, 1, :) - layer.temp_mu(3)) ./ layer.temp_sigma);
%             Zt(7, :, 1, :) = relu((X(2, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma);
%             Zt(8, :, 1, :) = relu((X(3, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma);
%             
%             Zt = relu(Zt);
%             Z2 = zeros([7 12 1 size(X, 4)], 'like', X);
%             Z2(1, :, 1, :) = Zt(3, :, 1, :) .* Zt(1, :, 1, :);  %A
%             Z2(2, :, 1, :) = Zt(1, :, 1, :) .* Zt(2, :, 1, :);  %B
%             Z2(3, :, 1, :) = Zt(3, :, 1, :) .* Zt(4, :, 1, :);  %A
%             Z2(4, :, 1, :) = Zt(4, :, 1, :) .* Zt(5, :, 1, :);  %B            
%             %Z2(5, :, 1, :) = Zt(4, :, 1, :) .* Zt(5, :, 1, :);  %B
%             Z2(5, :, 1, :) = Zt(6, :, 1, :) .* Zt(4, :, 1, :);  %A
%             Z2(6, :, 1, :) = Zt(7, :, 1, :) .* Zt(8, :, 1, :);  %B
%             Z2(7, :, 1, :) = Zt(6, :, 1, :) .* Zt(7, :, 1, :);  %A

%             Z2 = zeros([7 12 1 size(X, 4)], 'like', X);
%             %Z2 = dlarray(zeros(7, 12, 1, size(X, 4), 'single'));
%             Z2(1, :, 1, :) = log(Z1(4, :, 1, :)) + log(Z1(2, :, 1, :));  %A
%             Z2(2, :, 1, :) = sign(Z1(2, :, 1, :) - Z1(3, :, 1, :)) .* log(abs(Z1(2, :, 1, :) - Z1(3, :, 1, :)));  %B
%             Z2(3, :, 1, :) = log(Z1(4, :, 1, :)) + log(Z1(5, :, 1, :));  %A
%             Z2(4, :, 1, :) = log(Z1(5, :, 1, :)) - log(Z1(6, :, 1, :));  %B            
%             %Z2(5, :, 1, :) = Zt(5, :, 1, :) .* Zt(6, :, 1, :);  %B
%             Z2(5, :, 1, :) = log(Z1(7, :, 1, :)) + log(Z1(5, :, 1, :));  %A
%             Z2(6, :, 1, :) = log(Z1(8, :, 1, :)) - log(Z1(9, :, 1, :));  %B
%             Z2(7, :, 1, :) = log(Z1(7, :, 1, :)) + log(Z1(8, :, 1, :));  %A
              
%             Z2 = zeros([10 12 1 size(X, 4)], 'like', X);
%             Z2(1, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(1)) ./ layer.temp_sigma(5);
%             Z2(2, :, 1, :) = (X(2, :, 1, :) - layer.precip_mu(1)) ./ layer.precip_sigma(4);
%             Z2(3, :, 1, :) = (X(3, :, 1, :) - layer.precip_mu(1)) ./ layer.precip_sigma(4);
%             Z2(4, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(2)) ./ layer.temp_sigma(6);
%             Z2(5, :, 1, :) = (X(2, :, 1, :) - layer.precip_mu(2)) ./ layer.precip_sigma(5);
%             Z2(6, :, 1, :) = (X(3, :, 1, :) - layer.precip_mu(2)) ./ layer.precip_sigma(5);
%             Z2(7, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(3)) ./ layer.temp_sigma(7);
%             Z2(8, :, 1, :) = (X(2, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma(6);
%             Z2(9, :, 1, :) = (X(3, :, 1, :) - layer.precip_mu(3)) ./ layer.precip_sigma(6);
%             Z2(10, :, 1, :) = (X(1, :, 1, :) - layer.temp_mu(4)) ./ layer.temp_sigma(8);
            %Z2 = log(max(Z1, 0.0001));
        end
    end
end