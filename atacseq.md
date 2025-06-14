---
layout: post
title: "Running nf-core/atacseq on MSU HPCC"
date: 2024-11-03
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview

The **MSU HPCC**, managed by ICER, provides an efficient and scalable environment for running complex bioinformatics analyses. This tutorial will guide you through running the **nf-core/atac-seq** pipeline on the HPCC, ensuring reproducibility and optimal performance.

## Key Benefits of nf-core/atacseq

**nf-core/atac-seq** is designed for:

- **Reproducible ATAC-seq Analysis**: Provides robust, community-curated workflows.
- **Portability**: Runs seamlessly across different computing environments.
- **Scalability**: Capable of processing small- to large-scale ATAC-seq datasets.

## Prerequisites

- Access to MSU HPCC with a valid ICER account.
- Basic familiarity with the command line.

## Step-by-Step Tutorial

### Note on Directory Variables

On the MSU HPCC:

- `$HOME` automatically routes to the user's home directory (`/mnt/home/username`).
- `$SCRATCH` automatically routes to the user's scratch directory, which is ideal for temporary files and large data processing.

### Note on Working Directory

The working directory, which stores intermediate and temporary files, can be specified separately using the `-w` flag when running the pipeline. This helps keep your analysis outputs and temporary data organized.

#### 1. Create a Project Directory
Make a new folder for your RNA-seq analysis:
```bash
mkdir $HOME/atacseq
cd $HOME/atacseq
```
This command creates the directory and moves you into it.

#### 2. Prepare a Sample Sheet
You need to create a file called ```samplesheet.csv``` that lists your samples and their FASTQ file paths. Use a text editor (like nano) to create this file:
```bash
nano samplesheet.csv
```
Then, add your sample information in CSV format. For example:
```csv
sample,fastq_1,fastq_2,replicate
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,1
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,1
```
Save the file (in nano, press Ctrl+O then Ctrl+X to exit).

#### 3. Create a Configuration File
Do not type file content directly into the terminal. Use a text editor instead. Create a file named icer.config:
```bash
nano icer.config
```
Paste the following content into the file:
```groovy
process {
    executor = 'slurm'
}
```
Save and exit the editor.

#### 4. Prepare the Job Submission Script
Now, create a shell script to run the pipeline. Create a file called run_atacseq.sh:
```bash
nano run_atacseq.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=atacseq
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=atacseq-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/atacseq/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/atacseq/results" # Example path to results directory
WORKDIR="$SCRATCH/atacseq/work" # Example path to work directory
CONFIG="$HOME/atacseq/icer.config" # Example path to icer.config file

# Run the RNA-seq analysis
nextflow pull nf-core/atacseq
nextflow run nf-core/atacseq -r 2.1.2 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
--read_length 150 \
-c $CONFIG
```
Make edits as needed. Modify `--read_length` to match the number of base pairs per read in your fastq files (commonly = 100 or 150).
Save and close the file.

#### 5. Submit Your Job
Submit your job to SLURM by typing:
```bash
sbatch run_atacseq.sh
```
This sends your job to the scheduler on the HPCC.

### 6. Monitor Your Job
Check the status of your job with:
```bash
squeue -u $USER
```
After completion, your output files will be in the `results` folder inside your `atacseq` directory.

## Note on Reference Genomes

Common reference genomes can be found in the /mnt/research/common-data/Bio/ folder on the HPCC. You can find guidance on finding reference genomes on the HPCC or downloading them from Ensembl in this [GitHub repository](https://github.com/johnvusich/reference-genomes).

## Best Practices

- **Check Logs**: Regularly inspect log files generated by the pipeline for any warnings or errors.
- **Resource Allocation**: Adjust the `icer.config` to optimize resource usage based on dataset size.
- **Storage Management**: Ensure adequate storage space for intermediate and final results.

## Getting Help

If you encounter any issues or have questions while running **nf-core/atacseq** on the HPCC, consider the following resources:

- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation, tutorials, and community support.
- **ICER Support**: Contact ICER consultants through the [MSU ICER support page](https://icer.msu.edu/contact) for assistance with HPCC-specific questions.
- **Slack Channel**: Join the **nf-core** Slack channel for real-time support and to engage with other users and developers.
- **Nextflow Documentation**: Refer to the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for more details on workflow customization and troubleshooting.

## Conclusion

Running **nf-core/atac-seq** on the MSU HPCC is streamlined with **Singularity** and **Nextflow** modules. This setup supports reproducible, efficient, and large-scale ATAC-seq analyses. By following this guide, you can take full advantage of the HPCC's computing power for your bioinformatics projects.
