---
layout: post
title: "Running nf-core/cutandrun on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview
The **MSU HPCC**, managed by ICER, provides an optimal platform for conducting bioinformatics workflows. This guide explains how to run the **nf-core/cutandrun** pipeline for CUT&RUN and CUT&Tag analysis, ensuring reproducibility and efficiency.

## Key Benefits of nf-core/cutandrun
**nf-core/cutandrun** offers:

- **Reproducible CUT&RUN/CUT&Tag Analysis**: Comprehensive and standardized workflows.
- **Portability**: Runs seamlessly across various computing infrastructures.
- **Scalability**: Capable of handling small and large-scale datasets.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic understanding of **Singularity** and **Nextflow**.

## Step-by-Step Tutorial

### Note on Directory Variables
On the MSU HPCC:
- `$HOME` refers to the user’s home directory (`/mnt/home/username`).
- `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory
The working directory, where intermediate and temporary files are stored, can be specified using the `-w` flag when running the pipeline. This helps keep outputs and temporary data organized.

### 1. Load Nextflow Module
Ensure **Nextflow** is loaded:
```bash
module load Nextflow
```

### 2. Create an Analysis Directory
Set up a directory for your analysis (referred to as the Analysis Directory):
```bash
mkdir $HOME/cutandrun_project
cd $HOME/cutandrun_project
```
- Modify `$HOME/cutandrun_project` to better suit your project.

### 3. Prepare Sample Sheet
Create a sample sheet (`samplesheet.csv`) with the following format:
```csv
sample,fastq_1,fastq_2,replicate,antibody
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,1,H3K27me3
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,1,IgG
```
Ensure all paths to the FASTQ files are accurate.

### 4. Configure ICER Environment
Create an `icer.config` file for SLURM:
```groovy
process {
    executor = 'slurm'
}
```

### 5. Run nf-core/cutandrun

### Example SLURM Job Submission Script
Below is a shell script for submitting an **nf-core/cutandrun** job to SLURM:

```bash
#!/bin/bash

#SBATCH --job-name=cutandrun_job
#SBATCH --time=48:00:00
#SBATCH --mem=48GB
#SBATCH --cpus-per-task=12

cd $HOME/cutandrun_project
module load Nextflow/24.04.2

nextflow pull nf-core/cutandrun
nextflow run nf-core/cutandrun -r 3.2.2 --input ./samplesheet.csv -profile singularity --outdir ./cutandrun_results --genome GRCh38 -work-dir $SCRATCH/cutandrun_work -c ./nextflow.config
```
- Modify `--outdir` and `--genome` to match your paths and reference genome.

### Note on Reference Genomes
Common reference genomes are located in the research common-data space on the HPCC. Refer to the README file for details. For more guidance on downloading reference genomes from Ensembl, see this [GitHub repository](https://github.com/johnvusich/reference-genomes).

Execute the pipeline with the following command, including the `-w` flag for a separate working directory:

```bash
nextflow run nf-core/cutandrun -profile singularity --input samplesheet.csv --genome GRCh38 -c icer.config -w $SCRATCH/cutandrun_project
```
- Modify `-w $SCRATCH/cutandrun_project` as needed.

### 6. Monitor and Manage the Run
- Use `squeue` or `sacct` to track job status.
- Check the output directory for results.

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
Running **nf-core/cutandrun** on the MSU HPCC is simplified using **Singularity** and **Nextflow**. This guide ensures reproducible and efficient CUT&RUN and CUT&Tag analysis, leveraging the HPCC’s computational capabilities for bioinformatics research.

