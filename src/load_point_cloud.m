function points = load_point_cloud(filepath)
    [~,~,ext] = fileparts(filepath);
    switch lower(ext)
        case '.ply'
            ptCloud = pcread(filepath);
            points = ptCloud.Location;
        otherwise
            error('Unsupported file type: %s', ext);
    end
end