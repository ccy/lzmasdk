@echo off

goto RAD_STUDIO

:RAD_STUDIO
if not exist "win32\" mkdir win32
bcc32.exe -c -nWin32 -q -D_LZMA_PROB32 -D_WIN32 ..\C\*.c

if not exist "win64\" mkdir win64
bcc64.exe -c -q -D_LZMA_PROB32 -D_WIN64 ..\C\*.c
move *.o Win64
goto :End

:VISUAL_STUDIO
if "%VisualStudioVersion%"=="" call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\x86_amd64\vcvarsx86_amd64.bat"

set option=-c -nologo -wd4273 -wd4099 -FoWin64\ -D_LZMA_PROB32 -D_WIN64
cl.exe %option% ..\C\Threads.c
cl.exe %option% ..\C\LzFind.c
cl.exe %option% ..\C\LzFindMt.c
cl.exe %option% ..\C\LzmaDec.c
cl.exe %option% ..\C\LzmaEnc.c

set option=

:End