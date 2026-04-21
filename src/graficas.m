%% Data (rows = RC dimension, columns = spectral radius)
rc_dim = [512; 128; 64; 16; 8];
rho    = [0.5 0.6 0.75 0.8 0.85 0.9 0.95 0.99];

Z = [ ...
    0.48 0.50 0.39 0.39 0.38 0.38 0.41 0.66;
    0.66 0.44 0.51 0.45 0.44 0.43 0.45 0.41;
    5.61 4.43 0.61 0.54 0.47 7.58 0.61 0.49;
    5.78 4.68 1.00 0.60 4.00 1.14 1.14 0.56;
    5.99 5.81 5.78 5.70 3.66 3.66 1.54 1.32];

function cmap = orangeToRedMap(n)
    if nargin < 1, n = 256; end

    % Define endpoints (RGB in [0,1])
    orange = [1.00 0.45 0.00];  % strong orange (no yellow)
    red    = [0.85 0.00 0.00];  % deep red

    % Convert to HSV for a clean hue transition without passing through yellow
    hsvO = rgb2hsv(orange);
    hsvR = rgb2hsv(red);

    % Interpolate hue/sat/value
    t = linspace(0,1,n)';
    hsv = zeros(n,3);

    % Hue: go from orange hue to red hue directly
    hsv(:,1) = (1-t)*hsvO(1) + t*hsvR(1);

    % Saturation: keep high, slightly increase to boost contrast
    hsv(:,2) = (1-t)*max(hsvO(2),0.90) + t*max(hsvR(2),0.98);

    % Value: slightly decrease towards red to increase perceived contrast
    hsv(:,3) = (1-t)*0.98 + t*0.75;

    cmap = hsv2rgb(hsv);

    % Clamp
    cmap = max(min(cmap,1),0);
end

%% Treat axes as categorical (equidistant spacing)
% We plot Z on a regular grid 1..M by 1..N and only label ticks.
Z_plot = Z;  % keep original row order: 512,128,64,16,8 (top to bottom)

figure('Color','w');
imagesc(Z_plot);

% Softer colormap (less contrast than jet/turbo)
colormap(orangeToRedMap(256));
cb = colorbar;
cb.Label.String = 'Error value (%)';   % rename if needed

% Equal spacing for both axes
axis tight;
axis ij;  % puts first row at the top (matches your table order)

% X axis labels = spectral radius
xticks(1:numel(rho));
xticklabels(string(rho));
xlabel('Spectral Radius \rho');

% Y axis labels = RC dimension (nodes)
yticks(1:numel(rc_dim));
yticklabels(string(rc_dim));
ylabel('RC Dimension (Nodes)');

title('Performance in stage test');

% Optional: improve readability
ax = gca;
ax.FontSize = 12;
ax.TickDir  = 'out';
