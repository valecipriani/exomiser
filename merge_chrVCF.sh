#!/bin/bash
#$ -S /bin/bash
#$ -l tmem=2.8G,h_vmem=2.8G
#$ -l h_rt=20:0:0

# Select the project that this job will run under
# Find <your_project_id> by running the command "groups"
#$ -P vyp

# Set the name of the job
#$ -N mergeindv

# Set the working directory 
#$ -cwd

#$ -o /dev/null
#$ -e /dev/null

set -u
set -x
scriptname="merge_chrVCF"
mkdir -p ${scriptname}.qsub.out ${scriptname}.qsub.err
exec >${scriptname}.qsub.out/${scriptname}_${SGE_TASK_ID}_${JOB_ID}.out 2>${scriptname}.qsub.err/${scriptname}_${SGE_TASK_ID}_${JOB_ID}.err

export PERL5LIB=/share/apps/genomics/vcftools_0.1.12b/lib/perl5/site_perl

uclex_release=mainset_September2015
outfolder=/goon2/scratch2/vyp-scratch2/Cipriani_IoO/GATK/data/latestcalls

# vcfconcat=/cluster/project8/vyp/vincent/Software/vcftools_0.1.12a/bin/vcf-concat
vcfconcat=/share/apps/genomics/vcftools_0.1.12b/bin/vcf-concat

bgzip=/cluster/project8/vyp/vincent/Software/tabix-0.2.5/bgzip
tabix=/cluster/project8/vyp/vincent/Software/tabix-0.2.5/tabix

sample=IoO_FFS_batch4_LC13186
# sample=IoO_FFS_batch4_XH13849

for f in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X; do 
	${bgzip} ${outfolder}/${uclex_release}_${sample}_chr${f}_clean.recode.vcf
	${tabix} -p vcf ${outfolder}/${uclex_release}_${sample}_chr${f}_clean.recode.vcf.gz
	chr${f}=${outfolder}/${uclex_release}_${sample}_chr${f}_clean.recode.vcf.gz
done

${vcfconcat} ${chr1} ${chr2} ${chr3} ${chr4} ${chr5} ${chr6} ${chr7} ${chr8} ${chr9} ${chr10} ${chr11} ${chr12} ${chr13} ${chr14} ${chr15} ${chr16} ${chr17} ${chr18} ${chr19} ${chr20} ${chr21} ${chr22} ${chrX} | gzip -c > ${outfolder}/${uclex_release}_${sample}.vcf.gz

for f in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X; do 

	rm ${outfolder}/${uclex_release}_${sample}_chr${f}.recode.vcf
 	rm ${outfolder}/${uclex_release}_${sample}_chr${f}_clean.recode.vcf.gz
 	rm ${outfolder}/${uclex_release}_${sample}_chr${f}_clean.recode.vcf.gz.tbi
done 
