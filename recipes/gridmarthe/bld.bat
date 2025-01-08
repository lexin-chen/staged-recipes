:: Windows build script


:: test for new compiler default
clang-cl.exe --version
if %ERRORLEVEL% neq 0 exit 1

flang-new.exe --version
if %ERRORLEVEL% neq 0 exit 1

cd %SRC_DIR%\src\gridmarthe\lecsem


:: add flags
::set FFLAGS=-fdefault-real-8 -O2
set FFLAGS="-std=legacy"

:: Flags for meson, which do not correctly detect flang-new and linkers
set CC=clang-cl
set FC=flang-new
set AR=llvm-ar :: by default with llvm-flang, meson still seek gnu ar
set LD=llvm-link

%PYTHON% -m numpy.f2py -c lecsem.f90 edsemigl.f90 scan_grid.f90 -m lecsem --backend=meson --lower
if errorlevel 1 exit 1

cd %SRC_DIR%
%PYTHON% -m pip install --no-deps -vv .
if errorlevel 1 exit 1
