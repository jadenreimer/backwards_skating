x = [linspace(0, pi/2, 100) linspace(pi/2, 0, 100)];

figure;
pause(3)
for i = 1:length(x)
    plot([0 cos(x(i))], [0 sin(x(i))], [0 -0.5*cos(x(i))], [0 0], 'b', [0 0], [0 -0.5*sin(x(i))], 'r')
    
    axis([-0.6 1.1 -0.6 1.1]) % x0 x1 y0 y1
    drawnow
end