IF DEFINED VS90COMNTOOLS (
  SET VCVARSALL="%VS90COMNTOOLS%..\..\VC\vcvarsall.bat"
) ELSE IF DEFINED VS120COMNTOOLS (
  SET VCVARSALL="%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
) ELSE IF DEFINED VS110COMNTOOLS (
  SET VCVARSALL="%VS110COMNTOOLS%..\..\VC\vcvarsall.bat"
) ELSE IF DEFINED VS100COMNTOOLS (
  SET VCVARSALL="%VS100COMNTOOLS%..\..\VC\vcvarsall.bat"
)
SET target_lib_suffix=
IF NOT DEFINED VCVARSALL (
  ECHO Can not find VC2008 or VC2010 or VC2012 or VC2013 installed!
  GOTO ERROR
)
CALL %VCVARSALL% x86
@ECHO ON
SET rootdir=%~dp0
SET cwdir=%CD%
SET target=windows_x86_32
SET prefix=%rootdir%%target%
SET openssldir=%prefix%\ssl
SET /P version=<"%rootdir%version.txt"
RD /S /Q "%rootdir%%version%"
MD "%rootdir%%version%"
XCOPY "%rootdir%..\%version%" "%rootdir%%version%" /S /Y
CD /D "%rootdir%%version%"
perl Configure VC-WIN32 no-shared no-asm no-dso --prefix="%prefix%" --openssldir="%openssldir%"
CALL ms\do_ms.bat
nmake -f ms\nt.mak
nmake -f ms\nt.mak install
MD "%rootdir%..\..\include\%target%"
XCOPY "%prefix%\include" "%rootdir%..\..\include\%target%" /S /Y
MD "%rootdir%..\..\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\libeay32.lib" "%rootdir%..\..\lib\%target%%target_lib_suffix%"
CD /D "%cwdir%"
RD /S /Q "%rootdir%%version%"
RD /S /Q "%prefix%"
GOTO :EOF

:ERROR
PAUSE
