::============================================
:: Compile script for NES Assembly on Windows
::============================================
::
:: Programmed by Bryan McClain
::
@echo off
title NES Compiler
color 0f
cls

NESASM3 Main.asm

echo.
echo It is finished. Open file?
echo (F)ceux, (N)estopia, or (E)xit
choice /c:fne /n
if errorlevel 3 exit
if errorlevel 2 (
echo Modify this file to open "Main.nes" with Nestopia
exit
)
if errorlevel 1 (
echo Modify this file to open "Main.nes" with Fceux
exit
)

exit
