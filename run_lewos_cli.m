% run_lewos_cli.m
% Command-line version of LeWoS
% Usage: run_lewos_cli(input_folder, output_folder)

function run_lewos_cli(input_folder, output_folder)
    if nargin < 2
        error('Usage: run_lewos_cli(input_folder, output_folder)');
    end

    files = dir(fullfile(input_folder, '*.ply')); 

    for k = 1:length(files)
        infile = fullfile(files(k).folder, files(k).name);
        fprintf('Processing %s...\n', infile);

        % Load point cloud
        points = load_point_cloud(infile); 

        % Call the segmentation
        [BiLabel, BiLabel_Regu] = RecursiveSegmentation_release(points, 0.125, 1, 0);

        % Save results
        [~, name, ~] = fileparts(files(k).name);
        save(fullfile(output_folder, [name '_label.mat']), 'BiLabel', 'BiLabel_Regu');
    end
end


