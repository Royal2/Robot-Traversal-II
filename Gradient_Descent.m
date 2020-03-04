clc; clear; close all;

initial_loc = [1,1];   %original
%initial_loc = [10,35];    %changed
cur_loc = initial_loc;
final_loc = [100,100];
%mu = [60, 50; 10, 40]; %original
mu = [20, 30; 80, 65];
sigma = [50, 0; 0, 50];

% Set up vector potential field
syms u v; % define symbolic variables to denote the coordintes on the potential field

% Symbolic equation that represents the potential field at any point (u, v)
z_sym(u, v) = (((final_loc(1,1)-u).^2 + (final_loc(1,2)-v).^2)/20000) + ...,
    1e4*(1/(det(sigma)*2*pi))*exp(-(1/2) .* [(u-mu(1,1)); (v-mu(1,2))]'*pinv(sigma)*[(u-mu(1,1)); (v-mu(1,2))]) + ...,
    1e4*(1/(det(sigma)*2*pi))*exp(-(1/2) .* [(u-mu(2,1)); (v-mu(2,2))]'*pinv(sigma)*[(u-mu(2,1)); (v-mu(2,2))]);

% Calculate symbolic derivatives of the field with respect to the coordinates u and v
dzdu_sym = diff(z_sym, u);
dzdv_sym = diff(z_sym, v);

% Convert symbolic functions into MATLAB functions for ease of use
z = matlabFunction(z_sym);
dx = matlabFunction(dzdu_sym);
dy = matlabFunction(dzdv_sym);
[x, y] = meshgrid(0:4:100);

%% Part 1
figure();
meshc(x, y, z(x,y)); hold on;
xlabel('x');
ylabel('y');
zlabel('z');
title('Contour and mesh plot of the vector field');
hold off;

% Above, we plot the mesh and contour plot as a single figure.
%
% a) Plot the contour plot and mesh of the vector field as separate figures.
% Useful functions are contour, mesh, surf, meshc, etc.
% Use x, y, and z(x, y) to plot the vector field.

figure;
contour(x,y,z(x,y));
xlabel('x');
ylabel('y');
title('Contour plot of the vector field');

figure;
mesh(x,y,z(x,y));
xlabel('x');
ylabel('y');
zlabel('z');
title('Mesh plot of the vector field');

figure;
surf(x,y,z(x,y));
xlabel('x');
ylabel('y');
zlabel('z');
colorbar
title('Surface plot of the vector field');

% b) Plot the gradient (dx, dy) as quivers over the contour plot
% Use x, y, dx(x,y), and dy(x,y) to plot the quivers

figure;
contour(x,y,z(x,y)); hold on;
quiver(x,y,dx(x,y),dy(x,y)); hold off;
xlabel('x');
ylabel('y');
title('Contour/quiver plot, gradient');

%potential fields, V=-grad
figure;
contour(x,y,z(x,y)); hold on;
quiver(x,y,-dx(x,y),-dy(x,y)); hold off;
xlabel('x');
ylabel('y');
title('Contour/quiver plot, vector potential');

% c) Indicate where the bot will begin, blue asterisk, and where the
% bot will finish, red asterisk. (Look through the code).
% start at initial_loc, end at final_loc

%contour/quiver
figure;
contour(x,y,z(x,y)); hold on;
quiver(x,y,dx(x,y),dy(x,y));
xlabel('x');
ylabel('y');
title('Contour/quiver plot with start and finish location');
plot(initial_loc(1),initial_loc(2), 'b*', 'markers', 10);
plot(final_loc(1),final_loc(2), 'r*', 'markers', 10);
hold off;

%mesh
figure;
mesh(x,y,z(x,y)); hold on;
xlabel('x');
ylabel('y');
zlabel('z');
title('Mesh plot with start and finsh location');
plot3(initial_loc(1),initial_loc(2),z(initial_loc(1),initial_loc(2)), 'b*', 'markers', 10);
plot3(final_loc(1),final_loc(2),z(final_loc(1),final_loc(2)), 'r*', 'markers', 10);
hold off;

%% Part 2
% Implement the algorithm from the discussion slides to control the bot
% through the vector field helping it reach it's final location.
% Plot each location it passes through as a blue asterisk, the final image
% should be the complete trajectory the bot takes.

%Press any key to begin the animation
pause;

%mesh plot
%figure; mesh(x,y,z(x,y)); hold on;
%xlabel('x'); ylabel('y'); zlabel('z');
%title('Bot trajectory (Mesh plot)');

%contour/quiver
figure;
contour(x,y,z(x,y)); hold on;
quiver(x,y,dx(x,y),dy(x,y));
xlabel('x');
ylabel('y');
title('Bot trajectory (Contour/quiver plot)');

cur_loc=initial_loc;    %initialize back to start
epsilom=2.8284e-04;
grad_A=[dx(cur_loc(1),cur_loc(2)), dy(cur_loc(1),cur_loc(2))];

while norm(grad_A) > epsilom
    % This line must be deleted and replaced with your gradient descent update,
    % it's here to show you how the bot might move.
    %cur_loc = cur_loc + [0,1];
    grad_A=[dx(cur_loc(1),cur_loc(2)), dy(cur_loc(1),cur_loc(2))];
    a=1/norm(grad_A);
    cur_loc=cur_loc-a*grad_A;
    %Plot the bots current location on the mesh.
    %plot3(cur_loc(1,1), cur_loc(1,2), z(cur_loc(1,1), cur_loc(1,2)), '*b');
    plot(cur_loc(1,1), cur_loc(1,2), '*b');
    pause(.1);
end
%final location
%plot3(cur_loc(1,1), cur_loc(1,2), z(cur_loc(1,1), cur_loc(1,2)), '*r');
plot(cur_loc(1,1), cur_loc(1,2), 'r*', 'markers', 10);
hold off;

%% determing epsilom value
%end at room(x,y)=[100,100]
x_test=98;
y_test=98;
norm([dx(x_test,y_test), dy(x_test,y_test)])