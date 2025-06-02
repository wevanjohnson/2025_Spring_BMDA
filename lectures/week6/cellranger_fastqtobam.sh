#!/bin/bash

#SBATCH --partition=main

#SBATCH --job-name=cellranger_bam

#SBATCH --array=0-3,5,6

#SBATCH --cpus-per-task=30

#SBATCH --mem=100G

#SBATCH --time=24:00:00



#### from 10x genomics website: fastq-dump --split-files --gzip {sample accession#} is the way to do it


# path to fastq files
FASTQPATH=/scratch/$USER/tmp/awsbucket/fastqs/

# get sample to process
INDEX=$(($SLURM_ARRAY_TASK_ID))
INPUT=($(ls -d $FASTQPATH*R1_001.fastq.gz))

FASTQ=($(echo ${INPUT[$INDEX]##*/} | cut -d_ -f1-1))


# path to cellranger
crpath=/projects/f_wj183_1/apps/cellranger-8.0.1/

# path to reference library
refpath=/projects/f_wj183_1/reflib/2024_cellranger/refdata-gex-GRCh38-2024-A/

cd $FASTQPATH

# load python 
module load python/3.8.2

$crpath/./cellranger count --id=$FASTQ \ #id makes folder of that name, will not work if already exists
   --create-bam=true \	# true or false, necessary
   --sample=$FASTQ \ # prefix of files to align, will take forward and reverse strand for sample
   --fastqs=$FASTQPATH \ 
   --localcores=30 \ # if there is not enough memory this will not work
   --localmem=100 \ 	
   --chemistry=SC3Pv2 \	# optional but in this case required	
   --transcriptome=$refpath 


