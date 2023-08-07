close all; clear; clc;
load('climatologies.mat');

[x, y] = size(climatologies);

I = string(zeros(x, y));

for i = 1:x
    for j = 1:y
        if isstruct(climatologies{i, j})
            disp([i j])
            I(i, j) = trewartha_class(climatologies{i, j}.ori(1:2, :));
            climatologies{i, j}.trewartha = I(i, j);
        end
    end
end

I = categorical(I);

res = struct('I', I);
save('trewartha.mat', 'res');
% load('res_vegetation.mat');
% veg = res.I;
% score = homogeneity(veg, I, false, true);
% fprintf('%f\n', score);


function cls = trewartha_class(climatology)
    cls = "";
    t_monthly = sortrows(climatology', 1).';
    total_pr = sum(t_monthly(2, :));
    pr_percent = sum(t_monthly(2, 1:6)) / total_pr;
    mean_temp = mean(t_monthly(1, :));
    thresh = 23 * mean_temp - 6.4 * pr_percent + 410;
    if total_pr < 0.5 * thresh          % arid, BW
        cls = cls + "BW";
    elseif total_pr < thresh            % semi-arid, BS
        cls = cls + "BS";
    else
        if t_monthly(1, 1) >= 18                                      % tropical, A
            cls = cls + "A";
            if sum(t_monthly(2, :) >= 60) >= 10
                cls = cls + "r";
            else                
                cls = cls + "w";
            end                
        elseif t_monthly(1, 12) < 10                                  % arctic, F
            cls = cls + "F";
            if t_monthly(1, 12) < 0
                cls = cls + "i";
            else
                cls = cls + "t";
            end            
        elseif sum(t_monthly(1, :) > 10) >= 8                         % subtropical, C
            cls = cls + "C";
            if max(t_monthly(2, 1:3)) > 3 * min(t_monthly(2, 10:12)) && min(t_monthly(2, 10:12)) < 30 && sum(t_monthly(2, :)) < 890
                cls = cls + "s";
            else
                cls = cls + "f";
            end
        elseif sum(t_monthly(1, :) > 10) >= 4                         % temperate, D
            cls = cls + "D";
            if t_monthly(1, 1) < 0
                cls = cls + "c";
            else
                cls = cls + "o";
            end
        else                                                          % subarctic, E
            cls = cls + "E";
            if t_monthly(1, 1) < -10
                cls = cls + "c";
            else
                cls = cls + "o";
            end
        end 
    end    
end