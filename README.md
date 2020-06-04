# VSBuildToolsProblem
This repository contains the sample code for the issue when compiling VC++ with Build Tools 16.6

How to reproduce the problem.

1. Open the PowerShell command interface and navigate to the cloned subfolder: **LibraryCPP**:
```PowerShell
cd  LibraryCPP
```
2. Execute the following command on the machine where **Visual Studio Build Tools 2019 ** v16.6.x
is installed:  
```PowerShell
.\LibraryCPP.Tools.Build.ps1
```
And it gives the following error output:  
```PowerShell
====# LibraryCPP TOOLS START BUILD #====
MBBuild begin for building LibraryCPP.2019.vcxproj
Build started 6/4/2020 8:01:04 AM.
     1>Project "E:\DEV\LibraryCPP\LibraryCPP.2019.vcxproj" on node 1 (Restore;Build target(s)).
     1>_GetAllRestoreProjectPathItems:
         Determining projects to restore...
       Restore:
         Nothing to do. None of the projects specified contain packages to restore.
       InitializeBuildStatus:
         Creating "E:\DEV\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild" because "AlwaysCreate" was sp
         ecified.
       ClCompile:
         C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.26.28801\bin\HostX86\x86\CL.ex
         e /c /IInclude /Zi /nologo /W3 /WX- /diagnostics:column /O2 /Oi /Oy- /GL /D WIN32 /D NDEBUG /D _WINDOWS /D _US
         RDLL /D _CRT_SECURE_NO_WARNINGS /D _WINDLL /D _MBCS /Gm- /EHsc /MD /GS /Gy /fp:precise /Zc:wchar_t /Zc:forScop
         e /Zc:inline /Fo"E:\DEV\LibraryCPP\bin\Win32\Release\\" /Fd"E:\DEV\LibraryCPP\bin\Win32\Release\vc142.pdb" /Gd
          /TP /analyze- /FC /errorReport:queue LibraryCPP.cpp
         LibraryCPP.cpp
       ResourceCompile:
         C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x86\rc.exe /l"0x0409" /nologo /fo"E:\DEV\LibraryCPP\bi
         n\Win32\Release\LibraryCPP.res" LibraryCPP.rc
       Link:
         C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.26.28801\bin\HostX86\x86\link.
         exe /ERRORREPORT:QUEUE /OUT:"E:\DEV\LibraryCPP\bin\Win32\Release\LibraryCPP.dll" /NOLOGO Lib\x86\ClusApi.lib L
         ib\x86\ResUtils.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32
         .lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /DEF:"LibraryCPP.def" /MANIFEST /MANIFESTUAC:"level='asInvo
         ker' uiAccess='false'" /manifest:embed /DEBUG /PDB:"E:\DEV\LibraryCPP\bin\Win32\Release\LibraryCPP.pdb" /OPT:R
         EF /OPT:ICF /LTCG:incremental /TLBID:1 /DYNAMICBASE /NXCOMPAT /IMPLIB:"E:\DEV\LibraryCPP\bin\Win32\Release\Lib
         raryCPP.lib" /MACHINE:X86 /SAFESEH:NO /DLL E:\DEV\LibraryCPP\bin\Win32\Release\LibraryCPP.res
         E:\DEV\LibraryCPP\bin\Win32\Release\LibraryCPP.obj
            Creating library E:\DEV\LibraryCPP\bin\Win32\Release\LibraryCPP.lib and object E:\DEV\LibraryCPP\bin\Win32\
         Release\LibraryCPP.exp
         Generating code
         Previous IPDB was built with incompatible compiler, fall back to full compilation.
         All 5 functions were compiled because no usable IPDB/IOBJ from previous compilation was found.
         Finished generating code
     1>LINK : fatal error LNK2023: bad DLL or entry point 'msobj140.dll' [E:\DEV\LibraryCPP\LibraryCPP.2019.vcxproj]
<running down Dbg pointer 129cd48>
<running down TPI pointer 129cfb0>
<running down Dbg pointer 129d288>
<running down Dbg pointer 129d1e0>
<running down Dbg pointer 129d2f8>
<running down TPI pointer 129d410>
<running down DBI pointer 129d170>
<running down Dbg pointer 129cfe8>
     1>Done Building Project "E:\DEV\LibraryCPP\LibraryCPP.2019.vcxproj" (Restore;Build target(s)) -- FAILED.

Build FAILED.

       "E:\DEV\LibraryCPP\LibraryCPP.2019.vcxproj" (Restore;Build target) (1) ->
       (Link target) ->
         LINK : fatal error LNK2023: bad DLL or entry point 'msobj140.dll' [E:\DEV\LibraryCPP\LibraryCPP.2019.vcxproj]

    0 Warning(s)
    1 Error(s)

Time Elapsed 00:00:02.32
MBBuild end for building LibraryCPP.2019.vcxproj
MSBuildFile : MSBuild Error Code 1 for building LibraryCPP.2019.vcxproj
At E:\DEV\LibraryCPP\LibraryCPP.Tools.Build.ps1:25 char:7
+ $ok = MSBuildFile -BuildFilePath "LibraryCPP.$($MSBuildVersion).vcxpr ...
+       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,MSBuildFile

EchoEndBuildKO : ====# LibraryCPP TOOLS BUILD FAILED #====
At E:\DEV\LibraryCPP\LibraryCPP.Tools.Build.ps1:27 char:12
+     return EchoEndBuildKO("LibraryCPP TOOLS");
+            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,EchoEndBuildKO
```
3. The same command on the machine where the prevoius **Visual Studio Build Tools 2019** (v16.5.4) is installed, give sthe following output:  
```PowerShell
====# LibraryCPP TOOLS START BUILD #====
MBBuild begin for building LibraryCPP.2019.vcxproj
Build started 6/4/2020 10:12:04 AM.
     1>Project "E:\AK\LibraryCPP\LibraryCPP.2019.vcxproj" on node 1 (Restore;Build target(s)).
     1>Restore:
         Nothing to do. None of the projects specified contain packages to restore.
       PrepareForBuild:
         Creating directory "E:\AK\LibraryCPP\bin\Win32\Release\".
         Creating directory "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\".
       InitializeBuildStatus:
         Creating "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild" because "AlwaysCreate" was spe
         cified.
       ClCompile:
         C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.25.28610\bin\HostX86\x86\CL.ex
         e /c /IInclude /Zi /nologo /W3 /WX- /diagnostics:column /O2 /Oi /Oy- /GL /D WIN32 /D NDEBUG /D _WINDOWS /D _US
         RDLL /D _CRT_SECURE_NO_WARNINGS /D _WINDLL /D _MBCS /Gm- /EHsc /MD /GS /Gy /fp:precise /Zc:wchar_t /Zc:forScop
         e /Zc:inline /Fo"E:\AK\LibraryCPP\bin\Win32\Release\\" /Fd"E:\AK\LibraryCPP\bin\Win32\Release\vc142.pdb" /Gd /
         TP /analyze- /FC /errorReport:queue LibraryCPP.cpp
         LibraryCPP.cpp
       ResourceCompile:
         C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x86\rc.exe /l"0x0409" /nologo /fo"E:\AK\LibraryCPP\bin
         \Win32\Release\LibraryCPP.res" LibraryCPP.rc
       Link:
         C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.25.28610\bin\HostX86\x86\link.
         exe /ERRORREPORT:QUEUE /OUT:"E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.dll" /NOLOGO Lib\x86\ClusApi.lib Li
         b\x86\ResUtils.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.
         lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /DEF:"LibraryCPP.def" /MANIFEST /MANIFESTUAC:"level='asInvok
         er' uiAccess='false'" /manifest:embed /DEBUG /PDB:"E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.pdb" /OPT:REF
          /OPT:ICF /LTCG:incremental /TLBID:1 /DYNAMICBASE /NXCOMPAT /IMPLIB:"E:\AK\LibraryCPP\bin\Win32\Release\Librar
         yCPP.lib" /MACHINE:X86 /SAFESEH:NO /DLL E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.res
         E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.obj
            Creating library E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.lib and object E:\AK\LibraryCPP\bin\Win32\Re
         lease\LibraryCPP.exp
         Generating code
         Previous IPDB not found, fall back to full compilation.
         All 5 functions were compiled because no usable IPDB/IOBJ from previous compilation was found.
         Finished generating code
         LibraryCPP.2019.vcxproj -> E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.dll
       FinalizeBuildStatus:
         Deleting file "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild".
         Touching "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\LibraryCPP.lastbuildstate".
     1>Done Building Project "E:\AK\LibraryCPP\LibraryCPP.2019.vcxproj" (Restore;Build target(s)).

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:03.85
MBBuild end for building LibraryCPP.2019.vcxproj
MBBuild OK for building LibraryCPP.2019.vcxproj
====# LibraryCPP TOOLS END BUILD #====
```
4. With **Visual Studio** with latest version (16.6.x), we have the same good output:  
```PowerShell
====# LibraryCPP TOOLS START BUILD #====
MBBuild begin for building LibraryCPP.2019.vcxproj
Build started 04/06/2020 10:51:13.
     1>Project "D:\Temp\VSBuildTools\LibraryCPP\LibraryCPP.2019.vcxproj" on node 1 (Restore;Build target(s)).
     1>_GetAllRestoreProjectPathItems:
         Determining projects to restore...
       Restore:
         Nothing to do. None of the projects specified contain packages to restore.
       PrepareForBuild:
         Creating directory "D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\".
         Creating directory "D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\".
       InitializeBuildStatus:
         Creating "D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild" because "Always
         Create" was specified.
       ClCompile:
         C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.26.28801\bin\HostX86\x86\CL.ex
         e /c /IInclude /Zi /nologo /W3 /WX- /diagnostics:column /O2 /Oi /Oy- /GL /D WIN32 /D NDEBUG /D _WINDOWS /D _US
         RDLL /D _CRT_SECURE_NO_WARNINGS /D _WINDLL /D _MBCS /Gm- /EHsc /MD /GS /Gy /fp:precise /Zc:wchar_t /Zc:forScop
         e /Zc:inline /Fo"D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\\" /Fd"D:\Temp\VSBuildTools\LibraryCPP\bin\
         Win32\Release\vc142.pdb" /Gd /TP /analyze- /FC /errorReport:queue LibraryCPP.cpp
         LibraryCPP.cpp
       ResourceCompile:
         C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x86\rc.exe /l"0x0409" /nologo /fo"D:\Temp\VSBuildTools
         \LibraryCPP\bin\Win32\Release\LibraryCPP.res" LibraryCPP.rc
       Link:
         C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\VC\Tools\MSVC\14.26.28801\bin\HostX86\x86\link.
         exe /ERRORREPORT:QUEUE /OUT:"D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.dll" /NOLOGO Lib\x86
         \ClusApi.lib Lib\x86\ResUtils.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib she
         ll32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /DEF:"LibraryCPP.def" /MANIFEST /MANIFESTUAC:
         "level='asInvoker' uiAccess='false'" /manifest:embed /DEBUG /PDB:"D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Re
         lease\LibraryCPP.pdb" /OPT:REF /OPT:ICF /LTCG:incremental /TLBID:1 /DYNAMICBASE /NXCOMPAT /IMPLIB:"D:\Temp\VSB
         uildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.lib" /MACHINE:X86 /SAFESEH:NO /DLL D:\Temp\VSBuildTools\Libr
         aryCPP\bin\Win32\Release\LibraryCPP.res
         D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.obj
            Creating library D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.lib and object D:\Temp\VSBuil
         dTools\LibraryCPP\bin\Win32\Release\LibraryCPP.exp
         Generating code
         Previous IPDB not found, fall back to full compilation.
         All 5 functions were compiled because no usable IPDB/IOBJ from previous compilation was found.
         Finished generating code
         LibraryCPP.2019.vcxproj -> D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.dll
       FinalizeBuildStatus:
         Deleting file "D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild".
         Touching "D:\Temp\VSBuildTools\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\LibraryCPP.lastbuildstate".
     1>Done Building Project "D:\Temp\VSBuildTools\LibraryCPP\LibraryCPP.2019.vcxproj" (Restore;Build target(s)).

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:02.39
MBBuild end for building LibraryCPP.2019.vcxproj
MBBuild OK for building LibraryCPP.2019.vcxproj
====# LibraryCPP TOOLS END BUILD #====
0
```
5. In order to use **Visual Studio Build Tools 2017**, you can pass the additionnal argument:
```PowerShell
.\LibraryCPP.Tools.Build.ps1 -MSBuildVersion 2017
```
And it gives the good output:  
```PowerShell
====# LibraryCPP TOOLS START BUILD #====
MBBuild begin for building LibraryCPP.2017.vcxproj
Build started 6/4/2020 10:47:20 AM.
     1>Project "E:\AK\LibraryCPP\LibraryCPP.2017.vcxproj" on node 1 (Restore;Build target(s)).
     1>Restore:
         Nothing to do. None of the projects specified contain packages to restore.
       PrepareForBuild:
         Creating directory "E:\AK\LibraryCPP\bin\Win32\Release\".
         Creating directory "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\".
       InitializeBuildStatus:
         Creating "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild" because "AlwaysCreate" was spe
         cified.
       ClCompile:
         C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\CL.ex
         e /c /IInclude /Zi /nologo /W3 /WX- /diagnostics:classic /O2 /Oi /Oy- /GL /D WIN32 /D NDEBUG /D _WINDOWS /D _U
         SRDLL /D _CRT_SECURE_NO_WARNINGS /D _WINDLL /D _MBCS /Gm- /EHsc /MD /GS /Gy /fp:precise /Zc:wchar_t /Zc:forSco
         pe /Zc:inline /Fo"E:\AK\LibraryCPP\bin\Win32\Release\\" /Fd"E:\AK\LibraryCPP\bin\Win32\Release\vc141.pdb" /Gd
         /TP /analyze- /FC /errorReport:queue LibraryCPP.cpp
         LibraryCPP.cpp
       ResourceCompile:
         C:\Program Files (x86)\Windows Kits\10\bin\10.0.17763.0\x86\rc.exe /l"0x0409" /nologo /fo"E:\AK\LibraryCPP\bin
         \Win32\Release\LibraryCPP.res" LibraryCPP.rc
       Link:
         C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Tools\MSVC\14.16.27023\bin\HostX86\x86\link.
         exe /ERRORREPORT:QUEUE /OUT:"E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.dll" /NOLOGO Lib\x86\ClusApi.lib Li
         b\x86\ResUtils.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.
         lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /DEF:"LibraryCPP.def" /MANIFEST /MANIFESTUAC:"level='asInvok
         er' uiAccess='false'" /manifest:embed /DEBUG /PDB:"E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.pdb" /OPT:REF
          /OPT:ICF /LTCG:incremental /TLBID:1 /DYNAMICBASE /NXCOMPAT /IMPLIB:"E:\AK\LibraryCPP\bin\Win32\Release\Librar
         yCPP.lib" /MACHINE:X86 /SAFESEH:NO /DLL E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.res
         E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.obj
            Creating library E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.lib and object E:\AK\LibraryCPP\bin\Win32\Re
         lease\LibraryCPP.exp
         Generating code
         All 5 functions were compiled because no usable IPDB/IOBJ from previous compilation was found.
         Finished generating code
         LibraryCPP.2017.vcxproj -> E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.dll
       FinalizeBuildStatus:
         Deleting file "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\unsuccessfulbuild".
         Touching "E:\AK\LibraryCPP\bin\Win32\Release\LibraryCPP.tlog\LibraryCPP.lastbuildstate".
     1>Done Building Project "E:\AK\LibraryCPP\LibraryCPP.2017.vcxproj" (Restore;Build target(s)).

Build succeeded.
    0 Warning(s)
    0 Error(s)

Time Elapsed 00:00:01.96
MBBuild end for building LibraryCPP.2017.vcxproj
MBBuild OK for building LibraryCPP.2017.vcxproj
====# LibraryCPP TOOLS END BUILD #====
0
PS E:\AK\LibraryCPP>
```
