function generateFFTDB(modelFile, computeFcn, flist, saveFilename)
% generateDB(modelFile,saveFilename)
%
%   generateDB computes hashprints on a set of studio tracks and saves 
%   the fingerprint database to the specified file.
%
%    modelFile: file specifying the hashprint model.  This is the file
%      produced by learnHashprintModel.  Note that this model file also
%      specifies the list of studio tracks to process.
%    saveFilename: the name of the file to save the fingerprint database
%
%   Note that, in addition to computing hashprints on the original studio
%   recordings, generateDB also computes hashprints on pitch-shifted
%   versions.
%
% 2016-07-08 TJ Tsai ttsai@g.hmc.edu

model = load(modelFile);
parameter = model.parameter;

fingerprints = {};
idx2file = {};

fid = fopen(flist);
curFileList = '';
fileIndex = 1;
curfile = fgetl(fid);
tmpfile = curfile;
while ischar(curfile)
    curFileList{fileIndex} = curfile;
    curfile = fgetl(fid);
    fileIndex = fileIndex + 1;
end

tic;
parfor index = 1 : length(curFileList)
    curfile = curFileList{index};
    disp(['Computing fingerprints on file ',num2str(index),': ',curfile]);
    Q = computeQSpec(curfile,parameter);
    spec = Q.c;
    curr = computeFcn(spec, model, parameter);
    cat3 = cat(3, curr, curr);
    fingerprints{index} = cat3;
    idx2file{index} = curfile;
end
toc
fclose(fid);

% compute hop size -- hack!
Q = computeQSpec(tmpfile,parameter);
hopsize = Q.xlen/(22050*size(Q.c,2))*3*parameter.hop;
    
disp(['Saving fingerprint database to file']);
save(saveFilename,'flist','parameter','model',...
    'fingerprints','idx2file','hopsize', '-v7.3');
