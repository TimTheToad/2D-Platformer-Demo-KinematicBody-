reset
set terminal wxt size 800,600
set datafile separator ';'
set boxwidth 0.5
set style fill solid
set boxwidth 1
set style data histogram
set style histogram cluster

set key outside

set grid y

set xrange[0:5]
set xtics ("Gs Save" 1, "Ga Save" 2, "Gs Load" 3, "Ga Load" 4) nomirror
set ytics auto nomirror

set ylabel "Time (ms)"
set xlabel "Implementation Model"

set bmargin 5

set title "Average Execution Time Comparison"
plot "../data/AverageExecutionTime.csv" using ($2/1000.0) lc rgb "black" title 'Complexity 1', "" using ($3/1000.0) lc rgb "orange" title 'Complexity 2', "" using ($4/1000.0) lc rgb "purple" title 'Complexity 3'