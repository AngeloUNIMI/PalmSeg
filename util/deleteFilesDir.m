function deleteFilesDir(directory, type)

files = dir([directory '*.' type]);

for f = 1 : numel(files)
    delete([directory '/' files(f).name]);
end %for f