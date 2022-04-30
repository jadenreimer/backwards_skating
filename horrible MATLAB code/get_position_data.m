%% example inputs 
num_ccuts = 6; % Must be an even number. Number per leg will be half this.
ccut_period = 8; % this vector is whatever ccut periods you want to plot
randomness = 1; % multiplier used to magnify the rand() function. higher number is noisier data
stance_spacing = 8; % dist between centerline and food in inches when standing normally
ccut_amplitude = 8; % additional stance width at peak of ccut in inches

% t = [5.87, 6.27, 6.5];
% y = [8.13, 8.98, 8.07];
% 
% plot(t, y);

L1 = 3;
L2 = 4;
L3 = 5;
L4 = 6;
L5 = 7;
L6 = 8;

n=5;

for i = 1:n
    eval((sprintf('L%d',i)));
end

dataLarge = readtable('data/large_run7.csv');
dataLargeZ = dataLarge.gFz;
dataMed = readtable('data/medium_run6.csv');
dataMedZ = dataMed.gFz;
dataSmall = readtable('data/small_run 1.csv');
dataSmallZ = dataSmall.gFz;
% plot(smoothdata(dataLargeZ(3000:5500), 'gaussian', 100)); hold on
% plot(smoothdata(dataMedZ(3000:5500), 'gaussian', 100)); hold on
% plot(smoothdata(dataSmallZ(3000:5500), 'gaussian', 100)); hold on
% legend('Large', 'Med', 'Small');


pyData = readtable('data/largeRun.csv');
LA = pyData.leftAnkle;
RA = pyData.rightAnkle;
leftFootAcceleration = [];
rightFootAcceleartion = [];

for i = 10:290
    leftFootAcceleration(i) = (LA(i-1) - (2 * LA(i)) + LA(i+1)) / ((1/30) * (1/30));
    rightFootAcceleration(i) = (pyData.rightAnkle(i-1) - (2 * pyData.rightAnkle(i)) + pyData.rightAnkle(i+1)) / ((1/30)^2);
end
% plot(LA(10:290));
plot(pyData.Time(10:299), leftFootAcceleration);
% plot(pyData.Time, pyData.leftAnkle); hold on
%% actual function
for k = 1:length(ccut_amplitude)
    for i = 1:length(ccut_period)
        ccut_freq = 1/ccut_period(i);
        x = linspace(0, num_ccuts*pi*ccut_period(i), num_ccuts*pi*ccut_period(i))

        right_foot_pos = sin(ccut_freq * x) + stance_spacing;
        left_foot_pos = sin(ccut_freq * x) - stance_spacing;
        right_foot_min = stance_spacing;
        left_foot_min = -1 * stance_spacing;

        for j = 1:length(right_foot_pos)
            if right_foot_pos(j) < right_foot_min
                right_foot_pos(j) = right_foot_min % - (randomness * rand());
            end

            if left_foot_pos(j) > left_foot_min
                left_foot_pos(j) = left_foot_min % + (randomness * rand());
            end

        end
        right_foot_pos = smooth(right_foot_pos);
        left_foot_pos = smooth(left_foot_pos);
    %     figure(i);
        axis equal;
%         plot(body_sway); hold on
        plot(right_foot_pos); hold on
        plot(left_foot_pos); hold on
    end
end