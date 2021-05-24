function plotglow(iono, times, glat, glon)
arguments
  iono (1,1) struct
  times (1,1) datetime
  glat (1,1) {mustBeFinite}
  glon (1,1) {mustBeFinite}
end

%% Density / temperature
denstemp(iono)

%% particle flux
partflux(iono)
%% optical emissions
intensity(iono)
%% production, loss
prodloss(iono)
end

function labelax(ax)
grid(ax,'on')
legend(ax, 'show')
xlabel(ax, 'intensity [R]')
end

function partflux(iono)
ttxt = 'Particle Flux';
fig=figure(2); clf(2)
set(fig, 'Name', ttxt)
ax = axes('parent', fig);
semilogx(ax, iono.energy_bin_centers, iono.Eflux)
grid(ax, 'on')
title(ax, ttxt)
xlabel(ax, 'energy bin centers [eV]')
ylabel(ax, 'hemispherical flux [cm^{-2} s^{-1} eV^{-1}')
end

function intensity(iono)
fig=figure(3); clf(3)
set(fig, 'Name', 'Optical Emissions','units', 'normalized')
w = get(fig, 'position');
if w(3) < 0.5
  set(fig, 'position', [0.1, 0.1, 0.8, 0.5])
end

t = tiledlayout(1, 3, 'parent', fig);
ax = nexttile(t);
hold(ax, 'on')
semilogx(ax, iono.A4278, iono.altkm, 'displayname', '4278', 'color','blue')
semilogx(ax, iono.A5577, iono.altkm, 'displayname', '5577', 'color', 'green')
semilogx(ax, iono.A6300, iono.altkm, 'displayname', '6300', 'color', 'red')
semilogx(ax, iono.A5200, iono.altkm, 'displayname', '5200')
%xlim(ax, [0, 3])
set(ax, 'xscale', 'log')
ylim(ax, [90,500])
title(ax, 'visible')
labelax(ax)
ylabel(ax, 'altitude [km]')

ax = nexttile(t);
hold(ax, 'on')
semilogx(ax, iono.A7774, iono.altkm, 'displayname', '7774')
semilogx(ax, iono.A8446, iono.altkm, 'displayname', '8446')
semilogx(ax, iono.A7320, iono.altkm, 'displayname', '7320')
semilogx(ax, iono.A10400, iono.altkm, 'displayname', '10400')
%xlim(ax, [0, 0.1])
set(ax, 'xscale', 'log')
ylim(ax, [90,500])
title(ax, 'infrared')
labelax(ax)

ax = nexttile(t);
hold(ax, 'on')

semilogx(ax, iono.A3371, iono.altkm, 'displayname', '3371')
semilogx(ax, iono.A3644, iono.altkm, 'displayname', '3644')
semilogx(ax, iono.A3726, iono.altkm, 'displayname', '3726')
semilogx(ax, iono.LBH, iono.altkm, 'displayname', 'LBH')
semilogx(ax, iono.A1356, iono.altkm, 'displayname', '1356')
semilogx(ax, iono.A1493, iono.altkm, 'displayname', '1493')
semilogx(ax, iono.A1304, iono.altkm, 'displayname', '1304')
%xlim(ax, [0, 1])
set(ax, 'xscale', 'log')
ylim(ax, [90,500])
title(ax, 'ultraviolet')
labelax(ax)
end

function denstemp(iono)
fig=figure(1); clf(1)
ttxt = 'Plasma parameters';
set(fig, "name", ttxt)
t = tiledlayout(1,2, 'parent', fig);
ax = nexttile(t);
hold(ax, 'on')

%try
%sgtitle(hp, {[datestr(times),' deg.  (',num2str(glat),', ', num2str(glon),')']})
%end

semilogx(ax, iono.O, iono.altkm, 'DisplayName', 'O')
semilogx(ax, iono.N2, iono.altkm, 'DisplayName', 'N_2')
semilogx(ax, iono.NO, iono.altkm, 'DisplayName', 'NO')
semilogx(ax, iono.Oplus, iono.altkm, 'DisplayName', 'NO^+')
semilogx(ax, iono.O2plus, iono.altkm, 'DisplayName', 'NO_2^+')
semilogx(ax, iono.N2D, iono.altkm, 'DisplayName', 'N_2(D)')

title(ax, 'Number Densities')
xlabel(ax, 'Density [cm^-3]')
ylabel(ax, 'altitude [km]')
xlim(ax, [1e4,1e16])

set(ax,'xscale','log')
grid(ax, 'on')
legend(ax, 'show','location','northeast')

%% Temperature Profiles

ax = nexttile(t);
hold(ax, 'on')

plot(ax, iono.Tn, iono.altkm, 'DisplayName', 'T_n')
plot(ax, iono.Ti, iono.altkm, "DisplayName", "T_i")
plot(ax, iono.Te, iono.altkm, "DisplayName", "T_e")

title(ax, 'Temperature')
xlabel(ax, 'Temperature [K]')
ylabel(ax, 'altitude [km]')

grid(ax, 'on')
legend(ax, 'show','location','northeast')
end

function prodloss(iono)

fig = figure(4); clf(4)
set(fig, 'Name', 'production')

t = tiledlayout(1, 2, 'parent', fig);
ax = nexttile(t);
hold(ax, 'on')

semilogx(ax, iono.production, iono.altkm)
semilogx(ax, sum(iono.production, 2), iono.altkm)

ylabel(ax, 'altitude [km]')
xlabel(ax,'per-species production cm^{-3} s^{-1}')
title(ax, 'Production')
grid(ax, 'on')
set(ax, 'xscale', 'log')
%%
ax = nexttile(t);
hold(ax, 'on')

semilogx(ax, iono.loss, iono.altkm)
semilogx(ax, sum(iono.loss, 2), iono.altkm)

xlabel(ax,'per-species loss cm^{-3} s^{-1}')
title(ax, 'Loss')
grid(ax, 'on')
set(ax, 'xscale', 'log')

end
