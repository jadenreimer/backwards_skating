% TODO:
% - include normalization of position based on where the COM is for that
% given run, make it a little sine wave disturbance or something and then
% adjust the locations of the ankles accordingly
% - might want to select several minima instead of a global one for real
% position data since if the global minima isn't repeated there will only
% be one c-cut extracted
% - right now, if the position data starts partway through (Eg. at the 
% start of data) an incomplete c-cut will be accepted as a full c-cut

% clc; clear all ;

% x = position along the direction of skater travel
% y = position across the skater's body, perpendicular to travel
num_ccuts = 8; % Must be an even number. Number per leg will be half this.
x = (linspace(0, num_ccuts*pi, num_ccuts*50));
right_loc = [x; sin(x)];%cat(2, x, sin(x));
left_loc = [x; -sin(x-pi)];%cat(2, x, -sin(x - pi));
COM_loc = [bsxfun(@plus, x, 0.1); 0.02*sin(x)];

% Preprocess position data
    % COM position normalization goes here
zero_cross = 0; c_start = 0; c_end = 0;
x_ccuts = cell(2, num_ccuts/2); y_ccuts = cell(2, num_ccuts/2); area_ccuts = cell(2, num_ccuts/2);
position = cell(2, num_ccuts/2); velocity = cell(2, num_ccuts/2); acceleration = cell(2, num_ccuts/2);
i_ccuts = 1;

right_min = 0.1;    % In practice, this is the max of either the minimum position
                    % w.r.t COM or the position of the COM
left_min = -0.1;    % In practice, this is the min of either the maximum position
                    % w.r.t COM or the position of the COM
left_loc_mod = left_loc;
right_loc_mod = right_loc;

% Left position
for i = 1:length(left_loc(1, :))
    % Flatten position
    if left_loc(2, i) > left_min
        left_loc_mod(2, i) = left_min;
    end
    
    if left_loc(2, i) < left_min  && c_start <= c_end
        c_start = i;
    elseif c_start > c_end && left_loc(2, i) > left_min;
        c_end = i;
        y_ccuts{1, i_ccuts} = left_loc_mod(:, c_start:c_end);
%         x_ccuts{1, i_ccuts} = x(c_start:c_end);
        i_ccuts = i_ccuts + 1;
        c_start = c_end;
    end
end

c_start = 0; c_end = 0;
i_ccuts = 1;
% Right position
for i = 1:length(right_loc(1, :))
    % Flatten position
    if right_loc(2, i) < right_min
        right_loc_mod(2, i) = right_min;
    end
    
    if right_loc(2, i) > right_min  && c_start <= c_end
        c_start = i;
    elseif c_start > c_end && right_loc(2, i) < right_min;
        c_end = i;
        y_ccuts{2, i_ccuts} = right_loc_mod(:, c_start:c_end);
%         x_ccuts{2, i_ccuts} = x(c_start:c_end);
        i_ccuts = i_ccuts + 1;
        c_start = c_end;
    end
end

% Position data
% figure (1)
% hold on
% plot(COM_loc(1, :), COM_loc(2, :))
% plot(right_loc_mod(1, :), right_loc_mod(2, :))
% plot(left_loc_mod(1, :), left_loc_mod(2, :))
% plot(y_ccuts{1, 1}(1, :), y_ccuts{1, 1}(2, :))
% plot(y_ccuts{2, 1}(1, :), y_ccuts{2, 1}(2, :))




% time-varying plot used to show skater path captured in data
% for i = 1:length(x)
% %     x = bsxfun(@plus, x, 0.1); % add 0.1 to all x
% %     f = fit(x, y, 'sin3');
% %     plot(f, 'r', x, y);
% %     hold on
% %     plot(f_x, 'b', x, y);
% %     plot(f_xx, 'g', x, y);
% 
% %     plot(x, y)
% %     drawnow
% %     pause(0.001)
% end





% Capture angles from the COM midline and the ankles
% theta_r = ;
% theta_l = ;






% 
% % One c-cut with derivatives
% % f = fit(x_ccuts{2, 1}, y_ccuts{2, 1}, 'sin3');
% % [fx, fxx] = differentiate(f, x_ccuts{2, 1});
% % f_x = fit(x_ccuts{2, 1}, fx, 'sin3');
% % f_xx = fit(x_ccuts{2, 1}, fxx, 'sin3');
% % 
% % figure(2)
% % hold on
% % plot(f, 'r', x_ccuts{2, 1}, y_ccuts{2, 1})
% % plot(f_x, 'g', x_ccuts{2, 1}, y_ccuts{2, 1})
% % plot(f_xx, 'b', x_ccuts{2, 1}, y_ccuts{2, 1})
% % test = integrate(f_xx, x_ccuts{2, 1}, 0);
% % plot(x_ccuts{2, 1}, test, '-r')
% 
% f = fit(x_ccuts{1, 1}, y_ccuts{1, 1}, 'sin3');
% [fx, fxx] = differentiate(f, x_ccuts{1, 1});
% f_x = fit(x_ccuts{1, 1}, fx, 'sin3');
% f_xx = fit(x_ccuts{1, 1}, fxx, 'sin3');
% 
% figure(2)
% hold on
% plot(f, 'r', x_ccuts{1, 1}, y_ccuts{1, 1})
% plot(f_x, 'g', x_ccuts{1, 1}, y_ccuts{1, 1})
% plot(f_xx, 'b', x_ccuts{1, 1}, y_ccuts{1, 1})
% test = integrate(f_xx, x_ccuts{1, 1}, 0);
% plot(x_ccuts{1, 1}, test, '-r')


% All c-cut data segments
% figure (3)
% % hold on
% for i = 1:size(y_ccuts)
%     for j = 1:length(y_ccuts)
% %         x_ccut = 1:length(y_ccuts{i, j});
%         
%         position{i, j} = fit(x_ccuts{i, j}, y_ccuts{i, j}, 'sin3');
%         [v, a] = differentiate(position{i, j}, x_ccuts{i, j});
%         velocity{i, j} = fit(x_ccuts{i, j}, v, 'sin3');
%         acceleration{i, j} = fit(x_ccuts{i, j}, a, 'sin3');
%         
% %         nexttitle
%         subplot(num_ccuts, 2, i*num_ccuts/2 + j);
%         plot(x_ccuts{i, j}, y_ccuts{i, j})
% %         plot(acceleration{i, j}, x_ccuts{i, j}, y_ccuts{i, j}) % Use to plot
% %         position and acceleration curves
% 
%         area_ccuts{i, j} = sum(y_ccuts{i, j})/length(y_ccuts{i, j})*(x_ccuts{i, j}(length(x_ccuts{i, j}))-x_ccuts{i, j}(1));
%     end
% end

% time-varying plot used to show skater path captured in data
% for i = 1:length(x)
% %     x = bsxfun(@plus, x, 0.1); % add 0.1 to all x
% %     f = fit(x, y, 'sin3');
% %     plot(f, 'r', x, y);
% %     hold on
% %     plot(f_x, 'b', x, y);
% %     plot(f_xx, 'g', x, y);
% 
% %     plot(x, y)
% %     drawnow
% %     pause(0.001)
% end

% linear = transpose(linspace(1, 0, 100));
% y = sin(x).*linear;

% if isempty(y_ccuts)
%     disp('No c-cuts found');
% end