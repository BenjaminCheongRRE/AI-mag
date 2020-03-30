function run_1_fem()

init_toolbox();

%% run
run_sub('ht');
run_sub('mf');

end

function run_sub(model_type)

% sim_name
file_init = 'data/init.mat';
folder_fem = ['data/fem_' model_type];

% master_fem
[file_model, var_type, sweep] = get_fem_ann_data_fem(model_type, 'matrix', 2);
master_fem(file_init, folder_fem, file_model, model_type, var_type, sweep);

[file_model, var_type, sweep] = get_fem_ann_data_fem(model_type, 'random', 6000);
master_fem(file_init, folder_fem, file_model, model_type, var_type, sweep);

end
