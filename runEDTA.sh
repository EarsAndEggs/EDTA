#!/bin/bash -l
#SBATCH -J EDTA
#SBATCH -o EDTA.output
#SBATCH -e EDTA.error
#SBATCH -t 8:00:00
#SBATCH -A snic2021-5-585
#SBATCH -n 20

# load modules
module load conda

# set EDTA paths
# arg:
#   EDTA (dir): Path to EDTA installation directory
#   INPUTDIR (dir): Path to input folder for analysis
#   GENOME (file): FASTA file of the genome
#   CDS (file): FASTA file of the coding sequence (no introns, UTRs or TEs)
#   BED (file): FASTA to exclude bed format reguons from TE annotations

EDTA=
INPUTDIR=
GENOME=
CDS=
BED=

# activate conda environment
cd ${EDTA}
pwd
source conda_init.sh
conda activate ${EDTA}EDTA

# perl EDTA.pl [options]
#   --genome	[File]	The genome FASTA
#   --species [Rice|Maize|others]	Specify the species for identification of TIR candidates. Default: others
#   --step	[all|filter|final|anno] Specify which steps you want to run EDTA.
# 			all: run the entire pipeline (default)
# 			filter: start from raw TEs to the end.
# 			final: start from filtered TEs to finalizing the run.
# 			anno: perform whole-genome annotation/analysis after TE library construction.
#   --overwrite	[0|1]	If previous results are found, decide to overwrite (1, rerun) or not (0, default).
#   --cds	[File]	Provide a FASTA file containing the coding sequence (no introns, UTRs, nor TEs) of this genome or its close relative.
#   --curatedlib	[file]	Provided a curated library to keep consistant naming and classification for known TEs.
# 			All TEs in this file will be trusted 100%, so please ONLY provide MANUALLY CURATED ones here.
# 			This option is not mandatory. It's totally OK if no file is provided (default).
#   --sensitive	[0|1]	Use RepeatModeler to identify remaining TEs (1) or not (0, default).
#			This step is very slow and MAY help to recover some TEs.
#   --anno	[0|1]	Perform (1) or not perform (0, default) whole-genome TE annotation after TE library construction.
#   --rmout	[File]	Provide your own homology-based TE annotation instead of using the EDTA library for masking. File is in RepeatMasker .out format. This file will be merged with the structural-based TE annotation. (--anno 1 required). Default: use the EDTA library for annotation.
#   --evaluate	[0|1]	Evaluate (1) classification consistency of the TE annotation. (--anno 1 required). Default: 0.
# 			This step is slow and does not affect the annotation result.
#   --exclude	[File]	Exclude bed format regions from TE annotation. Default: undef. (--anno 1 required).
#   --threads|-t	[int]	Number of theads to run this script (default: 4)
#   --help|-h	Display this help info

# uncomment to run EDTA test and check if installation has succeeded
#cd ${EDTA}test
#time perl ${EDTA}EDTA.pl --genome genome.fa --cds genome.cds.fa --exclude genome.exclude.bed --overwrite 1 --sensitive 1 --anno 1 --evaluate 1 --threads 10

# run EDTA script (comment to run EDTA test)(change options to cater for your analysis)
cd ${INPUTDIR}
time perl ${EDTA}EDTA.pl --genome ${GENOME} --cds ${CDS} --exclude ${BED} --overwrite 1 --sensitive 1 --anno 1 --evaluate 1 --threads 20