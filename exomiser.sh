#!/bin/bash
#$ -S /bin/bash
#$ -l tmem=8G
#$ -l h_vmem=8G
#$ -l h_rt=50:0:0

# Select the project that this job will run under
# Find <your_project_id> by running the command "groups"
#$ -P vyp

# Set the name of the job
#$ -N Sorsbynewexom 

# Set the working directory (where the script is)
#$ -wd /cluster/project8/vyp/valentina/scripts/exomiser 

#$ -o /cluster/project8/vyp/valentina/scripts/exomiser/out -e /cluster/project8/vyp/valentina/scripts/exomiser/err

# Run the program


vincsoftw=/cluster/project8/vyp/vincent/Software
valesoftw=/cluster/project8/vyp/valentina/software
java=/share/apps/jdk1.7.0_71/bin/java
java8=/share/apps/jdk1.8.0_25/bin/java
exomiserv7beta=${valesoftw}/exomiser-cli-7.0.0.BETA/exomiser-cli-7.0.0.BETA.jar
exomiserv7=${valesoftw}/exomiser-cli-7.1.0/exomiser-cli-7.1.0.jar

scratch=/goon2/scratch2/vyp-scratch2/Cipriani_IoO
inpfolder=/goon2/scratch2/vyp-scratch2/Cipriani_IoO/GATK/data
inpfolderexomiser=/goon2/scratch2/vyp-scratch2/Cipriani_IoO/exomiser/data
outfolder=/goon2/scratch2/vyp-scratch2/Cipriani_IoO/exomiser/results_cluster

pedigree=FALSE
disease=Sorsby

# ${java} -Xms5g -Xmx5g -jar ${exomiserv6} --help
# /share/apps/jdk1.7.0_45/bin/java -Xms5g -Xmx5g -jar /cluster/project8/vyp/valentina/software/exomiser-cli-6.0.0/exomiser-cli-6.0.0.jar  --help

# Explanations for some options 
# --keep-non-pathogenic <true/false>, default is true; Keep the predicted non-pathogenic variants that are normally removed by default. 
# These are defined as syonymous, intergenic, intronic, upstream, downstream or intronic ncRNA variants.
 
# --prioritiser <name> Name of the prioritiser used to score the genes. Can be one of: hiphive, exomewalker, phenix, phive or uber-pheno. e.g. --prioritiser=uber-pheno

# --keep-off-target <true/false>, default is true; Keep the off-target variants that are normally removed by default.
# These are defined as intergenic, intronic, upstream, downstream or intronic ncRNA variants.  
# --remove-dbsnp <true/false> 

if [[ "$pedigree" == "FALSE" ]]; then

	### \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ####
	### Run Exomiser on single VCF files 
	### \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ####

	if [[ "$disease" == "Sorsby" ]]; then

		# Sorsby NCMD

		# Coloboma, polydactily (feet), polydactily (hands)
		hpoterms='HP:0000589,HP:0001829,HP:0001161' 
		inher='AD'
		freq='0.1'

		# for sample in IoO_FFS_batch4_LC13186 IoO_FFS_batch4_XH13849; do 
		# for sample in mainset_May2014_recal_IoO_FFS_batch4_LC13186_clean.recode mainset_May2014_recal_IoO_FFS_batch4_XH13849_clean.recode; do 
		for sample in IoO_FFS_batch4_LC13186 mainset_September2015_IoO_FFS_batch4_XH13849; do 
		# for sample in mainset_May2014_recal_IoO_FFS_batch4_LC13186_clean.recode mainset_May2014_recal_IoO_FFS_batch4_XH13849_clean.recode; do 

			### EXOMISER 7 beta
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv7beta} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${scratch}/GavinArno/${sample}.vcf.gz -o ${outfolder}/${sample}_${inher}
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv7beta} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv7beta} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/latestcalls/${sample}.vcf.gz -o ${outfolder}/${sample}_${inher}_v7beta_newdata

			### EXOMISER 7 
			# ${java8} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq}  -Q 30 --prioritiser=hiphive -I ${inher} --hiphive-params=human,mouse,ppi  --out-format=TSV-GENE,TSV-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolderexomiser}/${sample}.vcf -o ${outfolder}/${sample}_${inher}
			${java8} -Xms2g -Xmx4g -jar ${exomiserv7} --keep-off-target=false -F ${freq}  -Q 30 --prioritiser=hiphive -I ${inher} --hiphive-params=human,mouse,ppi  --out-format=TSV-GENE,TSV-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/latestcalls/${sample}.vcf.gz -o ${outfolder}/${sample}_${inher}_v7_newdata
			# ${java8} -Xms2g -Xmx4g -jar ${exomiserv7} --keep-off-target=false -F ${freq}  -Q 30 --prioritiser=hiphive -I ${inher} --hiphive-params=human,mouse,ppi  --out-format=TSV-GENE,TSV-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7_olddata

		done
	fi


	if [[ "$disease" == "PACG" ]]; then

		# PACG

		hpoterms='HP:0012109' 
		freq='0.1'

		for sample in S1167_raw S1168_raw S1169_raw S1496_raw S1497_raw S1500_raw S1501_raw; do 

			for inher in AD NoInh; do 

			# exomiser 7.0.0.BETA
			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7
			
			done

		done

	fi

	if [[ "$disease" == "Usher" ]]; then

		# Usher

		hpoterms='HP:0000550,HP:0008555,HP:0001270,HP:0000510,HP:0000407,HP:0000572' 
		freq='0.5'

		name=mainset_May2014_recal

		for sample in 05G05535 06G02870 04G02654 05G00045 05G00288 05G00845 05G04499 AW207 04G01260 06G02005 MBB16899 04G03609 05G03129 05G03821 05G04122 05G04980 05G07207 06G01194 ST9719 05G06386 04G03077; do 

			cp ${inpfolder}/${name}_${sample}_clean.recode.vcf ${inpfolder}/${sample}.vcf
			
			for inher in AR NoInh; do 

				### EXOMISER
				${java} -Xms6g -Xmx6g -jar ${exomiserv6} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}

			done
			rm ${inpfolder}/${sample}.vcf

		done
	fi

	if [[ "$disease" == "LCA" ]]; then

		# LCA

		hpoterms='HP:0000556,HP:0000572,HP:0000550,HP:0000639' 
		freq='0.5'
		inher='AR'

		name=mainset_May2014_recal

		# for sample in MY17429 BC16524 UA13451 ZA17147 SA14702 CB16693 SI30 GI14336 LF10231 MB18991 EB15474 MAS_Oman AR14323 HA15119 ZH13513 ED10800 SR18267 KH20 RS16859 GA18720 AA17521 WC774A6 MS15483 IR13364 TRR18436 HM13177 HM14796 NV14317; do  
		# for sample in MAS_Oman IR13364 NV14317 EB15474; do  

		# for sample in HA15119 ED10800 GA18720 IR13364 KJ18274 MB18991 NV14317 SR18267 TRR18436 ZH13513 BC16524 EB15474 GI14336 HM13177 LF10231 MAS_Oman MS15483 UA13451 AAH14548 AR14323 CB16693 MR13813 ZA17147 AA17521 HM14796 MY17429 SA14702 SH15370 WC774A6 RS16859 KH20 SI30; do
		for sample in GA18720 ; do

			cp ${inpfolder}/${name}_${sample}_clean.recode.vcf ${inpfolder}/${sample}.vcf
			
			### EXOMISER
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv6} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}
			
			# ----remove-dbsnp=true
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv6} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --remove-dbsnp=true --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_dbsnpOUT

			# exomiser 7.0.0.BETA, --remove-known-variants=true
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --remove-known-variants=true --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7dbsnpOUT

			# exomiser 7.0.0.BETA
			# ${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7

			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F 0.1 -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7freq01
			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_NOINH_v7
			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I AD -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_AD_v7

			rm ${inpfolder}/${sample}.vcf

		done
	fi

	if [[ "$disease" == "OpticAtrophy" ]]; then

		# OpticAtrophy

		hpoterms='HP:0000648' 
		inher='AR'
		freq='0.5'

		name=mainset_May2014_recal

		for sample in LH19437 CK19991 JH19439 LH19897 LK19992 NC19788 PK19990 SC19711 WI19789; do  

			cp ${inpfolder}/${name}_${sample}_clean.recode.vcf ${inpfolder}/${sample}.vcf
			
			# exomiser 7.0.0.BETA
			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolder}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7
			
			rm ${inpfolder}/${sample}.vcf

		done
	fi

	if [[ "$disease" == "RDS" ]]; then

		## RDS 

		hpoterms='HP:0000548,HP:0002510,HP:0002483'
		inher='AR'
		freq='0.5'

		for sample in DP702011_Var RP70837_Var; do

			### EXOMISER
			${java} -Xms5g -Xmx5g -jar ${exomiserv6} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -v ${inpfolderexomiser}/${sample}.vcf -o ${outfolder}/${sample}_${inher}
	
		done

		# Mother 
		freq='0.5'
		inher='NoInh'

		for sample in SP70834_Var; do

			### EXOMISER
			${java} -Xms5g -Xmx5g -jar ${exomiserv6} --keep-off-target=false -F ${freq} --full-analysis true -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF -v ${inpfolderexomiser}/${sample}.vcf -o ${outfolder}/${sample}_${inher}
	
		done

	fi

fi 


#######################################################################################################
########################### --- pedigree ---###########################################################
#######################################################################################################

if [[ "$pedigree" == "TRUE" ]]; then

	### \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ####
	### Run Exomiser on multiple-sample VCF files with ped file
	### \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ####
	
	if [[ "$disease" == "RDS" ]]; then

		## RDS 

		hpoterms='HP:0000548,HP:0002510,HP:0002483'
		inher='AR'
		freq='0.5'

		for sample in DP702011_RP70837_joint; do

			### EXOMISER
			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -p ${inpfolderexomiser}/${sample}.ped -v ${inpfolderexomiser}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7
	
		done

	fi

	if [[ "$disease" == "Sorsby" ]]; then

		# Sorsby NCMD
		# Coloboma, polydactily (feet), polydactily (hands)
		hpoterms='HP:0000589,HP:0001829,HP:0001161' 
		inher='AD'
		freq='0.1'

		for sample in FR_Sorsby UK_Sorsby; do 

			### EXOMISER
			${java} -Xms6g -Xmx6g -jar ${exomiserv7} --keep-off-target=false -F ${freq} -I ${inher} -Q 30 --hiphive-params=human,mouse,ppi --prioritiser=hiphive --out-format=TAB-GENE,TAB-VARIANT,HTML,VCF --hpo-ids ${hpoterms} -p ${inpfolderexomiser}/${sample}.ped -v ${inpfolderexomiser}/${sample}.vcf -o ${outfolder}/${sample}_${inher}_v7

		done
	fi
fi


