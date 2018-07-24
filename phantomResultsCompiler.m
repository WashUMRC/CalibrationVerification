clear all;clc;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MicroCT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Retrieve all of the quality check outputs
storeFolder = pwd;
saveFolder = ['J:\Silva''s Lab\P30 Core Center\CT Quality Check Results'];
sysLine=['del ' storeFolder '\*.txt'];
system(sysLine);
sysLine = ['md "' saveFolder '\MicroCT\' date '"'];
saveFolder = [saveFolder '\MicroCT\' date '\'];
system(sysLine);
f = ftp('10.21.24.204','microct','mousebone4','System','OpenVMS');
ascii(f);
disp(f)
cDir = cd(f,'dk0');
cDir = cd(f,'data');
cDir = cd(f,'00002211');
directories = dir(f);
for i = 1:length(directories)
    tf = directories(i).isdir;
    if tf == 1 && i > 1
        cd(f,'..');
        cSubDir = cd(f,directories(i).name(1:length(directories(i).name)-6));
        files = dir(f,cSubDir);
        for j = 1:length(files)
            if ~isempty(strfind(files(j).name,'3DRESULTS'))
                mget(f,files(j).name,storeFolder);
            end
        end
    elseif tf == 1 && i == 1
        cSubDir = cd(f,directories(i).name(1:length(directories(i).name)-6));
        files = dir(f,cSubDir);
        for j = 1:length(files)
            if ~isempty(strfind(files(j).name,'3DRESULTS'))
                mget(f,files(j).name,storeFolder);
            end
        end
    end
end
close(f);

%rename retrieved files to remove ;num
fileRenamerSub(storeFolder);

%load all QC1 data
qc1List = dir([storeFolder '\*QC1.txt']);
for i = 1:length(qc1List)
    file = [storeFolder '\' qc1List(i).name];
    %      data = importdata(file,'\t',2);
    fid = fopen(file,'r','n','EUC-JP');
    data{i} = fscanf(fid,'%s');
    fclose(fid);
end
%parse ugly text files
for i = 1:length(data)
    index{i} = strfind(data{i},'[mgHA/ccm]');
    c=0;
    for j = 1:45
        tf = strcmp(data{i}(index{i}(length(index{i}))-j),'-');
        if tf == 0
            c=c+1;
            numString{i}(c) = data{i}(index{i}(length(index{i}))-j);
        end
    end
    numString{i} = fliplr(numString{i});
end
%Put these strings into a numerical array
for i = 1:length(numString)
    c=0;
    dots = strfind(numString{i},'.');
    ends = dots + 4;
    for j = 1:length(dots)
        if j == 1
            c=c+1;
            number(i,c) = str2num(numString{i}(1:ends(j)))*(-1);
        else
            c=c+1;
            number(i,c) = str2num(numString{i}(ends(j-1)+1:ends(j)));
        end
    end
end

h = figure('Visible','Off');
set(h,'Position',get(0,'Screensize'));
hold on;
toPlot = number(length(number)-20:length(number),5);
plot(toPlot)
indicesOver = find(toPlot>(791+16));
indicesUnder = find(toPlot < (791-16));
if ~isempty(indicesOver)
    plot(toPlot(indicesOver),'r*');
end
if ~isempty(indicesUnder)
    plot(toPlot(indicesUnder),'b^');
end
title('Last 20 weekly values of Mean 5 calibration scans for microCT 40');
legend('Values','Over','Under');
hold off;
saveas(h,[saveFolder 'Last 20 weekly values of Mean 5 calibration scans for microCT 40.png']);
close('all');

a=[-15 100 209 414 797];%default rod values
for i = 1:length(number(length(number)-20:length(number),1))
    h = figure('Visible','Off');
    set(h,'Position',get(0,'Screensize'));
    plot(number(i,:))
    hold on
    plot(a,'k')
    calErrorMicro(i) = sqrt(mean(number(i,:)-a)^2);
    title('Values for all 5 rods');
    annotation('textbox',[0.4,0.3,.1,.1],'string',['RMS error is ' num2str(calErrorMicro(i))])
    legend('Measured','Guide Values');
    saveas(h,[saveFolder 'Values for all 5 rods' num2str(i) '.png']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Now VivaCT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keep calErrorMicro;clc;close all;
%Retrieve all of the quality check outputs
storeFolder = pwd;
saveFolder = ['J:\Silva''s Lab\P30 Core Center\CT Quality Check Results'];
sysLine=['del ' storeFolder '\*.txt'];
system(sysLine);
sysLine = ['md "' saveFolder '\VivaCT\' date '"'];
saveFolder = [saveFolder '\VivaCT\' date '\'];
system(sysLine);
f = ftp('10.21.24.203','microct','mousebone4','System','OpenVMS');
disp(f)
cDir = cd(f,'dk0');
cDir = cd(f,'data');
cDir = cd(f,'00000451');
directories = dir(f);
for i = 1:length(directories)
    tf = directories(i).isdir;
    if tf == 1 && i > 1
        cd(f,'..');
        cSubDir = cd(f,directories(i).name(1:length(directories(i).name)-6));
        files = dir(f,cSubDir);
        for j = 1:length(files)
            if ~isempty(strfind(files(j).name,'3DRESULTS'))
                mget(f,files(j).name,storeFolder);
            end
        end
    elseif tf == 1 && i == 1
        cSubDir = cd(f,directories(i).name(1:length(directories(i).name)-6));
        files = dir(f,cSubDir);
        for j = 1:length(files)
            if ~isempty(strfind(files(j).name,'3DRESULTS'))
                mget(f,files(j).name,storeFolder);
            end
        end
    end
end
close(f);

%rename retrieved files to remove ;num
fileRenamerSub(storeFolder);

%load all QC1 data
qc1List = dir([storeFolder '\*QC1.txt']);
for i = 1:length(qc1List)
    file = [storeFolder '\' qc1List(i).name];
    %      data = importdata(file,'\t',2);
    fid = fopen(file,'r','n','EUC-JP');
    data{i} = fscanf(fid,'%s');
    fclose(fid);
end
%parse ugly text files
for i = 1:length(data)
    index{i} = strfind(data{i},'[mgHA/ccm]');
    c=0;
    for j = 1:45
        tf = strcmp(data{i}(index{i}(length(index{i}))-j),'-');
        if tf == 0
            c=c+1;
            numString{i}(c) = data{i}(index{i}(length(index{i}))-j);
        end
    end
    numString{i} = fliplr(numString{i});
end
%Put these strings into a numerical array
for i = 1:length(numString)
    c=0;
    dots = strfind(numString{i},'.');
    ends = dots + 4;
    for j = 1:length(dots)
        if j == 1
            c=c+1;
            number(i,c) = str2num(numString{i}(1:ends(j)))*(-1);
        else
            c=c+1;
            number(i,c) = str2num(numString{i}(ends(j-1)+1:ends(j)));
        end
    end
end

h = figure('Visible','Off');
set(h,'Position',get(0,'Screensize'));
hold on;
toPlot = number(length(number)-10:length(number),5);
plot(toPlot)
indicesOver = find(toPlot>(791+16));
indicesUnder = find(toPlot < (791-16));
if ~isempty(indicesOver)
    plot(toPlot(indicesOver),'r*');
end
if ~isempty(indicesUnder)
    plot(toPlot(indicesUnder),'b^');
end
title('Last 10 weekly values of Mean 5 calibration scans for VivaCT 40');
legend('Values','Over','Under');
hold off;
saveas(h,[saveFolder 'Last 10 weekly values of Mean 5 calibration scans for VivaCT 40' '.png']);

a=[-15 100 209 414 797];%default rod values
for i = 1:length(number(:,1))
    h = figure('Visible','Off');
    set(h,'Position',get(0,'Screensize'));
    plot(number(i,:))
    hold on
    plot(a,'k')
    calErrorViva(i) = sqrt(mean(number(i,:)-a)^2);
    title('Values for all 5 rods');
    annotation('textbox',[0.4,0.3,.1,.1],'string',['RMS error is ' num2str(calErrorViva(i))])
    legend('Measured','Guide Values');
    saveas(h,[saveFolder 'Values for all 5 rods' num2str(i) '.png']);
end

% close all;

h = figure('Visible','Off');
set(h,'Position',get(0,'Screensize'));
plot(calErrorViva)
title('RMSE for Viva')
saveas(h,[saveFolder 'RMSEViva.png']);

h = figure('Visible','Off');
set(h,'Position',get(0,'Screensize'));
plot(calErrorMicro)
title('RMSE for Micro')
saveas(h,[saveFolder 'RMSEMicro.png']);

sysLine = ['del ' pwd '\*QC1*'];
system(sysLine);
