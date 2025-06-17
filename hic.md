---
layout: post
title: "Hi-C Analysis Using nf-core/hic and nf-core/differentialabundance on MSU HPCC"
date: 2025-06-17
author: John Vusich, Leah Terrian, Nicholas Panchy
categories: jekyll update
---

## Overview

This guide will show you, step by step, how to analyze Hi-C data using the **nf-core/hic** pipeline for quality control, alignment, creating contact maps, and calling TADs and compartments.

## Key Benefits

- **Reproducibility**: Community-curated workflows ensure standardized analysis.
- **Portability**: Run seamlessly on various infrastructures.
- **Scalability**: Handles datasets of different sizes efficiently.

## Prerequisites

- Access to MSU HPCC with a valid ICER account.
- Basic familiarity with the command line.

### Note on Directory Variables

On the MSU HPCC:

* `$HOME` refers to the user’s home directory (`/mnt/home/username`).
* `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory

The working directory, where intermediate and temporary files are stored, can be specified using the `-w` flag when running the pipeline. This helps keep outputs and temporary data organized.

## Step-by-Step Tutorial

## Part 1: Pre-processing with nf-core/hic

#### 1. Create a Project Directory
Make a new folder for your Hi-C analysis:
```bash
mkdir $HOME/hic
cd $HOME/hic
```
This command creates the directory and moves you into it.

#### 2. Prepare a Sample Sheet
You need to create a file called ```samplesheet.csv``` that lists your samples and their FASTQ file paths. Use a text editor (like nano) to create this file:
```bash
nano samplesheet.csv
```
Then, add your sample information in CSV format. For example:
```pgsql
sample,fastq_1,fastq_2
CONTROL_REP1,/path/to/CONTROL_REP1_R1.fastq.gz,/path/to/CONTROL_REP1_R2.fastq.gz
CONTROL_REP2,/path/to/CONTROL_REP2_R1.fastq.gz,/path/to/CONTROL_REP2_R2.fastq.gz
TREATMENT_REP1,/path/to/TREATMENT_REP1_R1.fastq.gz,/path/to/TREATMENT_REP1_R2.fastq.gz
TREATMENT_REP2,/path/to/TREATMENT_REP2_R1.fastq.gz,/path/to/TREATMENT_REP2_R2.fastq.gz
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
Now, create a shell script to run the pipeline. Create a file called run_hic.sh:
```bash
nano run_hic.sh
```
Paste in the following script:
```bash
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
```
Make edits as needed. Save and close the file.

#### Hi-C [Use case](https://nf-co.re/hic/2.1.0/docs/usage/#use-case) specific parameters
Hi-C digestion protocol:
```bash
nextflow run nf-core/hic --input $SAMPLESHEET --outdir $OUTDIR --fasta $FASTA --digestion 'dnpii'
```
--digestion automatically sets the --restriction_site and --ligation_site parameter according to the restriction enzyme you used. Available keywords are ‘hindiii’, ‘dpnii’, ‘mboi’, ‘arima’.

DNase Hi-C protocol:
```bash
nextflow run nf-core/hic --input $SAMPLESHEET --outdir $OUTDIR --fasta $FASTA --dnase --min_cis_dist 1000
```
Using --dnase mode, all options related to digestion Hi-C are ignored. Using the --min_cis_dist parameter is recommended to remove spurious ligation products.

#### 5. Submit Your Job
Submit your job to SLURM by typing:
```bash
sbatch run_hic.sh
```
This sends your job to the scheduler on the HPCC.

### 6. Monitor Your Job
Check the status of your job with:
```bash
squeue -u $USER
```
After completion, your output files will be in the `results` folder inside your `hic` directory.

## Quick Reminders
- **Never type file content into the terminal.** Always create or edit files using a text editor (like **nano**).
- Follow each step carefully.
- Visit the [`nf-core/hic`](https://nf-co.re/hic) or [`nf-core/differentialabundance`](https://nf-co.re/differentialabundance) webpage for more detailed instructions and use cases.

### Getting Help

If you encounter issues running **nf-core/hic** on the HPCC, consider these resources:

- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation and support.
- **ICER Support**: Contact ICER via the [MSU ICER support page](https://icer.msu.edu/contact).
- **Slack Channel**: Join the **nf-core** Slack for real-time assistance.
- **Nextflow Documentation**: See the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for further details.

---

## Conclusion
Using **nf-core/hic** and **nf-core/differentialabundance** on the MSU HPCC simplifies the process of Hi-C analysis, including QC, alignment, quantification, and downstream analysis. The combination of **Singularity** and **Nextflow** ensures a reproducible and efficient workflow tailored for high-performance computing environments.

---

