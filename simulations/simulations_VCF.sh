## neutral simulations for constant population size and expanding population size
stdpopsim -e msprime HomSap pop_0:3621 -s 14 -c chr22 -g HapMapII_GRCh38 -o simple.tree
stdpopsim -e msprime HomSap -d OutOfAfrica_3G09 CEU:3621 -s 14 -c chr22 -g HapMapII_GRCh38 -o complex.tree

## background selection simulations for constant population size and expanding population size
stdpopsim -e slim --slim-path DIR/slim HomSap -c chr22 -s 14 -g HapMapII_GRCh38 --dfe Gamma_K17 pop_0:5000 -o simple_selection.tree
stdpopsim -e slim --slim-path DIR/slim HomSap -d OutOfAfrica_3G09 CEU:5000 -c chr22 -s 14 -g HapMapII_GRCh38 --dfe Gamma_K17 -o complex_selection.tree

#CONVERT to VCF
tskit vcf *.tree > *.vcf

#CHANGE CHROMOSOME LABEL
bcftools annotate --rename-chrs NUM2CHR.txt dir/*.vcf > dir/chr22_*_wgs.vcf

#FILTER FOR EXOME
bgzip dir/*.vcf
tabix dir/*.vcf.gz
bcftools filter -R chr22_GRCh38_exome.bed dir/chr22_*_wgs.vcf.gz -Oz -o dir/chr22_*_wes.vcf.gz

##RECOMBINATION MAPS
#HomSap/HapMapII_GRCh38/genetic_map_Hg38_chr22.txt  - downloaded from stdpopsim
#chr22_genetic_map_grch38_4col.txt  - map above with genetic distance as Map(cM) column calculated in exome/scripts/add_cM_2_map.ipynb
#chr22_genetic_map_grch38_3col.map - map above w/ Map(cM) but without chromosome column 

##EXTRACT TRUE AGE
#Tskit Table Documentation: https://tskit.dev/tskit/docs/stable/data-model.html#sec-site-table-definition
tskit nodes *.tree > *.nodes
tskit sites *.tree > *.sites
tskit mutations *.tree > *.mutations
tskit edges *.tree > *.edges
python get_true_time.py */treeFiles/*