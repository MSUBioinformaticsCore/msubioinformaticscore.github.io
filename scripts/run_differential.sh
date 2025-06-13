#!/bin/bash --login
#SBATCH --job-name=differential
#SBATCH --time=3:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=differential-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the relative paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example reference genome
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/differential/samplesheet.csv" # Replace with path to sample sheet
MATRIX="$HOME/rnaseq/results/star_salmon/salmon.merged.gene_counts.tsv" # Example path to counts matrix
LENGTHS="$HOME/rnaseq/results/star_salmon/salmon.merged.gene_lengths.tsv" # Example path to gene lengths matrix
CONTRASTS="$HOME/differential/contrasts.csv" # Example path to contrasts file
OUTDIR="$HOME/differential/results" # Example path to results directory
WORKDIR="$SCRATCH/differential/work" # Example path to work directory
CONFIG="$HOME/rnaseq/icer.config" # Example path to icer.config file

# Run the pipeline
nextflow pull nf-core/differentialabundance
nextflow run nf-core/differentialabundance -r 1.5.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--matrix $MATRIX \
--transcript_length_matrix $LENGTHS \
--contrasts $CONTRASTS \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
-c $CONFIG
