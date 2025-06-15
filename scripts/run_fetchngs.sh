#!/bin/bash --login

#SBATCH --job-name=fetchngs_job
#SBATCH --time=3:59:00
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=8

# Load Nextflow
module purge
module load Nextflow

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/fetchngs/ids.csv" # Example path to database IDs
OUTDIR="$HOME/fetchngs/results" # Example path to results directory
WORKDIR="$SCRATCH/fetchngs/work" # Example path to work directory
CONFIG="$HOME/fetchngs/icer.config" # Example path to icer.config file

# Run the pipeline
nextflow pull nf-core/fetchngs
nextflow run nf-core/fetchngs -r 1.12.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
-c $CONFIG
