tic
% s=SegyFile('pstm_cg_150.segy','r',[],[],[],[],[],[],[],[],1);
% []= Fig progressbar; 1=text progressbar ; 0=no progressbar;
[segyName,segyPath]=uigetfile({'*.sgy;*.segy;*.PSTM;*PSTM_SEGY';'*.sgy;*.segy';'*.segy'},'MultiSelect','on');
path=strcat(segyPath,segyName);
s=SegyFile(path,'r');
toc
%%
% choose the directory to save your Records Data. Suggest saving to working
% directory
tic
[recordsName, recordsPath] = uiputfile('records.dat');
if recordsName == 0
    return
end

fileID = fopen(strcat(recordsPath,recordsName),'w');
if fileID == -1 
    errordlg('File does not exist, check your file path or file permission')
    return
end
fwrite(fileID,s.Trc.read(1:300),'double');
fclose(fileID);
msgbox(['[' segyName ']', ' converted to:',' ' ,'[' recordsName,']' , ', path: ' ,' ' ,recordsPath,recordsName])
toc
%%
tic
%m = memmapfile('records.dat');
% m=memmapfile('records.dat','Format',{'double' [xLines inLines dataPoints] 'x'});

sample = s.FileInfo.SamplesPerTrace;
maxTrace = s.Trc.FileInfo.TracesInFile;
xlineNum = 369;
inlineNum = 661;

% segy 3D read format:
%SurvyFormat = double([sample xlineNum inlineNum]);
%m = memmapfile('filepath\filename','Format',{'double', SurvyFormat, 'x'})

% segy 2D read format:
%m = memmapfile('filepath\filename','Format',{'double', SurvyFormat, 'x'})

SurvyFormat = double([sample xlineNum inlineNum]);
m = memmapfile('records.dat','Format',{'double', SurvyFormat, 'x'});

% get seismic as m.Data.x(sampleRange,xlineRange,inlineRange)
load lmkRWB
% set xline=150 profile
figure;imagesc(squeeze(m.Data.x(:,150,:)));colormap(lmkrwb);
% set t=1500 time slice
figure;imagesc(squeeze(m.Data.x(1500,:,:)));colormap(lmkrwb);
toc


