function fileRenamerSub(directory)

os = computer;
if ~isempty(strfind(os,'PC'))
    ind=1;
    files = dir(strcat(directory,'\*;*'));
    for i = 1:length(files)
        sysline = char(strcat('ren',{' '},'"',directory,'\',files(i).name,'"',{' '},files(i).name(1:length(files(i).name)-2)));
        system(sysline);
        ind=2;
    end
    if ind ~= 2
        files = dir(strcat(directory,'\*_*'));
        for i = 1:length(files)
            movefile([directory '\' files(i).name], [directory '\' files(i).name(1:length(files(i).name)-2)]);
        end
    end
elseif ~isempty(strfind(os,'MAC'))
    ind=1;
    file = dir(strcat(directory,'/*_*'));
    for i = 1:length(files)
        movefile([directory '/' file(i).name], [directory '\' file(i).name(1:length(file(i).name)-2)]);
        ind=2;
    end
    if ind ~= 2
        file = dir(strcat(directory,'/*;*'));
        for i = 1:length(files)
            movefile([directory '/' file(i).name], [directory '\' file(i).name(1:length(file(i).name)-2)]);
        end
    end
end
