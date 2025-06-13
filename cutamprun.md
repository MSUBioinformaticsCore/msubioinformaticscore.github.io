---
layout: post
title: "Running nf-core/cutandrun on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian, Nicholas Panchy
categories: jekyll update
---

## Overview

This guide explains how to run the **nf-core/cutandrun** pipeline for CUT\&RUN and CUT\&Tag analysis, ensuring reproducibility and efficiency.

## Key Benefits of nf-core/cutandrun

**nf-core/cutandrun** offers:

* **Reproducible CUT\&RUN/CUT\&Tag Analysis**: Comprehensive and standardized workflows.
* **Portability**: Runs seamlessly across various computing infrastructures.
* **Scalability**: Capable of handling small and large-scale datasets.

## Prerequisites

- Access to MSU HPCC with a valid ICER account.
- Basic understanding of **Singularity** and **Nextflow**.

### Note on Directory Variables

On the MSU HPCC:

* `$HOME` refers to the user’s home directory (`/mnt/home/username`).
* `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory

The working directory, where intermediate and temporary files are stored, can be specified using the `-w` flag when running the pipeline. This helps keep outputs and temporary data organized.

## Step-by-Step Tutorial

### 1. Create a Project Directory

Set up a directory for your analysis (referred to as the Analysis Directory):

```bash
mkdir $HOME/cutandrun
cd $HOME/cutandrun
```

* Modify `$HOME/cutandrun` to better suit your project.

### 2. Prepare a Sample Sheet
You need to create a file called ```samplesheet.csv``` that lists your samples and their FASTQ file paths. Use a text editor (like nano) to create this file:
```bash
nano samplesheet.csv
```
Then, add your sample information in CSV format. For example:
```csv
sample,fastq_1,fastq_2,replicate,antibody
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,1,H3K27me3
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,1,IgG
```
Save the file (in nano, press Ctrl+O then Ctrl+X to exit).

### 3. Create a Configuration File
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
Now, create a shell script to run the pipeline. Create a file called run_rnaseq.sh:
```bash
nano run_cutandrun.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=cutandrun
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=cutandrun-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/cutandrun/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/cutandrun/results" # Example path to results directory
WORKDIR="$SCRATCH/cutandrun/work" # Example path to work directory
CONFIG="$HOME/cutandrun/icer.config" # Example path to icer.config file

# Run the CUT\&RUN analysis
nextflow pull nf-core/cutandrun
nextflow run nf-core/cutandrun -r 3.2.2 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
-c $CONFIG
```

### 5. Run nf-core/cutandrun

#### Example SLURM Job Submission Script

Submit your job to SLURM by typing:
```bash
sbatch run_rnaseq.sh
```
This sends your job to the scheduler on the HPCC.

### 6. Monitor Your Job
Check the status of your job with:
```bash
squeue -u $USER
```
After completion, your output files will be in the `results` folder inside your `cutandrun` directory.

### Note on Reference Genomes

Common reference genomes are located in the research common-data space on the HPCC. Refer to the README file for details. For more guidance on downloading reference genomes from Ensembl, see this [GitHub repository](https://github.com/johnvusich/reference-genomes).

## Best Practices

- **Review Logs**: Regularly check log files for warnings or errors.
- **Optimize Resource Usage**: Adjust `icer.config` to match your dataset requirements.
- **Manage Storage**: Ensure sufficient storage for intermediate and final results.

## Getting Help

If you encounter issues running **nf-core/cutandrun** on the HPCC, consider these resources:

- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation and support.
- **ICER Support**: Contact ICER via the [MSU ICER support page](https://icer.msu.edu/contact).
- **Slack Channel**: Join the **nf-core** Slack for real-time assistance.
- **Nextflow Documentation**: See the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for further details.

## Conclusion

Running **nf-core/cutandrun** on the MSU HPCC is simplified using **Singularity** and **Nextflow**. This guide ensures reproducible and efficient CUT\&RUN and CUT\&Tag analysis, leveraging the HPCC’s computational capabilities for bioinformatics research.
