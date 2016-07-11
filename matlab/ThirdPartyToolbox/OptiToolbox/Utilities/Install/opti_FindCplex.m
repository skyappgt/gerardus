function [cplx_str,cplx_inc,cplx_lib,cplx_libname,cplx_ver] = opti_FindCplex()
%Finds IBM ILOG CPLEX Libraries and returns path and version


%Known CPLEX path locations (Modify to suit your system by adding to cell arrays, or create a new structure for other versions)
CPLX125.x64 = {'C:\Program Files\IBM\ILOG\CPLEX_Studio125\cplex\'};
CPLX125.x86 = {'C:\Program Files (x86)\IBM\ILOG\CPLEX_Studio125\cplex\'};
CPLX125.ver = '12.5';
CPLX125.lib = 'cplex125';

CPLX124.x64 = {'C:\Program Files\IBM\ILOG\CPLEX_Studio_Academic124\cplex\'};
CPLX124.x86 = {'C:\Program Files (x86)\IBM\ILOG\CPLEX_Studio_Academic124\cplex\'};
CPLX124.ver = '12.4';
CPLX124.lib = 'cplex124';

%Add any new structures to below
CPLXLIB = {CPLX125,CPLX124};


%DO NOT MODIFY BELOW HERE
for i = 1:length(CPLXLIB)
    %Check for CPLEX
    [ok,cplx_str,cplx_inc,cplx_lib,cplx_libname,cplx_ver] = checkCPLXVer(CPLXLIB{i}); 
    if(ok), return; end
end

%Still no Luck - user must locate
error('Could not find the IBM ILOG CPLEX Location on your computer. Please modify this file to locate it');

function [ok,cplx_str,cplx_inc,cplx_lib,cplx_libname,cplx_ver] = checkCPLXVer(cplxstr)
%Local check function
ok = false;
%Defaults
cplx_str = []; cplx_inc = []; cplx_lib = []; cplx_libname = []; cplx_ver = [];
%Find local config paths
switch(computer)
    case 'PCWIN'
        if(~isfield(cplxstr,'x86') || isempty(cplxstr.x86))
            error('No x86 CPLEX directories specified to check');
        end
        paths = cplxstr.x86;
    case 'PCWIN64'
        if(~isfield(cplxstr,'x64') || isempty(cplxstr.x86))
            error('No x64 CPLEX directories specified to check');
        end
        paths = cplxstr.x64;
    otherwise
        error('This function is only setup for Windows PCs');
end
for i = 1:length(paths)
    if(exist(paths{i},'dir'))
        dir_cplx = paths{i};
        %Get Include Directory
        cplx_inc = [dir_cplx 'include\ilcplex'];
        if(~exist(cplx_inc,'dir'))
            error('Could not find Cplex include directory. Checked:\n %s',cplx_inc);
        end
        %Get Library Directory
        switch(computer)
            case 'PCWIN'
                cplx_lib = [dir_cplx 'lib\x86_windows_vs2010\stat_mda\'];
            case 'PCWIN64'
                cplx_lib = [dir_cplx 'lib\x64_windows_vs2010\stat_mda\'];  
        end
        if(~exist(cplx_lib,'dir'))
            error('Could not find Cplex lib directory. Checked:\n %s\n',cplx_lib);
        end        
        %Build complete linker line
        cplx_str = [' -I"' cplx_inc '" -L"' cplx_lib '" -l' cplxstr.lib ' '];
        cplx_libname = cplxstr.lib;
        cplx_ver = cplxstr.ver;   
        ok = true;
        return;
    end
end