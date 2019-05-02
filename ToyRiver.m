close all;
clear; clc;

%% River-related parameters
dt = 0.5; % in h
dx = 0.5; % tile length, in m
nx = 2000; % number of tiles in the length direction
dy = 0.5; % tile width, in m
ny = 100; % number of tiles in the width direction
vmax = 0.001 * 3600; % max velocity of river along its center axis, in m/h

%% Turnover-related parameters
b = 0.045; % in h^(-1)
z = 0.04; % in h^(-1)
e = 0.7;
w = 0.006;
th = 0.0148; % in h^(-1)
kP = 0.015; % in mg/L
kB = 3; % in mg/L
DZ = 2.17e-6 * 3600; % in m^2/h
DP = 7.15e-10 * 3600; % in m^2/h

%% Plotting
FigureWindowPosition = [600, 250, 1200, 800];
BplotPosition = [0.130, 0.575, 0.729, 0.216];
ZplotPosition = [0.130, 0.450, 0.729, 0.216];
PplotPosition = [0.130, 0.325, 0.729, 0.216];

%% Dirichlet BC
B0 = 3.3636; % in mg/L
Z0 = 4.0909; % in mg/L
P0 = 0.0200; % in mg/L (eutrophic > 24)
fprintf('The total phosphorus level specified by the BC is %f mg/L.\n', ...
    w * (B0 + Z0) + P0);

%% Function handles
vyFun = @(y) (1 - ((2 * y - 1) / ny - 1) .^ 2) * vmax; % in m/h
BtFun = @(B, Z, P) b * P .* B ./ (P + kP) - z * B .* Z ./ (B + kB);
ZtFun = @(B, Z) (e * z * B ./ (B + kB) - th) .* Z;
PtFun = @(B, Z, P) - w * (BtFun(B, Z, P) + ZtFun(B, Z));

%% Derived parameters
% Advection-related
v = vyFun((1 : ny)'); % in m/h
AdvectionShiftCeil = ceil(v * dt / dx);
AdvectionShiftConvFactor = [AdvectionShiftCeil - v * dt / dx, ...
    1 + v * dt / dx - AdvectionShiftCeil];
TotalTimeStep = ceil(3 * dx * nx / (dt * v(1)));
% Diffusion-related
Ix = diag(ones(1, nx));
Ax = - 2 * Ix + diag([2; ones(nx - 2, 1)], -1) + ...
    diag([ones(nx - 2, 1); 2], 1);
Iy = diag(ones(1, ny));
Ay = - 2 * Iy + diag([2; ones(ny - 2, 1)], 1) + ...
    diag([ones(ny - 2, 1); 2], - 1);
alphaZx = DZ * dt / dx ^ 2 / 2;
alphaZy = DZ * dt / dy ^ 2 / 2;
alphaPx = DP * dt / dx ^ 2 / 2;
alphaPy = DP * dt / dy ^ 2 / 2;
I_Plus_alpha_A_Zy = Iy + alphaZy * Ay;
I_Minus_alpha_A_Inv_Zy = inv(Iy - alphaZy * Ay);
I_Minus_alpha_A_Inv_Zx = inv(Ix - alphaZx * Ax);
I_Plus_alpha_A_Py = Iy + alphaPy * Ay;
I_Minus_alpha_A_Inv_Py = inv(Iy - alphaPy * Ay);
I_Minus_alpha_A_Inv_Px = inv(Ix - alphaPx * Ax);
% Initialize river as a 3-D matrix
R = zeros(ny, nx, 3);
Bidx = 1;
Zidx = 2;
Pidx = 3;


% Simulation
tic;
for TimeStep = 1 : TotalTimeStep
    %% Reset (Dirichlet BC)
    R(:, 1, Bidx) = ones(ny, 1) * B0;
    R(:, 1, Zidx) = ones(ny, 1) * Z0;
    R(:, 1, Pidx) = ones(ny, 1) * P0;
    
    %% Advection
    for y = 1 : ny
        R(y, :, Bidx) = [ones(1, AdvectionShiftCeil(y) + 1) * B0, ...
            conv(R(y, 1 : (nx - AdvectionShiftCeil(y)), Bidx), ...
            AdvectionShiftConvFactor(y, :), 'valid')];
        R(y, :, Zidx) = [ones(1, AdvectionShiftCeil(y) + 1) * Z0, ...
            conv(R(y, 1 : (nx - AdvectionShiftCeil(y)), Zidx), ...
            AdvectionShiftConvFactor(y, :), 'valid')];
        R(y, :, Pidx) = [ones(1, AdvectionShiftCeil(y) + 1) * P0, ...
            conv(R(y, 1 : (nx - AdvectionShiftCeil(y)), Pidx), ...
            AdvectionShiftConvFactor(y, :), 'valid')];
    end
    
    %% Diffusion (Z & P) with the Bialecki-Fernandes method
    Z1 = I_Plus_alpha_A_Zy * R(:, :, Zidx);
    Z2 = Z1 * I_Minus_alpha_A_Inv_Zx;
    R(:, :, Zidx) = I_Minus_alpha_A_Inv_Zy * (2 * Z2 - Z1);
    P1 = I_Plus_alpha_A_Py * R(:, :, Pidx);
    P2 = P1 * I_Minus_alpha_A_Inv_Px;
    R(:, :, Pidx) = I_Minus_alpha_A_Inv_Py * (2 * P2 - P1);
    
    %% Runge-Kutta
    % Calculate total phosphorus within each tile
    C = w * (R(:, :, Bidx) + R(:, :, Zidx)) + R(:, :, Pidx);
    % Evolve B and Z for dt with Runge-Kutta
    B = R(:, :, Bidx);
    Z = R(:, :, Zidx);
    P = R(:, :, Pidx);
    % Step 1
    dB1 = dt * BtFun(B, Z, P);
    dZ1 = dt * ZtFun(B, Z);
    dP1 = dt * PtFun(B, Z, P);
    % Step 2
    dB2 = dt * BtFun(B + dB1 / 2, Z + dZ1 / 2, P + dP1 / 2);
    dZ2 = dt * ZtFun(B + dB1 / 2, Z + dZ1 / 2);
    dP2 = dt * PtFun(B + dB1 / 2, Z + dZ1 / 2, P + dP1 / 2);
    % Step 3
    dB3 = dt * BtFun(B + dB2 / 2, Z + dZ2 / 2, P + dP2 / 2);
    dZ3 = dt * ZtFun(B + dB2 / 2, Z + dZ2 / 2);
    dP3 = dt * PtFun(B + dB2 / 2, Z + dZ2 / 2, P + dP2 / 2);
    % Step 4
    dB4 = dt * BtFun(B + dB3, Z + dZ3, P + dP3);
    dZ4 = dt * ZtFun(B + dB3, Z + dZ3);
    % Evolve
    R(:, :, Bidx) = B + (dB1 + 2 * dB2 + 2 * dB3 + dB4) / 6;
    R(:, :, Zidx) = Z + (dZ1 + 2 * dZ2 + 2 * dZ3 + dZ4) / 6;
    % Calculate P after dt based on conservation
    R(:, :, Pidx) = max(C - w * (R(:, :, Bidx) + R(:, :, Zidx)), 0);
end
toc;


%% Plot results
figure(1);
set(gcf, 'Position', FigureWindowPosition);

Bplot = subplot(3, 1, Bidx);
hold on;
    imagesc(R(:, :, Bidx));
    title('Steady-state cyanobacteria density', 'FontSize', 14);
    if (dx == dy)
        axis image;
        axis off;
    else
        xlim([1, nx]);
        xticks('');
        ylim([1, ny]);
        yticks('');
    end
    set(get(colorbar, 'Title'), 'String', 'mg/L');
hold off;

Zplot = subplot(3, 1, Zidx);
hold on;
    imagesc(R(:, :, Zidx));
    title('Steady-state zooplankton density', 'FontSize', 14);
    if (dx == dy)
        axis image;
        axis off;
    else
        xlim([1, nx]);
        xticks('');
        ylim([1, ny]);
        yticks('');
    end
    set(get(colorbar, 'Title'), 'String', 'mg/L');
hold off;

Pplot = subplot(3, 1, Pidx);
hold on;
    imagesc(R(:, :, Pidx));
    title('Steady-state dissolved phosphorus concentration', ...
        'FontSize', 14);
    if (dx == dy)
        axis image;
        axis off;
    else
        xlim([1, nx]);
        xticks('');
        ylim([1, ny]);
        yticks('');
    end
    set(get(colorbar, 'Title'), 'String', 'mg/L');
hold off;

set(Bplot, 'Position', BplotPosition);
set(Zplot, 'Position', ZplotPosition);
set(Pplot, 'Position', PplotPosition);
