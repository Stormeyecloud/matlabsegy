%% Step1:Preparation
% Download Crews Matlab toolbox at https://www.crewes.org/ResearchLinks/FreeSoftware/crewes.zip
% Unzip Crews zip file and add them to matlab path
%% Step2:Locate and source Segy file
%  source the Segy file
tic
% s=SegyFile('pstm_cg_150.segy','r',[],[],[],[],[],[],[],[],1);
% []= Fig progressbar; 1=text progressbar ; 0=no progressbar;
[segyName,segyPath]=uigetfile({'*.sgy;*.segy;*.PSTM;*PSTM_SEGY';'*.sgy;*.segy';'*.segy'},'MultiSelect','on');
path=strcat(segyPath,segyName);
s=SegyFile(path,'r');
toc
%% Step3:Generate records data
% This will take a while if the segy file is huge. Once the record file is
% generated and we don't need to go through this procedure.

% Choose the directory to save your Records Data. Suggest saving to working
% directory.
tic
[recordsName, recordsPath] = uiputfile('records.dat');
if recordsName == 0
    return
end

fileID = fopen(strcat(recordsPath,recordsName),'w');
if fileID == -1 % Check the file existence
    errordlg('File does not exist, check your file path or file permission')
    return
end

fwrite(fileID,s.Trc.read(1:300),'double');
fclose(fileID);
msgbox(['[' segyName ']', ' converted to:',' ' ,'[' recordsName,']' , ', path: ' ,' ' ,recordsPath,recordsName])
toc
%% Step3:Link the records data to Matlab workspace

% input basic survy info
sample = s.FileInfo.SamplesPerTrace;
maxTrace = s.Trc.FileInfo.TracesInFile;
% Only when dealing with 3D survy
xlineNum = 369;
inlineNum = 661;

% segy 2D read format:
%SurvyFormat = double([sample maxTrace]);
% segy 3D read format:
%SurvyFormat = double([sample xlineNum inlineNum]);

SurvyFormat = double([sample xlineNum inlineNum]);

% Map records data into workspace
m = memmapfile('records.dat','Format',{'double', SurvyFormat, 'x'});

% Retrive seismic as m.Data.x(sampleRange,xlineRange,inlineRange)
load lmkRWB
% set xline=150 profile
figure;imagesc(squeeze(m.Data.x(:,150,:)));colormap(lmkrwb);
% set t=1500 time slice
figure;imagesc(squeeze(m.Data.x(1500,:,:)));colormap(lmkrwb);



