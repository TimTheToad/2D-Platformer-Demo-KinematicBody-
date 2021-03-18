reset
unset terminal
set multiplot layout 2,2
set datafile separator ';'
set style data lines

gsSaveData0 = "../data/gs_save_0.csv"
gsLoadData0 = "../data/gs_load_0.csv"
gaSaveData0 = "../data/ga_save_0.csv"
gaLoadData0 = "../data/ga_load_0.csv"

gsSaveData1 = "../data/gs_save_1.csv"
gsLoadData1 = "../data/gs_load_1.csv"
gaSaveData1 = "../data/ga_save_1.csv"
gaLoadData1 = "../data/ga_load_1.csv"

gsSaveData2 = "../data/gs_save_2.csv"
gsLoadData2 = "../data/gs_load_2.csv"
gaSaveData2 = "../data/ga_save_2.csv"
gaLoadData2 = "../data/ga_load_2.csv"

set grid y
set ytics auto nomirror
set xtics auto nomirror
set ylabel "Frame Time (ms)"
set xlabel "Frame"
set key outside
set key title "Complexity"
set bmargin 5
set style fill solid 0.3

set title "Save State Frame Time Gs"
unset key
plot gsSaveData0 using ($1/1000.0) title '1' lc rgb "black", gsSaveData1 using ($1/1000.0) title '2' lc rgb "orange", gsSaveData2 using ($1/1000.0) title '3' lc rgb "purple"

set key; unset tics; unset border; unset xlabel; unset ylabel

plot [][0:1] 2 title 'Carrefour' lw 4, \
     2 title 'Philips' lw 4, \
     2 title 'Sony' lw 4

set title "Save State Frame Time Ga"
plot gaSaveData0 using ($1/1000.0) title '1' lc rgb "black", gaSaveData1 using ($1/1000.0) title '2' lc rgb "orange", gaSaveData2 using ($1/1000.0) title '3' lc rgb "purple"

set title "Load State Frame Time Gs"
plot gsLoadData0 using ($1/1000.0) title '1' lc rgb "black", gsLoadData1 using ($1/1000.0) title '2' lc rgb "orange", gsLoadData2 using ($1/1000.0) title '3' lc rgb "purple"

set title "Load State Frame Time Ga"
plot gaLoadData0 using ($1/1000.0) title '1' lc rgb "black", gaLoadData1 using ($1/1000.0) title '2' lc rgb "orange", gaLoadData2 using ($1/1000.0) title '3' lc rgb "purple"

unset multiplot