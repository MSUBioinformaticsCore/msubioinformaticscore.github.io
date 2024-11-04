---
layout: post
title: "Running nf-core/methylseq on MSU HPCC"
date: 2024-11-04
author: "John Vusich"
categories: jekyll update
---

## Overview
The **MSU HPCC**, managed by ICER, is an excellent platform for bioinformatics workflows. This guide explains how to run the **nf-core/methylseq** pipeline for methylation (bisulfite-sequencing) analysis, ensuring efficiency and reproducibility.

## Key Benefits of nf-core/methylseq
**nf-core/methylseq** provides:

- **Reproducible Methylation Analysis**: Comprehensive and standardized workflows.
- **Portability**: Runs seamlessly across computing environments.
- **Scalability**: Processes both small and large datasets effectively.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic understanding of **Singularity** and **Nextflow**.

## Step-by-Step Tutorial

### Note on Directory Variables
On the MSU HPCC:
- `$HOME` refers to the user’s home directory (`/mnt/home/username`).
- `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory
The working directory, which stores intermediate and temporary files, can be specified using the `-w` flag when running the pipeline. This helps keep outputs and temporary data organized.

### 1. Load Nextflow Module
Ensure **Nextflow** is loaded:
```bash
module load Nextflow
```

### 2. Create an Analysis Directory
Set up a directory for your analysis (referred to as the Analysis Directory):
```bash
mkdir $HOME/methylseq_project
cd $HOME/methylseq_project
```
- Modify `$HOME/methylseq_project` to better suit your project.

### 3. Prepare Sample Sheet
Create a sample sheet (`samplesheet.csv`) with the following format:
```csv
sample,fastq_1,fastq_2,replicate
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,1
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,1
```
Ensure all paths to the FASTQ files are accurate.

### 4. Configure ICER Environment
Create an `icer.config` file for SLURM:
```groovy
process {
    executor = 'slurm'
}
```

### 5. Run nf-core/methylseq

### Example SLURM Job Submission Script
Below is a shell script for submitting an **nf-core/methylseq** job to SLURM:

```bash
#!/bin/bash

#SBATCH --job-name=methylseq_job
#SBATCH --time=48:00:00
#SBATCH --mem=48GB
#SBATCH --cpus-per-task=12

cd $HOME/methylseq_project
module load Nextflow/23.10.0

nextflow pull nf-core/methylseq
nextflow run nf-core/methylseq -r 3.14.0 --input ./samplesheet.csv -profile singularity --outdir ./methylseq_results --fasta ./Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --bismark_index ./bismark_index/ -work-dir $SCRATCH/methylseq_work -c ./nextflow.config
```
- Modify `--outdir`, `--fasta`, and `--bismark_index` to match your paths and reference genome.

### Note on Reference Genomes
Common reference genomes are located in the research common-data space on the HPCC. Refer to the README file for details. For guidance on downloading reference genomes from Ensembl, see this [GitHub repository](https://github.com/johnvusich/reference-genomes).

Execute the pipeline with the following command, including the `-w` flag for a separate working directory:

```bash
nextflow run nf-core/methylseq -profile singularity --input samplesheet.csv --genome GRCh38 -c icer.config -w $SCRATCH/methylseq_project
```
- Modify `-w $SCRATCH/methylseq_project` as needed.

### 6. Monitor and Manage the Run
- Use `squeue` or `sacct` to track job status.
- Check the output directory for results.

## Best Practices
- **Review Logs**: Regularly check log files for warnings or errors.
- **Optimize Resource Usage**: Adjust `icer.config` to match your dataset requirements.
- **Manage Storage**: Ensure sufficient storage for intermediate and final results.

## Getting Help
If you encounter issues running **nf-core/methylseq** on the HPCC, consider these resources:
- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation and support.
- **ICER Support**: Contact ICER via the [MSU ICER support page](https://icer.msu.edu/contact).
- **Slack Channel**: Join the **nf-core** Slack for real-time assistance.
- **Nextflow Documentation**: See the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for further details.

## Conclusion
Running **nf-core/methylseq** on the MSU HPCC is simplified using **Singularity** and **Nextflow**. This guide ensures reproducible and efficient methylation analysis, leveraging the HPCC’s computational capabilities for bioinformatics research.

