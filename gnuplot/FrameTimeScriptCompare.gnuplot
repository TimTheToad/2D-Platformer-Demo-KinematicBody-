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
plot gsSaveData0 using ($1/1000.0) notitle lc rgb "black", 0/0 linetype 2 linewidth 3 lc rgb "black" title '1', gsSaveData1 using ($1/1000.0) notitle lc rgb "orange", 0/0 linetype 2 linewidth 3 lc rgb "orange" title '2', gsSaveData2 using ($1/1000.0) notitle lc rgb "purple", 0/0 linetype 2 linewidth 3 lc rgb "purple" title '3'

set title "Save State Frame Time Ga"
plot gaSaveData0 using ($1/1000.0) notitle '1' lc rgb "black", 0/0 linetype 2 linewidth 3 lc rgb "black" title '1', gaSaveData1 using ($1/1000.0) notitle '2' lc rgb "orange", 0/0 linetype 2 linewidth 3 lc rgb "orange" title '2', gaSaveData2 using ($1/1000.0) notitle '3' lc rgb "purple", 0/0 linetype 2 linewidth 3 lc rgb "purple" title '3'

set title "Load State Frame Time Gs"
plot gsLoadData0 using ($1/1000.0) notitle '1' lc rgb "black", 0/0 linetype 2 linewidth 3 lc rgb "black" title '1', gsLoadData1 using ($1/1000.0) notitle '2' lc rgb "orange", 0/0 linetype 2 linewidth 3 lc rgb "orange" title '2', gsLoadData2 using ($1/1000.0) notitle '3' lc rgb "purple", 0/0 linetype 2 linewidth 3 lc rgb "purple" title '3'

set title "Load State Frame Time Ga"
plot gaLoadData0 using ($1/1000.0) notitle '1' lc rgb "black", 0/0 linetype 2 linewidth 3 lc rgb "black" title '1', gaLoadData1 using ($1/1000.0) notitle '2' lc rgb "orange", 0/0 linetype 2 linewidth 3 lc rgb "orange" title '2', gaLoadData2 using ($1/1000.0) notitle '3' lc rgb "purple", 0/0 linetype 2 linewidth 3 lc rgb "purple" title '3'

unset multiplot