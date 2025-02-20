---
layout: post
title: "Running nf-core/chipseq on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview
The **MSU HPCC**, managed by ICER, offers a powerful environment for running bioinformatics analyses. This guide will walk you through running the **nf-core/chipseq** pipeline on the HPCC for reproducible and efficient ChIP-seq data analysis.

## Key Benefits of nf-core/chipseq
**nf-core/chipseq** provides:

- **Reproducible ChIP-seq Analysis**: A robust, community-maintained pipeline.
- **Portability**: Runs smoothly on various computing infrastructures.
- **Scalability**: Handles both small and large ChIP-seq datasets.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic knowledge of **Singularity** and **Nextflow** module usage.

## Step-by-Step Tutorial

### Note on Directory Variables
On the MSU HPCC:
- `$HOME` automatically routes to the user's home directory (`/mnt/home/username`).
- `$SCRATCH` automatically routes to the user's scratch directory, which is ideal for temporary files and large data processing.

### Note on Working Directory
The working directory, which stores intermediate and temporary files, can be specified separately using the `-w` flag when running the pipeline. This helps keep your analysis outputs and temporary data organized.

### 1. Load Nextflow Module
Ensure **Nextflow** is available in your environment:
```bash
module load Nextflow
```

### 2. Create an Analysis Directory
Set up a dedicated directory for your analysis (referred to as the Analysis Directory):
```bash
mkdir $HOME/chipseq_project
cd $HOME/chipseq_project
```
- Modify `$HOME/chipseq_project` to better suit your project description, if needed.

### 3. Prepare Sample Sheet
Create a sample sheet (`samplesheet.csv`) with the following format:
```csv
sample,fastq_1,fastq_2,replicate,antibody
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,1,H3K27ac
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,1,H3K27me3
```
Ensure all paths to the FASTQ files are correct.

### 4. Configure ICER Environment
Create an `icer.config` file to run the pipeline with SLURM:
```groovy
process {
    executor = 'slurm'
}
```

### 5. Run nf-core/chipseq

### Example SLURM Job Submission Script
Below is a typical shell script for submitting an **nf-core/chipseq** job to SLURM:

```bash
#!/bin/bash

#SBATCH --job-name=chipseq_job
#SBATCH --time=48:00:00
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=12

cd $HOME/chipseq_project
module load Nextflow/24.04.2

nextflow pull nf-core/chipseq
nextflow run nf-core/chipseq -r 2.1.0 --input ./samplesheet.csv -profile singularity --outdir ./chipseq_results --fasta ./Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --gtf ./Homo_sapiens.GRCh38.108.gtf.gz -work-dir $SCRATCH/chipseq_work -c ./nextflow.config
```
- Modify `--outdir`, `--fasta`, and `--gtf` to match your output and reference genome paths.

### Note on Reference Genomes
Common reference genomes can be found in the research common-data space on the HPCC. Refer to the README file in that directory for more details. Additionally, you can find guidance on downloading reference genomes from Ensembl in this [GitHub repository](https://github.com/johnvusich/reference-genomes).

Execute the pipeline with the following command. This example includes a `-w` flag to specify a working directory in the user's scratch space for intermediate files:

```bash
nextflow run nf-core/chipseq -profile singularity --input samplesheet.csv --genome GRCh38 -c icer.config -w $SCRATCH/chipseq_project
```
- The `-profile singularity` flag ensures that **Singularity** containers are used.
- Modify `--genome` to match your reference genome.
- Modify `-w $SCRATCH/chipseq_project` to better suit your project description, if needed.

### 6. Monitor and Manage the Run
- Use `squeue` or `sacct` to check the job status.
- Verify the output in the specified results directory.

## Best Practices
- **Check Logs**: Regularly inspect log files generated by the pipeline for any warnings or errors.
- **Resource Allocation**: Adjust the `icer.config` to optimize resource usage based on dataset size.
- **Storage Management**: Ensure adequate storage space for intermediate and final results.

## Getting Help
If you encounter any issues or have questions while running **nf-core/chipseq** on the HPCC, consider the following resources:
- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation, tutorials, and community support.
- **ICER Support**: Contact ICER consultants through the [MSU ICER support page](https://icer.msu.edu/contact) for assistance with HPCC-specific questions.
- **Slack Channel**: Join the **nf-core** Slack channel for real-time support and to engage with other users and developers.
- **Nextflow Documentation**: Refer to the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for more details on workflow customization and troubleshooting.

## Conclusion
Running **nf-core/chipseq** on the MSU HPCC is streamlined with **Singularity** and **Nextflow** modules. This setup supports reproducible, efficient, and large-scale ChIP-seq analyses. By following this guide, you can take full advantage of the HPCC's computing power for your bioinformatics projects.

