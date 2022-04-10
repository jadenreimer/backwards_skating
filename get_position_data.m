function [left_foot_pos, right_foot_pos] = get_position_data(num_ccuts, ccut_period, randomness, stance_spacing, ccut_amplitude)

    %% example inputs 
%     num_ccuts = 6; % Must be an even number. Number per leg will be half this.
%     ccut_period = 8:2:12; % this vector is whatever ccut periods you want to plot
%     randomness = 1; % multiplier used to magnify the rand() function. higher number is noisier data
%     stance_spacing = 8; % dist between centerline and food in inches when standing normally
%     ccut_amplitude = 8; % additional stance width at peak of ccut in inches
    
    %% actual function
    for i = 1:length(ccut_period)
        ccut_freq = 1/ccut_period(i);
        x = linspace(0, num_ccuts*pi*ccut_period(i), num_ccuts*pi*ccut_period(i));
        % make the ccut amplitude a sine function to introduce pseudo
        % randomness
        ccut_amplitude_rand = ccut_amplitude .* (0.2 * sin(x) + 1);
        right_foot_pos = ccut_amplitude_rand .* sin(ccut_freq * x) + stance_spacing;
        left_foot_pos = ccut_amplitude_rand .* sin(ccut_freq * x) - stance_spacing;
        right_foot_min = stance_spacing;
        left_foot_min = -1 * stance_spacing;
        
        for j = 1:length(right_foot_pos)
            if right_foot_pos(j) < right_foot_min
                right_foot_pos(j) = right_foot_min - (randomness * rand());
            end
        
            if left_foot_pos(j) > left_foot_min
                left_foot_pos(j) = left_foot_min + (randomness * rand());
            end
    
        end
        right_foot_pos = smooth(right_foot_pos);
        left_foot_pos = smooth(left_foot_pos);
    %     figure(i);
        axis equal;
    %     plot(ccut_amplitude_rand); hold on
        plot(right_foot_pos); hold on
        plot(left_foot_pos); hold on
    end
end