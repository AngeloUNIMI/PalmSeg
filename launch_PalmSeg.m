clc
close all
clear variables
warning('on', 'all');
fclose('all');
addpath(genpath('./Functions_Segm'));
addpath(genpath('./Functions_ROI'));
addpath(genpath('./util'));
addpath('./params');


%--------------------------------------
%params
plotta = 1;
savefile = 1;
log = 1;

%--------------------------------------
%start parallel pool
nworkersdouble = 4;
% start_pool(nworkersdouble);

%--------------------------------------
%dbname
dbname_All = { ...
    'Tongji_Contactless_Palmprint_Dataset', ...
    };
ext = 'bmp';
dirWorkspace = './images/';


%--------------------------------------
%loop on dbs
for db = 1 : numel(dbname_All)
    
    %dbname
    dbname = dbname_All{db};
    fprintf(1, [dbname '\n']);
    
    %DB-specific params
    run(['./params/params_' dbname '.m']);
    
    %TEST: segmentation info (angle, center)
    dirTestImgs = [dirWorkspace dbname '/'];
    dirSegInfoTest = [dirTestImgs 'SegInfos/'];
    mkdir_pers(dirSegInfoTest, savefile);
    %TEST: possible ROIs (can be computed again after)
    dirROIs = [dirTestImgs 'ROIs_possible/'];
    mkdir_pers(dirROIs, savefile);
    
    %RESULT: dirs
    dirResults = ['./Results/' dbname '/'];
    mkdir_pers(dirResults, savefile);
    deleteFilesDir(dirResults, 'jpg');
    %RESULT: pdf/jpg output
    pdfFile = [dirResults dbname '_results_graphic.pdf'];
    if exist(pdfFile, 'file') == 2
        delete(pdfFile);
    end %if exist
    dirTemp = './temp/';
    deleteFilesDir(dirTemp, 'jpg');
    %RESULT: log
    timeStampRaw = datestr(datetime);
    timeStamp = strrep(timeStampRaw, ':', '-');
    %RESULT: params in mat format
    %txtFileParams = './Results/params.mat';
    %save(txtFileParams, 'param');
    
    %--------------------------------------
    %get images
    fprintf(1, 'Extracting valley points...\n');
    filesImgs = dir([dirTestImgs '*.' ext]);
    
    %init
    id = zeros(numel(filesImgs), 1);
    fidLog = cell(numel(filesImgs), 1);

    %test image
    for gg = 1 : numel(filesImgs)

        %log file, one for each worker
        t = getCurrentTask();
        if numel(t) > 0
            id(gg) = t.ID;
        else %if numel(t > 0)
            id(gg) = 0;
        end %if numel(t > 0)
        if savefile && log
            logFile = [dirResults dbname '_log_' timeStamp '_Lab' num2str(id(gg)) '.txt'];
            fidLog{gg} = fopen(logFile, 'a');
        end %if log
        
        %image
        filename = filesImgs(gg).name;
        input_image = imread([dirTestImgs filename]);
        
        %display progress
        fprintf(1, ['\t%4d: ' filename ': '], gg)
        if savefile && log
            fprintf(fidLog{gg}, ['\t%4d: ' filename ': '], gg);
        end %if log
        
        %simple thresholding
        [shapeFinal, centroid, orientM, bw] = segmentPalms(input_image, param, dbname, filename, dirTemp, savefile, plotta);
        
        %find roi - size of roi is adaptive of distance between finger valleys
        %CASIA: roisz: 192 xoffset: 150
        [ROI, errorC, resultsROI] = findROI_fromShape(input_image, bw, shapeFinal, centroid, param, dbname, filename, dirTemp, savefile, plotta);
        %if numel(ROI) == 0 && errorC == -1
        if numel(find(errorC==-1)) >= 1
            fprintf(1, 'Error: cannot extract ROI\n');
            if savefile && log
                fprintf(fidLog{gg}, 'Error: cannot extract ROI\n');
            end %if log
            %continue
        else %if errorC
            %is OK
            fprintf(1, 'OK\n');
            if savefile
                C = strsplit(filename, '.');
                writeSegInfoFile([dirSegInfoTest C{1} '_resultsROI.dat'], resultsROI);
                imwrite(ROI, [dirROIs filename])
            end %if savefile
            if savefile && log
                fprintf(fidLog{gg}, 'OK\n');
            end %if log
        end %if errorC
        
        %combine graphic results
        if plotta && savefile
            C = strsplit(filename, '.');
            res1file = [dirTemp C{1} '_Segm.jpg'];
            res2file = [dirTemp C{1} '_ROI.jpg'];
            resAll = combineResultsGraphic(res1file, res2file, 'horizontal');
            imwrite(resAll, [dirResults dbname '_' C{1} '.jpg']);
            delete(res1file);
            delete(res2file);
        end %if plotta
        
        %pause
        if plotta
            %close all
            pause(0.5)
        end %if plotta
        
        %close log file
        if savefile && log
            fclose(fidLog{gg});
        end %if log
        
        %pause
        
    end %for gg
    
    
end %for db



