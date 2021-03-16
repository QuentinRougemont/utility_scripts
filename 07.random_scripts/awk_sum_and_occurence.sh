#awk sum based on conditions:

#summer les valeur basé sur les pattron d'une autre colomne.
#similaire à group_by() %>% summarise() de dplyr:
#par exemple on somme la colomne 2 conditionnel aux obs de la col1:

awk -F '\t' '{a[$1] += $2} END{for (i in a) print i, a[i]}'  inputfile

#exemple with Hmel2.5
sed 's/[0-9]o//g' 03_genome/Hmel2.5_plusmtDNA.fa.fai |\
    awk -F '\t' '{a[$1] += $2} END{for (i in a) print i, a[i]}' |\
    LC_ALL=C sort -k 2 -nr |less

#sum de la longeur total et comptage des occurences:
#equivalent dplyr de group_by(chr) %>% summarise(longeur(sum(V3), n())

sed 's/[0-9]o//g' 03_genome/Hmel2.5_plusmtDNA.fa.fai | \
    awk -F '\t' '{a[$1] += $2; b[$1]++;} 
    END{for (i in a) print i, a[i], b[i]}' |\
        LC_ALL=C sort -k 2 -nr |less
