%% example inputs 
num_ccuts = 6; % Must be an even number. Number per leg will be half this.
ccut_period = 8; % this vector is whatever ccut periods you want to plot
randomness = 1; % multiplier used to magnify the rand() function. higher number is noisier data
stance_spacing = 8; % dist between centerline and food in inches when standing normally
ccut_amplitude = (49 - 16) / 2; % additional stance width at peak of ccut in inches

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
t1 = linspace(5.1, 5.43,q_period);
t2 = linspace(5.43, 5.73, q_period);

t3 = linspace(5.73, 5.73+(6.63-5.73)/2, q_period);
t4 = linspace(5.73+(6.63-5.73)/2, 6.63, q_period);
%         t3 = linspace(5.73, 6.63, q_period);
%         t4 = linspace(6.27, 6.5, q_period);

t5 = linspace(6.63, 7.07, q_period);
t6 = linspace(7.07, 7.37, q_period);
%         t5 = linspace(6.5, 7.07, q_period);
%         t6 = linspace(7.07, 7.37, q_period);

t7 = linspace(7.37, 7.37+(8.13-7.37)/2, q_period);
t8 = linspace(7.37+(8.13-7.37)/2, 8.13, q_period);
%         t7 = linspace( 7.37, 7.73, q_period);
%         t8 = linspace(7.73, 8.03, q_period);

t9 = linspace(8.13, 8.4, q_period);
t10 = linspace(8.4, 8.63, q_period);
%         t9 = linspace(8.03, 8.4, q_period);
%         t10 = linspace(8.4, 8.63, q_period);

t11 = linspace(8.63, 9.0, q_period);
%         t11 = linspace(8.63, 9.0, q_period);
%         t12 = linspace(9.0, 9.23, q_period);

%% left y
figure(1)
% xlim([0, 10])
index = q_period;

temp = left_foot_pos;
ay = zeros(length(temp));

t = t1(2)-t1(1);
for i = 2:(index-1)
    ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

plot(t1(2:(index-1)), ay(2:(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t2(2)-t2(1);
for i = (old_index+1):(index-1)
    ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

% plot(t2, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t1(length(t1)-1), t2(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t2(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t3(2)-t3(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t3, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t2(length(t2)-1), t3(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t3(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t4(2)-t4(1);
for i = (old_index+1):(index-1)
    
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
    
end
% plot(t4, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t3(length(t3)-1), t4(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t4(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t5(2)-t5(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t5, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t4(length(t4)-1), t5(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t5(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t6(2)-t6(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t6, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t5(length(t5)-1), t6(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t6(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t7(2)-t7(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t7, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t6(length(t6)-1), t7(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t7(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t8(2)-t8(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t8, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t7(length(t7)-1), t8(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t8(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t9(2)-t9(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t9, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t8(length(t8)-1), t9(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t9(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t10(2)-t10(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t10, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t9(length(t9)-1), t10(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t10(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t11(2)-t1(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t11, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t10(length(t10)-1), t11(2)], [ay(old_index-1),ay(old_index+1)], 'b');
plot(t11(2:(q_period-1)), ay((old_index+1):(index-1)), 'b'); hold on
% old_index = index;
% index = index + q_period-1;
%         plot(t12, right_foot_pos(old_blah:(blah-2)), 'r'); hold on
%         plot(t12, left_foot_pos(old_blah:(blah-2)), 'b'); hold on


%% left x
figure(2)
index = q_period;
temp = x;
ax = zeros(length(temp));

t = t1(2)-t1(1);
for i = 2:(index-1)
    ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

plot(t1(2:(index-1)), ax(2:(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t2(2)-t2(1);
for i = (old_index+1):(index-1)
    ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

% plot(t2, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t1(length(t1)-1), t2(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t2(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t3(2)-t3(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t3, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t2(length(t2)-1), t3(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t3(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t4(2)-t4(1);
for i = (old_index+1):(index-1)
    
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
    
end
% plot(t4, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t3(length(t3)-1), t4(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t4(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t5(2)-t5(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t5, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t4(length(t4)-1), t5(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t5(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t6(2)-t6(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t6, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t5(length(t5)-1), t6(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t6(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t7(2)-t7(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t7, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t6(length(t6)-1), t7(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t7(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t8(2)-t8(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t8, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t7(length(t7)-1), t8(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t8(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t9(2)-t9(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t9, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t8(length(t8)-1), t9(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t9(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t10(2)-t10(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t10, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t9(length(t9)-1), t10(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t10(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t11(2)-t1(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t11, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t10(length(t10)-1), t11(2)], [ax(old_index-1),ax(old_index+1)], 'b');
plot(t11(2:(q_period-1)), ax((old_index+1):(index-1)), 'b'); hold on

%% right time
t1 = linspace(5.1, 5.1+(5.87-5.1)/2, q_period);
t2 = linspace(5.1+(5.87-5.1)/2, 5.87, q_period);
%         t1 = linspace(5.1, 5.43,q_period);
%         t2 = linspace(5.43, 5.73, q_period);

%         t3 = linspace(5.73, 5.73+(6.63-5.73)/2, q_period);
%         t4 = linspace(5.73+(6.63-5.73)/2, 6.63, q_period);
t3 = linspace(5.87, 6.27, q_period);
t4 = linspace(6.27, 6.5, q_period);

%         t5 = linspace(6.63, 7.07, q_period);
%         t6 = linspace(7.07, 7.37, q_period);
t5 = linspace(6.5, 6.5+ (7.53-6.5)/2, q_period);
t6 = linspace(6.5+ (7.53-6.5)/2, 7.53, q_period);

%         t7 = linspace(7.37, 7.37+(8.13-7.37)/2, q_period);
%         t8 = linspace(7.37+(8.13-7.37)/2, 8.13, q_period);
t7 = linspace( 7.53, 7.73, q_period);
t8 = linspace(7.73, 8.03, q_period);

%         t9 = linspace(8.13, 8.4, q_period);
%         t10 = linspace(8.4, 8.63, q_period);
t9 = linspace(8.03, 8.03+(8.87-8.03)/2, q_period);
t10 = linspace(8.03+(8.87-8.03)/2, 8.87, q_period);

t11 = linspace(8.87, 9.0, q_period);
%         t11 = linspace(8.63, 9.0, q_period);
%         t12 = linspace(9.0, 9.23, q_period);

%% right y
figure(1)
index = q_period;

temp = right_foot_pos;
ay = zeros(length(temp));

t = t1(2)-t1(1);
for i = 2:(index-1)
    ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

plot(t1(2:(index-1)), ay(2:(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t2(2)-t2(1);
for i = (old_index+1):(index-1)
    ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

% plot(t2, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t1(length(t1)-1), t2(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t2(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t3(2)-t3(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t3, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t2(length(t2)-1), t3(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t3(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t4(2)-t4(1);
for i = (old_index+1):(index-1)
    
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
    
end
% plot(t4, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t3(length(t3)-1), t4(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t4(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t5(2)-t5(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t5, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t4(length(t4)-1), t5(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t5(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t6(2)-t6(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t6, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t5(length(t5)-1), t6(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t6(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t7(2)-t7(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t7, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t6(length(t6)-1), t7(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t7(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t8(2)-t8(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t8, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t7(length(t7)-1), t8(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t8(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t9(2)-t9(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t9, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t8(length(t8)-1), t9(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t9(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t10(2)-t10(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t10, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t9(length(t9)-1), t10(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t10(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t11(2)-t1(1);
for i = (old_index+1):(index-1)
        ay(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t11, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t10(length(t10)-1), t11(2)], [ay(old_index-1),ay(old_index+1)], 'r');
plot(t11(2:(q_period-1)), ay((old_index+1):(index-1)), 'r'); hold on

%% right x
figure(2)
index = q_period;

temp = x;
ax = zeros(length(temp));

t = t1(2)-t1(1);
for i = 2:(index-1)
    ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

plot(t1(2:(index-1)), ax(2:(index-1)), 'b'); hold on
old_index = index;
index = index + q_period-1;

t = t2(2)-t2(1);
for i = (old_index+1):(index-1)
    ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end

% plot(t2, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t1(length(t1)-1), t2(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t2(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t3(2)-t3(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t3, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t2(length(t2)-1), t3(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t3(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t4(2)-t4(1);
for i = (old_index+1):(index-1)
    
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
    
end
% plot(t4, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t3(length(t3)-1), t4(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t4(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t5(2)-t5(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t5, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t4(length(t4)-1), t5(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t5(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t6(2)-t6(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t6, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t5(length(t5)-1), t6(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t6(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t7(2)-t7(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t7, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t6(length(t6)-1), t7(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t7(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t8(2)-t8(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t8, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t7(length(t7)-1), t8(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t8(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t9(2)-t9(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t9, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t8(length(t8)-1), t9(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t9(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t10(2)-t10(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t10, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t9(length(t9)-1), t10(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t10(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on
old_index = index;
index = index + q_period-1;

t = t11(2)-t1(1);
for i = (old_index+1):(index-1)
        ax(i) = (temp(i-1)-2*temp(i)+temp(i+1))/(t*t);
end
% plot(t11, right_foot_pos(old_index:(index)), 'r'); hold on
plot([t10(length(t10)-1), t11(2)], [ax(old_index-1),ax(old_index+1)], 'r');
plot(t11(2:(q_period-1)), ax((old_index+1):(index-1)), 'r'); hold on



figure(1)
title('Accelerations left and right of skater');
ylabel('Acceleration (in/s^2)');
xlabel('Time (s)');
legend('Right Ankle', 'Left Ankle');


figure(2)
title('Accelerations in direction of travel');
ylabel('Acceleration (in/s^2)');
xlabel('Time (s)');
legend('Right Ankle', 'Left Ankle');