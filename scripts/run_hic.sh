#!/bin/bash --login
#SBATCH --job-name=hic
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=hic-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/hic/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/hic/results" # Example path to results directory
WORKDIR="$SCRATCH/hic/work" # Example path to work directory
CONFIG="$HOME/hic/icer.config" # Example path to icer.config file

# Run the Hi-C analysis
nextflow pull nf-core/hic
nextflow run nf-core/hic -r 2.1.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
-c $CONFIG
