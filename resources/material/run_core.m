function run_core()
% Generate the core (ferrite) material data.
%
%    Map the different materials with a unique id.
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% init
addpath(genpath('utils'))
close('all');

% unique id
id_vec = [49 87.1 87.2 87.3 95 97];

% parse data
data = {};
for i=1:length(id_vec)
   material = get_data(id_vec(i));
   data{end+1} = struct('id', id_vec(i), 'material', material);
end

% material type
type = 'core';

% save material
save('data/core_data.mat', 'data', 'type')

end

function material = get_data(id)
% Generate the core (ferrite) material data.
%
%    Parameters:
%        id (int): material id
%
%    Returns:
%        material (struct): material data

% get values
switch id
    case 49
        rho = 4750;
        kappa = 12.5;
        data_map = load('loss_map/N49_ac.mat');
        data_fact_dc = load('loss_map/N87_ac_dc.mat');
    case 87.1
        rho = 4850;
        kappa = 7.0;
        data_map = load('loss_map/N87_ac.mat');
        data_fact_dc = load('loss_map/N87_ac_dc.mat');
    case 87.2
        rho = 4850;
        kappa = 7.0;
        data_map = load('loss_map/N87_ac_dc.mat');
        data_fact_dc = load('loss_map/N87_ac_dc.mat');
    case 87.3
        rho = 4850;
        kappa = 7.0;
        data_map = load('loss_map/N87_ac_dc_wide.mat');
        data_fact_dc = load('loss_map/N87_ac_dc_wide.mat');
    case 95
        rho = 4900;
        kappa = 9.5;
        data_map = load('loss_map/N95_ac.mat');
        data_fact_dc = load('loss_map/N87_ac_dc.mat');
    case 97
        rho = 4850;
        kappa = 7.5;
        data_map = load('loss_map/N97_ac.mat');
        data_fact_dc = load('loss_map/N87_ac_dc.mat');
    otherwise
        error('invalid id')
end

% assign param
material.param.rho = rho; % volumetric density
material.param.kappa = kappa; % cost per mass

% assign constant
material.param.fact_igse = 0.1; % factor for computing alpha and beta for IGSE (gradient in log scale)
material.param.B_sat_max = 300e-3; % saturation flux density
material.param.P_max = 1000e3; % maximum loss density
material.param.P_scale = 1.1; % scaling factor for losses
material.param.T_max = 130.0; % maximum temperature
material.param.c_offset = 0.3; % cost offset

% add values for losses interpolations
material.interp.f_vec = logspace(log10(25e3), log10(1e6), 20);  % frequency vector
material.interp.B_ac_peak_vec = logspace(log10(2.5e-3), log10(250e-3), 20); % AC flux density vector
material.interp.B_dc_vec = 0e-3:10e-3:300e-3; % DC flux density vector
material.interp.T_vec = 20:10:140;  % temperature vector

% control for interpolation
param.fact_dc = true; % use (or not) the a correction factor for the DC bias
param.clamp_dc = true; % clamp (or not) the DC bias correction data
param.limit_dc = [1.0 4.0]; % limit the DC bias correction data to value greater

% interpolate losses
material.interp.P_mat = get_loss_map(data_map, data_fact_dc, param, material.interp); % loss matrix
   
end