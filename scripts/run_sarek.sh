#!/bin/bash --login
#SBATCH --job-name=sarek
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=sarek-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/sarek/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/sarek/results" # Example path to results directory
WORKDIR="$SCRATCH/sarek/work" # Example path to work directory
CONFIG="$HOME/sarek/icer.config" # Example path to icer.config file

# Run the WGS analysis
nextflow pull nf-core/sarek
nextflow run nf-core/sarek -r 3.5.1 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
--tools cnvkit,strelka \
-c $CONFIG
