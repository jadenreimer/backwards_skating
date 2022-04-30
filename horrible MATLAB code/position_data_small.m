%% example inputs 
num_ccuts = 6; % Must be an even number. Number per leg will be half this.
ccut_period = 8; % this vector is whatever ccut periods you want to plot
randomness = 1; % multiplier used to magnify the rand() function. higher number is noisier data
stance_spacing = 8.25; % dist between centerline and food in inches when standing normally
ccut_amplitude = (23 - 16) / 2; % additional stance width at peak of ccut in inches

small = 23;
medium = 34;
large = 49;

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
        x = linspace(0, num_ccuts*pi*ccut_period(i), num_ccuts*pi*ccut_period(i));
        
        [minValue,closestIndex] = min(abs(x-pi*ccut_period));
        q_period = closestIndex/2;

        right_foot_pos = ccut_amplitude * sin(ccut_freq * x) + stance_spacing;
        left_foot_pos = ccut_amplitude * sin(ccut_freq * x) - stance_spacing;
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
%         plot(diff(diff(right_foot_pos))); hold on
%         plot(body_sway); hold on
    end
   
end
%% left time
t1 = linspace(5.8, 5.8+(6.77-5.8)/2, q_period);
t2 = linspace(5.8+(6.77-5.8)/2, 6.77, q_period);
%         t1 = linspace(5.8, 6.73,q_period);
%         t2 = linspace(6.73, 6.9, q_period);

%         t3 = linspace(6.9, 6.9+(8-6.9)/2, q_period);
%         t4 = linspace(6.9+(8-6.9)/2, 8, q_period);
t3 = linspace(6.77, 6.97, q_period);
t4 = linspace(6.97, 7.33, q_period);

%         t5 = linspace(8, 8.3, q_period);
%         t6 = linspace(8.3, 8.57, q_period);
t5 = linspace(7.33, 7.33+ (8.33-7.33)/2, q_period);
t6 = linspace(7.33+ (8.33-7.33)/2, 8.33, q_period);

%         t7 = linspace(8.57, 8.57+(9.43-8.57)/2, q_period);
%         t8 = linspace(8.57+(9.43-8.57)/2, 9.43, q_period);
t7 = linspace( 8.33, 8.53, q_period);
t8 = linspace(8.53, 8.8, q_period);

%         t9 = linspace(9.43, 9.77, q_period);
%         t10 = linspace(9.77, 10.1, q_period);
t9 = linspace(8.8, 8.8+(9.87-8.8)/2, q_period);
t10 = linspace(8.8+(9.87-8.8)/2, 9.87, q_period);

t11 = linspace(9.87, 10.1, q_period);
%         t11 = linspace(10.1, 10.1, q_period);
%         t12 = linspace(10.1, 9.23, q_period);


%% left y
figure(1)
axis([0, 10, -10,10])
index = q_period;
% plot(t1, right_foot_pos(1:index), 'r'); hold on
plot(t1, left_foot_pos(1:index), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t2, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t2, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t3, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t3, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t4, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t4, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t5, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t5, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t6, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t6, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t7, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t7, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t8, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t8, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t9, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t9, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t10, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t10, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t11, right_foot_pos(old_index:(index)), 'r'); hold on
plot(t11, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
%         plot(t12, right_foot_pos(old_blah:(blah-2)), 'r'); hold on
%         plot(t12, left_foot_pos(old_blah:(blah-2)), 'b'); hold on

%% left x
figure(2)
index = q_period;
% plot(t1, x(1:index), 'r'); hold on
plot(t1, x(1:index), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t2, x(old_index:(index)), 'r'); hold on
plot(t2, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t3, x(old_index:(index)), 'r'); hold on
plot(t3, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t4, x(old_index:(index)), 'r'); hold on
plot(t4, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t5, x(old_index:(index)), 'r'); hold on
plot(t5, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t6, x(old_index:(index)), 'r'); hold on
plot(t6, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t7, x(old_index:(index)), 'r'); hold on
plot(t7, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t8, x(old_index:(index)), 'r'); hold on
plot(t8, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t9, x(old_index:(index)), 'r'); hold on
plot(t9, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t10, x(old_index:(index)), 'r'); hold on
plot(t10, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
% plot(t11, x(old_index:(index)), 'r'); hold on
plot(t11, x(old_index:(index)), 'b'); hold on

%% right time
t1 = linspace(5.8, 6.73,q_period);
t2 = linspace(6.73, 6.9, q_period);

t3 = linspace(6.9, 6.9+(8-6.9)/2, q_period);
t4 = linspace(6.9+(8-6.9)/2, 8, q_period);
%         t3 = linspace(6.9, 8, q_period);
%         t4 = linspace(6.97, 7.33, q_period);

t5 = linspace(8, 8.3, q_period);
t6 = linspace(8.3, 8.57, q_period);
%         t5 = linspace(7.33, 8.3, q_period);
%         t6 = linspace(8.3, 8.57, q_period);

t7 = linspace(8.57, 8.57+(9.43-8.57)/2, q_period);
t8 = linspace(8.57+(9.43-8.57)/2, 9.43, q_period);
%         t7 = linspace( 8.57, 8.53, q_period);
%         t8 = linspace(8.53, 8.8, q_period);

t9 = linspace(9.43, 9.77, q_period);
t10 = linspace(9.77, 10.1, q_period);
%         t9 = linspace(8.8, 9.77, q_period);
%         t10 = linspace(9.77, 10.1, q_period);

t11 = linspace(10.1, 10.1, q_period);
%         t11 = linspace(10.1, 10.1, q_period);
%         t12 = linspace(10.1, 9.23, q_period);
%% right y
figure(1)
index = q_period;
plot(t1, right_foot_pos(1:index), 'r'); hold on
% plot(t1, left_foot_pos(1:index), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t2, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t2, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t3, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t3, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t4, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t4, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t5, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t5, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t6, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t6, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t7, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t7, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t8, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t8, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t9, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t9, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t10, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t10, left_foot_pos(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t11, right_foot_pos(old_index:(index)), 'r'); hold on
% plot(t11, left_foot_pos(old_index:(index)), 'b'); hold on

%% right x
figure(2)
index = q_period;
plot(t1, x(1:index), 'r'); hold on
% plot(t1, x(1:index), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t2, x(old_index:(index)), 'r'); hold on
% plot(t2, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t3, x(old_index:(index)), 'r'); hold on
% plot(t3, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t4, x(old_index:(index)), 'r'); hold on
% plot(t4, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t5, x(old_index:(index)), 'r'); hold on
% plot(t5, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t6, x(old_index:(index)), 'r'); hold on
% plot(t6, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t7, x(old_index:(index)), 'r'); hold on
% plot(t7, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t8, x(old_index:(index)), 'r'); hold on
% plot(t8, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t9, x(old_index:(index)), 'r'); hold on
% plot(t9, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t10, x(old_index:(index)), 'r'); hold on
% plot(t10, x(old_index:(index)), 'b'); hold on
old_index = index;
index = index + q_period-1;
plot(t11, x(old_index:(index)), 'r'); hold on
% plot(t11, x(old_index:(index)), 'b'); hold on


figure(1)
title('Ankle position over time');
ylabel('Position (in)');
legend('Right Ankle', 'Left Ankle');
xlabel('Time (s)');

figure(2)
title('Ankle displacement over time');
xlabel('Time (s)');
ylabel('Displacement (in)');
legend('Right Ankle', 'Left Ankle');

