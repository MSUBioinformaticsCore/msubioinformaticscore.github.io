#!/bin/bash --login
#SBATCH --job-name=methylseq
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=methylseq-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/methylseq/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/methylseq/results" # Example path to results directory
WORKDIR="$SCRATCH/methylseq/work" # Example path to work directory
CONFIG="$HOME/methylseq/icer.config" # Example path to icer.config file

# Run the pipeline
nextflow pull nf-core/methylseq
nextflow run nf-core/methylseq -r 3.0.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
--bismark_index $HOME/methylseq/bismark_index
-c $CONFIG
