function points = read_ply(filepath)
    fid = fopen(filepath,'rb');
    if fid == -1
        error('Cannot open file: %s', filepath);
    end

    vertex_count = 0;
    while true
        line = fgetl(fid);
        if ~ischar(line), error('Unexpected EOF'); end
        if strncmp(line,'element vertex',14)
            parts = strsplit(line);
            vertex_count = str2double(parts{3});
        elseif strcmp(line,'end_header')
            break;
        end
    end

    if vertex_count == 0, error('PLY file has no vertices'); end

    % Read binary vertex data (assume float32 x,y,z)
    points = fread(fid,[3 vertex_count],'float32');
    fclose(fid);
end


