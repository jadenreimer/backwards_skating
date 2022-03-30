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
num_ccuts = 10; % Number per leg will be half this
x = transpose(linspace(0, num_ccuts*pi, num_ccuts*50));
right_loc = sin(x);
left_loc = -sin(x - pi);
COM_loc = zeros(num_ccuts*50);

% Preprocess position data
    % COM position normalization goes here
zero_cross = 0; c_start = 0; c_end = 0;
x_ccuts = cell(2, num_ccuts); y_ccuts = cell(2, num_ccuts);
i_ccuts = 1;

right_min = 0.1;    % In practice, this is the max of either the minimum position
                    % w.r.t COM or the position of the COM
left_min = -0.1;    % In practice, this is the min of either the maximum position
                    % w.r.t COM or the position of the COM
left_loc_mod = left_loc;
right_loc_mod = right_loc;

% Left position
for i = 1:length(left_loc)
    % Flatten position
    if left_loc(i) > left_min
        left_loc_mod(i) = left_min;
    end
    
    if left_loc(i) < left_min  && c_start <= c_end
        c_start = i;
    elseif c_start > c_end && left_loc(i) > left_min;
        c_end = i;
        y_ccuts{1, i_ccuts} = left_loc_mod(c_start:c_end);
        x_ccuts{1, i_ccuts} = x(c_start:c_end);
        i_ccuts = i_ccuts + 1;
        c_start = c_end;
    end
end

c_start = 0; c_end = 0;
i_ccuts = 1;
% Right position
for i = 1:length(right_loc)
    % Flatten position
    if right_loc(i) < right_min
        right_loc_mod(i) = right_min;
    end
    
    if right_loc(i) > right_min  && c_start <= c_end
        c_start = i;
    elseif c_start > c_end && right_loc(i) < right_min;
        c_end = i;
        y_ccuts{2, i_ccuts} = right_loc_mod(c_start:c_end);
        x_ccuts{2, i_ccuts} = x(c_start:c_end);
        i_ccuts = i_ccuts + 1;
        c_start = c_end;
    end
end

x_ccut = 1:length(y_ccuts{2, 1});
f = fit(x_ccuts{2, 1}, y_ccuts{2, 1}, 'sin3');
[fx, fxx] = differentiate(f, x_ccuts{2, 1});
f_x = fit(x_ccuts{2, 1}, fx, 'sin3');
f_xx = fit(x_ccuts{2, 1}, fxx, 'sin3');

% Position data
figure (1)
hold on
plot(x, COM_loc)
plot(x, right_loc_mod)
plot(x, left_loc_mod)

% One c-cut with derivatives
figure(2)
hold on
plot(f, 'r', x_ccuts{2, 1}, y_ccuts{2, 1})
plot(f_x, 'g', x_ccuts{2, 1}, y_ccuts{2, 1})
plot(f_xx, 'b', x_ccuts{2, 1}, y_ccuts{2, 1})

% All c-cut data segments
figure (3)
hold on
for j = 1:size(y_ccuts)
    for i = 1:length(y_ccuts)
        plot(x_ccuts{j, i}, y_ccuts{j, i})
    end
end

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

% f = fit(x, y, 'sin3');
% [fx, fxx] = differentiate(f, x);
% f_x = fit(x, fx, 'sin3');
% f_xx = fit(x, fxx, 'sin3');

if isempty(y_ccuts)
    disp('No c-cuts found');
end