% function ApplyScancoCalibrationToISQs()

date = '10-1-2017';%date after which to apply calibration
dateNumber = datenum(date);
energy = str2num('70000');%energy at which to apply calibration
rsqTextHeaderParentPath = 'J:\Silva''s Lab\P30 Core Center\SSC_Billing Information\Viva RSQ Header Text Files\';

ctMeas = 0;

dirs = dir(rsqTextHeaderParentPath);
for i = 3:length(dirs)
    clc;
    i/length(dirs)
    if dirs(i).isdir == 1
        dirs2 = dir(fullfile(rsqTextHeaderParentPath,dirs(i).name));
        for j = 3:length(dirs2)
            if dirs2(j).isdir == 1
                pth = fullfile(rsqTextHeaderParentPath,fullfile(dirs(i).name,dirs2(j).name));
                txtFiles = dir(fullfile(pth,'*.txt*'));
                for k = 1:length(txtFiles)
                    fid = fopen(fullfile(pth,txtFiles(k).name));
                    ct=0;
                    while ~feof(fid)
                        ct=ct+1;
                        line{ct} = fgetl(fid);
                    end
                    fclose(fid);
                    try
                        theDate = datenum(line{11}(23:end));
                        theEnergy = str2num(line{53}(24:29));
                        clear line;

                        if theDate >= dateNumber && theEnergy == energy
                            ctMeas = ctMeas+1;
                            measurements{ctMeas} = num2str(str2num(dirs2(j).name));
                            meas(ctMeas) = str2num(measurements{ctMeas});
                        end
                    catch
                        clear line;
                    end
                    
                end
            end
        end
    end
end

fout = fopen(fullfile(pwd,'microctcomfile.com'),'w');
for i = 1:length(measurements)
    fprintf(fout,'%s\n',['@ut:update_calib ' measurements{i}]);
end
fprintf(fout,'%s\n','logoff');

serverIP = '10.21.24.203';
remoteScratch = 'IDISK1:[MICROCT.SCRATCH]';
plinkPath = '"C:\Program Files\PuTTY\plink.exe" ';
savedSession = 'VivaCT40 ';
userName = 'microct ';
password = 'mousebone4 ';
f = ftp(serverIP,'microct','mousebone4','System','OpenVMS');
ascii(f);
cd(f,'scratch');
mput(f,fullfile(pwd,'microctcomfile.com'));

sysLine = [plinkPath savedSession '-l ' userName '-pw ' password '@' remoteScratch 'microctcomfile.com'];
system(sysLine);
                

