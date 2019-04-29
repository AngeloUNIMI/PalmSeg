function writeSegInfoFile(filename, resultsROI)

fid = fopen(filename, 'w');

%get field names
names = fieldnames(resultsROI);

%print contents
for n = 1 : numel(names)
    
    fprintf(fid, '%s\n', names{n});
    value = getfield(resultsROI, names{n});
    
    for i = 1 : size(value, 1)
        for j = 1 : size(value, 2)
            fprintf(fid, '%f ', value(i,j));
        end %for j
        fprintf(fid, '\n');
    end %for i
    
    fprintf(fid, '\n');
    
end %for n

%close file
fclose(fid);
