#!/bin/bash
#$ -S /bin/bash
#$ -l tmem=2.8G,h_vmem=2.8G
#$ -l h_rt=20:0:0

# Select the project that this job will run under
# Find <your_project_id> by running the command "groups"
#$ -P vyp

# Set the name of the job
#$ -N extractVCF

# Set the working directory 
#$ -cwd

#$ -V

#$ -o /dev/null
#$ -e /dev/null

#$ -t 1-23
set -u
set -x
scriptname="extractVCF_bychr"
mkdir -p ${scriptname}.qsub.out ${scriptname}.qsub.err
exec >${scriptname}.qsub.out/${scriptname}_${SGE_TASK_ID}_${JOB_ID}.out 2>${scriptname}.qsub.err/${scriptname}_${SGE_TASK_ID}_${JOB_ID}.err
args=( header 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X )
f=${args[$SGE_TASK_ID]}

uclex_release=mainset_November2015

infile=/scratch2/vyp-scratch2/vincent/GATK/${uclex_release}/${uclex_release}_chr${f}.vcf.gz
outfolder=/goon2/scratch2/vyp-scratch2/Cipriani_IoO/GATK/data/latestcalls

vcftools=/cluster/project8/vyp/vincent/Software/vcftools_0.1.12a/bin/vcftools

# sample=IoO_FFS_batch4_LC13186
# sample=IoO_FFS_batch4_XH13849

for sample in `cat ${outfolder}/SampleList.txt`; do 

	${vcftools} --gzvcf ${infile} --recode --indv ${sample} --out ${outfolder}/${uclex_release}_${sample}_chr${f} 
	${vcftools} --vcf ${outfolder}/${uclex_release}_${sample}_chr${f}.recode.vcf --non-ref-ac 1 --recode --out ${outfolder}/${uclex_release}_${sample}_chr${f}_clean
done






