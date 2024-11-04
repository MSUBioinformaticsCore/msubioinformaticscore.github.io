---
layout: post
title: "Running nf-core/sarek on MSU HPCC"
date: 2024-11-04
author: "John Vusich"
categories: jekyll update
---

## Overview
The **MSU HPCC**, managed by ICER, provides a robust platform for running bioinformatics pipelines. This guide details how to run the **nf-core/sarek** pipeline for whole genome sequencing (WGS) analysis, ensuring efficient and reproducible workflows.

## Key Benefits of nf-core/sarek
**nf-core/sarek** offers:

- **Reproducible WGS Analysis**: Supports germline and somatic variant calling.
- **Portability**: Runs seamlessly across various computing infrastructures.
- **Scalability**: Handles both small-scale and large-scale WGS datasets.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic understanding of **Singularity** and **Nextflow**.

## Step-by-Step Tutorial

### Note on Directory Variables
On the MSU HPCC:
- `$HOME` refers to the user’s home directory (`/mnt/home/username`).
- `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory
The working directory, where intermediate and temporary files are stored, can be specified using the `-w` flag when running the pipeline. This keeps outputs and temporary data organized.

### 1. Load Nextflow Module
Ensure **Nextflow** is loaded:
```bash
module load Nextflow
```

### 2. Create an Analysis Directory
Set up a directory for your analysis (referred to as the Analysis Directory):
```bash
mkdir $HOME/sarek_project
cd $HOME/sarek_project
```
- Modify `$HOME/sarek_project` to better suit your project.

### 3. Prepare Sample Sheet
Create a sample sheet (`samplesheet.csv`) with the following format:
```csv
subject,sex,tumor,fastq_1,fastq_2
sample1,male,yes,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
sample2,female,no,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
```
Ensure all paths to the FASTQ files are accurate.

### 4. Configure ICER Environment
Create an `icer.config` file for SLURM:
```groovy
process {
    executor = 'slurm'
}
```

### 5. Run nf-core/sarek

### Example SLURM Job Submission Script
Below is a shell script for submitting an **nf-core/sarek** job to SLURM:

```bash
#!/bin/bash

#SBATCH --job-name=sarek_job
#SBATCH --time=72:00:00
#SBATCH --mem=64GB
#SBATCH --cpus-per-task=16

cd $HOME/sarek_project
module load Nextflow/23.10.0

nextflow pull nf-core/sarek
nextflow run nf-core/sarek -r 3.14.0 --input ./samplesheet.csv -profile singularity --outdir ./sarek_results --genome GRCh38 -work-dir $SCRATCH/sarek_work -c ./nextflow.config
```
- Modify `--outdir` and `--genome` to match your paths and reference genome.

### Note on Reference Genomes
Common reference genomes are located in the research common-data space on the HPCC. Refer to the README file for details. For more guidance on downloading reference genomes from Ensembl, see this [GitHub repository](https://github.com/johnvusich/reference-genomes).

Execute the pipeline with the following command, including the `-w` flag for a separate working directory:

```bash
nextflow run nf-core/sarek -profile singularity --input samplesheet.csv --genome GRCh38 -c icer.config -w $SCRATCH/sarek_project
```
- Modify `-w $SCRATCH/sarek_project` as needed.

### 6. Monitor and Manage the Run
- Use `squeue` or `sacct` to track job status.
- Check the output directory for results.

## Best Practices
- **Review Logs**: Regularly check log files for warnings or errors.
- **Optimize Resource Usage**: Adjust `icer.config` to match your dataset requirements.
- **Manage Storage**: Ensure ample storage for intermediate and final data.

## Getting Help
If you encounter issues running **nf-core/sarek** on the HPCC, consult the following resources:
- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation and support.
- **ICER Support**: Contact ICER via the [MSU ICER support page](https://icer.msu.edu/contact).
- **Slack Channel**: Join the **nf-core** Slack for real-time help.
- **Nextflow Documentation**: See the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for additional details.

## Conclusion
Running **nf-core/sarek** on the MSU HPCC is streamlined using **Singularity** and **Nextflow**. This guide ensures reproducible and scalable WGS analysis, maximizing the HPCC’s computational resources for bioinformatics research.

