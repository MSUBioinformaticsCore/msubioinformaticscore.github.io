#!/bin/bash --login
#SBATCH --job-name=rnaseq
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=rnaseq-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/rnaseq/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/rnaseq/results" # Example path to results directory
WORKDIR="$SCRATCH/rnaseq/work" # Example path to work directory
CONFIG="$HOME/rnaseq/icer.config" # Example path to icer.config file

# Run the RNA-seq analysis
nextflow pull nf-core/rnaseq
nextflow run nf-core/rnaseq -r 3.19.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
-c $CONFIG
