REM copy images folder
copy images .\latex_docu\images

REM create subdirs
mkdir .\latex_docu\01
mkdir .\latex_docu\02
mkdir .\latex_docu\03
mkdir .\latex_docu\04
mkdir .\latex_docu\05
mkdir .\latex_docu\05a
mkdir .\latex_docu\06
mkdir .\latex_docu\07
mkdir .\latex_docu\08
mkdir .\latex_docu\12


REM generate latex file for each section
pandoc .\01-Introduction.md -o .\latex_docu\01\doc.tex
pandoc .\02-Survey-of-Current-Landscape.md -o .\latex_docu\02\doc.tex
pandoc .\03-Architecture.md -o .\latex_docu\03\doc.tex
pandoc .\04-Infrastructure.md -o .\latex_docu\04\doc.tex
pandoc .\05-Data-Import-Framework.md -o .\latex_docu\05\doc.tex
pandoc .\05a-Units.md -o .\latex_docu\05a\doc.tex
pandoc .\06-Consumer.md -o .\latex_docu\06\doc.tex
pandoc .\07-Database.md -o .\latex_docu\07\doc.tex
pandoc .\08-web-management-platform.md -o .\latex_docu\08\doc.tex
pandoc .\12-Conclusions.md -o .\latex_docu\12\doc.tex
