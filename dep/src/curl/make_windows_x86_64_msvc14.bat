IF DEFINED VS140COMNTOOLS (
  SET GENERATOR="Visual Studio 14 Win64"
  SET target_lib_suffix=_msvc14
)
IF NOT DEFINED GENERATOR (
  ECHO Can not find VC2015 installed!
  GOTO ERROR
)
SET rootdir=%~dp0
SET cwdir=%CD%
SET target=windows_x86_64
SET prefix=%rootdir%%target%
SET /P version=<"%rootdir%version.txt"
RD /S /Q "%rootdir%%version%"
MD "%rootdir%%version%"
XCOPY "%rootdir%..\%version%" "%rootdir%%version%" /S /Y
RD /S /Q "%rootdir%project"
MD "%rootdir%project"
CD /D "%rootdir%project"
cmake -C "%rootdir%CMakeLists.txt" -DBUILD_CURL_EXE=OFF -DBUILD_CURL_TESTS=OFF -DCURL_STATICLIB=ON -DCMAKE_INSTALL_PREFIX="%prefix%" -G %GENERATOR% "%rootdir%%version%"
cmake "%rootdir%%version%"
cmake --build . --target install --config Release --clean-first
MD "%rootdir%..\..\include\%target%"
XCOPY "%prefix%\include" "%rootdir%..\..\include\%target%" /S /Y
MD "%rootdir%..\..\lib\%target%%target_lib_suffix%"
COPY /Y "%prefix%\lib\libcurl.lib" "%rootdir%..\..\lib\%target%%target_lib_suffix%"
CD /D "%cwdir%"
RD /S /Q "%rootdir%%version%"
RD /S /Q "%rootdir%project"
RD /S /Q "%prefix%"
GOTO :EOF

:ERROR
PAUSE
