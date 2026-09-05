siglus-ssu -c --tmp cache ss_utf8 binary\1st_beat\Scene.pck.recompile

@echo off

cd binary\1st_beat\
del Gameexe.dat.recompile
ren "Gameexe.dat" "Gameexe.dat.recompile"
cd ..\
cd ..\

@echo on
python comment_check.py

pause