
[x, y] = size(climatologies);

I = string(zeros(x, y));

for i = 1:x
    for j = 1:y
        if isstruct(climatologies{i, j})
            disp([i j])
            I(i, j) = koppen_class(climatologies{i, j}.ori(1:2, :));
            climatologies{i, j}.koppen = I(i, j);
        end
    end
end

I = categorical(I);

% These are buggy
% OSM API cannot get the accurate locations of coastal cities
% often shifts into sea

% centers = zeros(28, 2);
% 
% centers(2, :) = [1.28 103.83];          % Af, Singapore
% centers(3, :) = [25.78 -80.21];         % Am, Miami, Florida, US
% centers(4, :) = [18.25 109.51];         % Aw, Sanya, Hainan, China
% 
% centers(5, :) = [21.31 -157.86];        % BSh, Honululu, Hawaii, US
% centers(6, :) = [49.69 -112.83];        % BSk, Lethbridge, Alberta, Canada
% centers(7, :) = [25.26 55.30];          % BWh, Dubai, UAE
% centers(8, :) = [42.95 89.19];          % BWk, Turpan, Xinjiang, China
% 
% centers(9, :) = [38.90 -77.02];         % Cfa, Washington DC, US
% centers(10, :) = [51.51 -0.13];         % Cfb, London, England, UK
% centers(11, :) = [-53.17 -70.93];       % Cfc, Punta Arenas, Chile
% centers(12, :) = [32.07 34.78];         % Csa, Tel Aviv, Israel
% centers(13, :) = [-36.83 -73.05];       % Csb, Concepcion, Chile
% centers(14, :) = [-45.91 -71.70];       % Csc, Balmaceda, Chile
% centers(15, :) = [30.66 104.07];        % Cwa, Chengdu, Sichuan, China
% centers(16, :) = [19.43 -99.13];        % Cwb, Mexico City, Mexico
% centers(17, :) = [-16.52 -68.17];       % Cwc, El Alto, Bolivia
% 
% centers(18, :) = [43.28 76.90];         % Dfa, Almaty, Kazakhstan
% centers(19, :) = [55.76 37.62];         % Dfb, Moscow, Russia
% centers(20, :) = [62.45 -114.37];       % Dfc, Yellowknife, Northwest Territories, Canada
% centers(21, :) = [38.73 41.49];         % Dsa, Mus, Turkey
% centers(22, :) = [38.70 69.75];         % Dsb, Roghun, Tajikistan
% centers(23, :) = [64.73 177.52];        % Dsc, Anadyr, Chukotka Autonomous Okrug, Russia
% centers(24, :) = [39.02 125.74];        % Dwa, Pyongyang, North Korea
% centers(25, :) = [43.13 131.90];        % Dwb, Vladivostok, Russia
% centers(26, :) = [52.05 113.47];        % Dwc, Chita, Zabaykalsky Krai, Russia
% 
% centers(27, :) = [64.18 -51.69];        % ET, Nuuk, Greenland, Denmark
% centers(28, :) = [27.99 86.92];         % EF, Mount Everest, China/Nepal

% R = georefcells([-55 80], [-180 179.5], [x y], 'ColumnsStartFrom', 'north');
% [t1, t2] = geographicToIntrinsic(R, centers(:, 1), centers(:, 2));
% centers_ = round([t2 t1]);

%res = struct('I', I);
save('koppen.mat', 'I');
% load('res_vegetation.mat');
% veg = res.I;
% score = homogeneity(veg, I, false, true);
% fprintf('%f\n', score);


function cls = koppen_class(climatology)
    cls = "";
    t_monthly = sortrows(climatology', 1).';
    total_pr = sum(t_monthly(2, :));
    pr_percent = sum(t_monthly(2, 6:12)) / total_pr;
    mean_temp = mean(t_monthly(1, :));
    thresh = 20 * mean_temp;
    if pr_percent >= 0.7
        thresh = thresh + 280;
    elseif pr_percent >= 0.3
        thresh = thresh + 140;
    end
    if t_monthly(1, 12) < 10                % arctic, E
        cls = cls + "E";
        if t_monthly(1, 12) < 0
            cls = cls + "F";
        else
            cls = cls + "T";
        end  
    else
        if total_pr < 0.5 * thresh          % arid, BW
            cls = cls + "BW";
            if mean_temp < 18
                cls = cls + "k";
            else
                cls = cls + "h";
            end
        elseif total_pr < thresh            % semi-arid, BS
            cls = cls + "BS";
            if mean_temp < 18
                cls = cls + "k";
            else
                cls = cls + "h";
            end
        else
            if t_monthly(1, 1) >= 18                                      % tropical, A
                cls = cls + "A";
                if min(t_monthly(2, :)) >= 60
                    cls = cls + "f";
                else
                    thresh_2 = 100 - total_pr / 25;
                    if min(t_monthly(2, :)) < thresh_2
                        cls = cls + "w";
                    else
                        cls = cls + "m";
                    end
                end                
            elseif t_monthly(1, 1) > -3                                   % temperate, C
                cls = cls + "C";
                if max(t_monthly(2, 10:12)) > 10 * min(t_monthly(2, 1:3))
                    cls = cls + "w";
                elseif max(t_monthly(2, 1:3)) > 3 * min(t_monthly(2, 10:12)) && min(t_monthly(2, 10:12)) < 30
                    cls = cls + "s";
                else
                    cls = cls + "f";
                end
                if sum(t_monthly(1, :) > 10) < 4
                    cls = cls + "c";
                elseif t_monthly(1, 12) > 22
                    cls = cls + "a";
                else
                    cls = cls + "b";
                end
            else                                                          % continental, D
                cls = cls + "D";
                if max(t_monthly(2, 10:12)) > 10 * min(t_monthly(2, 1:3))
                    cls = cls + "w";
                elseif max(t_monthly(2, 1:3)) > 3 * min(t_monthly(2, 10:12)) && min(t_monthly(2, 10:12)) < 30
                    cls = cls + "s";
                else
                    cls = cls + "f";
                end
                if sum(t_monthly(1, :) > 10) < 4
                    if t_monthly(1, 1) <= -38
                        cls = cls + "d";
                    else
                        cls = cls + "c";
                    end
                elseif t_monthly(1, 12) > 22
                    cls = cls + "a";
                else
                    cls = cls + "b";
                end 
            end 
        end
    end    
end
