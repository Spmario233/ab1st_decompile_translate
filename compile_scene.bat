python lrc_to_csv.py

siglus-ssu -c --tmp cache ss_utf8 binary\1st_beat\Scene.pck.recompile
siglus-ssu -d --c dat\comments.csv binary\1st_beat\dat\comments.dbs
siglus-ssu -d --c dat\crowsong.csv binary\1st_beat\dat\crowsong.dbs
siglus-ssu -d --c dat\alchemy.csv binary\1st_beat\dat\alchemy.dbs
siglus-ssu -d --c dat\mysong.csv binary\1st_beat\dat\mysong.dbs

@echo off

cd binary\1st_beat\
del Gameexe.dat.recompile
ren "Gameexe.dat" "Gameexe.dat.recompile"
cd ..\
cd ..\

@echo on
python comment_check.py

pause