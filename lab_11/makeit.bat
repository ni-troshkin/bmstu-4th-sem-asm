@echo off
: -------------------------------
: if resources exist, build them
: -------------------------------
if not exist rsrc.rc goto over1
\masm32\BIN\Rc.exe /v rsrc.rc
\masm32\BIN\Cvtres.exe /machine:ix86 rsrc.res
:over1

if exist %1.obj del a.obj
if exist %1.exe del a.exe

: -----------------------------------------
: assemble template.asm into an OBJ file
: -----------------------------------------
\masm32\BIN\Ml.exe /c /coff a.asm
if errorlevel 1 goto errasm

if not exist rsrc.obj goto nores

: --------------------------------------------------
: link the main OBJ file with the resource OBJ file
: --------------------------------------------------
\masm32\BIN\Link.exe /SUBSYSTEM:WINDOWS a.obj rsrc.obj
if errorlevel 1 goto errlink
dir a.*
goto TheEnd

:nores
: -----------------------
: link the main OBJ file
: -----------------------
\masm32\BIN\Link.exe /SUBSYSTEM:WINDOWS a.obj
if errorlevel 1 goto errlink
dir a.*
goto TheEnd

:errlink
: ----------------------------------------------------
: display message if there is an error during linking
: ----------------------------------------------------
echo.
echo There has been an error while linking this project.
echo.
goto TheEnd

:errasm
: -----------------------------------------------------
: display message if there is an error during assembly
: -----------------------------------------------------
echo.
echo There has been an error while assembling this project.
echo.
goto TheEnd

:TheEnd

pause
