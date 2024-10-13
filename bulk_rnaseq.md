---
layout: post
title: "Running Bulk RNA-Seq Analysis on MSU HPCC Using nf-core/rnaseq and SLURM"
date: 2024-09-23
categories: jekyll update
---

# Running Bulk RNA-Seq Analysis on MSU HPCC Using nf-core/rnaseq and SLURM

This guide provides step-by-step instructions for running bulk RNA-Seq analysis on the Michigan State University High-Performance Computing Center (MSU HPCC) using the `nf-core/rnaseq` pipeline and SLURM as the job executor. It is designed for users who are new to Linux and High-Performance Computing (HPC).

---

## Overview

This workflow quantifies transcript-level RNA-Seq abundance, detects differentially expressed genes (DEGs), and performs gene set enrichment analysis (GSEA). It uses:

- **STAR**: To map FASTQ reads to the reference genome.
- **Salmon**: For BAM-level quantification.
- **DESeq2**: To normalize counts and detect DEGs.

---

## Prerequisites

- **MSU HPCC Account**: Ensure you have an active account on the MSU HPCC.
- **Basic Command Line Knowledge**: Familiarity with Linux command-line operations.
- **FASTQ Files**: Your RNA-Seq data files.
- **Reference Genome and GTF Files**: Available in ICER common-data or downloadable from Ensembl.
- **Web Browser**: Access to MSU HPCC OnDemand via Chrome, Firefox, or Safari.

---

## Resource Requirements

- **Memory**: STAR typically uses around 38GB of RAM.
- **HPC Access**: It is recommended to run this workflow on the HPCC due to resource demands.

---

## Step-by-Step Guide

### 1. Create a Directory for Your Analysis

- **Log in to HPCC OnDemand**:
  - Navigate to [MSU HPCC OnDemand](https://ondemand.hpcc.msu.edu/).

- **Navigate to Home Directory**:
  - Click on **"Files"** in the navigation bar.
  - Select **"Home Directory"**.

- **Create a New Directory**:
  - Click **"New Directory"**.
  - Name your directory (e.g., `rnaseq`).
  - Navigate into the newly created `rnaseq` directory.

- **Upload Your Data**:
  - Upload your FASTQ files into this directory.

### 2. Create a Samplesheet for RNA-Seq Pre-processing

- **Create Samplesheet File**:
  - In your `rnaseq` directory, click **"New File"**.
  - Name the file `samplesheet.csv`.

- **Edit Samplesheet**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Enter your sample information in CSV format. Below is a template:

    ```csv
    sample,fastq_1,fastq_2,strandedness
    CONTROL_REP1,/path/to/fastq/CONTROL_REP1_R1_001.fastq.gz,/path/to/fastq/CONTROL_REP1_R2_001.fastq.gz,auto
    CONTROL_REP2,/path/to/fastq/CONTROL_REP2_R1_001.fastq.gz,/path/to/fastq/CONTROL_REP2_R2_001.fastq.gz,auto
    CONTROL_REP3,/path/to/fastq/CONTROL_REP3_R1_001.fastq.gz,/path/to/fastq/CONTROL_REP3_R2_001.fastq.gz,auto
    TREATED_REP1,/path/to/fastq/TREATED_REP1_R1_001.fastq.gz,/path/to/fastq/TREATED_REP1_R2_001.fastq.gz,auto
    TREATED_REP2,/path/to/fastq/TREATED_REP2_R1_001.fastq.gz,/path/to/fastq/TREATED_REP2_R2_001.fastq.gz,auto
    TREATED_REP3,/path/to/fastq/TREATED_REP3_R1_001.fastq.gz,/path/to/fastq/TREATED_REP3_R2_001.fastq.gz,auto
    ```

    *Note*: Replace the paths with the actual paths to your FASTQ files.

- **Save** the `samplesheet.csv` file.

### 3. Create a Nextflow Configuration File

- **Create Config File**:
  - In your `rnaseq` directory, click **"New File"**.
  - Name the file `nextflow.config`.

- **Edit Config File**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Add the following content to use SLURM as the process executor:

    ```groovy
    process {
        executor = 'slurm'
    }
    ```

- **Save** the `nextflow.config` file.

### 4. Obtain the Reference Genome and GTF Files

- **Option 1: Use ICER Common-Data**:
  - The following organisms have updated reference genomes and GTF/GFF3 files in `common-data`: human, mouse, rat, zebrafish, and Arabidopsis.
  - Paths to these files can be found [here](https://github.com/johnvusich/reference-genomes).

- **Option 2: Download from Ensembl**:
  - Open a terminal in your `rnaseq` directory by clicking **"Open in Terminal"**.
  - Run the following commands to download the genome and GTF files (replace with your organism of interest):

    ```bash
    wget https://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
    wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz
    ```

    *Note*: Downloading large files may take several minutes.

### 5. Write a Bash Script to Run the RNA-Seq Pipeline Using SLURM

- **Create Bash Script**:
  - In your `rnaseq` directory, click **"New File"**.
  - Name the file `run_rnaseq.sb`.

- **Edit Bash Script**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Write the script using `#SBATCH` directives to set resources. Here's a template:

    ```bash
    #!/bin/bash

    #SBATCH --job-name=rnaseq_pipeline
    #SBATCH --time=24:00:00
    #SBATCH --mem=40GB
    #SBATCH --cpus-per-task=8

    cd $HOME/rnaseq
    module load Nextflow/23.10.0

    nextflow pull nf-core/rnaseq
    nextflow run nf-core/rnaseq -r 3.14.0 \
        --input ./samplesheet.csv \
        -profile singularity \
        --outdir ./rnaseq_results \
        --fasta ./Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz \
        --gtf ./Homo_sapiens.GRCh38.108.gtf.gz \
        -work-dir $SCRATCH/rnaseq_work \
        -c ./nextflow.config
    ```

    *Note*: Adjust resource allocations and file paths according to your data and requirements.

- **Save** the `run_rnaseq.sb` file.

### 6. Run the RNA-Seq Pipeline

- **Open Terminal**:
  - In your `rnaseq` directory, click **"Open in Terminal"**.

- **Submit the Job to SLURM**:

  ```bash
  sbatch run_rnaseq.sb
  ```
- **Check Job Status**:

  ```bash
  squeue -u $USER
  ```
  
  *Note: Replace `$USER` with your username if necessary.*

### 7. Create a Samplesheet for Differential Expression Analysis

- **Create DE Samplesheet File**:
  - In your `rnaseq` directory, click **"New File"**.
  - Name the file `DE_samplesheet.csv`.
- **Edit DE Samplesheet**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Enter your sample information in CSV format. Below is a template:
    ```csv
    sample,fastq_1,fastq_2,condition,replicate,batch
    CONTROL_REP1,/path/to/fastq/CONTROL_REP1_R1_001.fastq.gz,/path/to/fastq/CONTROL_REP1_R2_001.fastq.gz,control,1,
    CONTROL_REP2,/path/to/fastq/CONTROL_REP2_R1_001.fastq.gz,/path/to/fastq/CONTROL_REP2_R2_001.fastq.gz,control,2,
    CONTROL_REP3,/path/to/fastq/CONTROL_REP3_R1_001.fastq.gz,/path/to/fastq/CONTROL_REP3_R2_001.fastq.gz,control,3,
    TREATED_REP1,/path/to/fastq/TREATED_REP1_R1_001.fastq.gz,/path/to/fastq/TREATED_REP1_R2_001.fastq.gz,treated,1,
    TREATED_REP2,/path/to/fastq/TREATED_REP2_R1_001.fastq.gz,/path/to/fastq/TREATED_REP2_R2_001.fastq.gz,treated,2,
    TREATED_REP3,/path/to/fastq/TREATED_REP3_R1_001.fastq.gz,/path/to/fastq/TREATED_REP3_R2_001.fastq.gz,treated,3,
    ```
    *Note: Ensure the condition and replicate columns accurately reflect your experimental design.*
- **Save** the `DE_samplesheet.csv` file.

### 8. Create a Contrasts File for Differential Expression Analysis

- **Create Contrasts File**:
  - In your `rnaseq` directory, click **"New File"**.
  - Name the file `contrasts.csv`.
- **Edit Contrasts File**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Enter your sample information in CSV format. Below is a template:
    ```csv
    id,variable,reference,target,blocking
    condition_control_treated,condition,control,treated,
    ```
    *Note: Adjust the variables according to your experimental design.*
- **Save** the `contrasts.csv` file.

### 9. Write a Bash Script to Run Differential Expression Analysis Using SLURM

- **Create Bash Script**:
  - In your `rnaseq` directory, click **"New File"**.
  - Name the file `run_differential.sb`.

- **Edit Bash Script**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Write the script using `#SBATCH` directives to set resources. Here's a template:

    ```bash
    #!/bin/bash

    #SBATCH --job-name=differential_analysis
    #SBATCH --time=24:00:00
    #SBATCH --mem=24GB
    #SBATCH --cpus-per-task=8

    cd $HOME/rnaseq
    module load Nextflow/23.10.0

    nextflow pull nf-core/differentialabundance
    nextflow run nf-core/differentialabundance -r 1.5.0 \
      --input ./DE_samplesheet.csv \
      --contrasts ./contrasts.csv \
      --matrix ./rnaseq_results/star_salmon/salmon.merged.gene_counts_length_scaled.tsv \
      --gtf ./Homo_sapiens.GRCh38.108.gtf.gz \
      --outdir ./differential_results \
      -profile singularity \
      -work-dir $SCRATCH/differential_work \
      -c ./nextflow.config
    ```

    *Note*: Adjust resource allocations and file paths according to your data and requirements.

- **Save** the `run_differential.sb` file.

### 10. Run the Differential Expression Analysis Pipeline

- **Open Terminal**:
  - In your `rnaseq` directory, click **"Open in Terminal"**.

- **Submit the Job to SLURM**:

  ```bash
  sbatch run_differential.sb
  ```
- **Check Job Status**:

  ```bash
  squeue -u $USER
  ```
  
  *Note: Replace `$USER` with your username if necessary.*

---

## Additional Information

### Understanding Key Terms
- **nf-core**: A community effort to collect a curated set of analysis pipelines built using Nextflow.
- **Nextflow**: A workflow management system that enables scalable and reproducible scientific workflows.
- **SLURM**: A workload manager used in HPC environments to schedule jobs.
- **Singularity**: A container platform used to package applications for reproducibility.

### Tips for New Users
- **File Paths**: Ensure all file paths in your scripts and samplesheets are correct.
- **Resource Allocation**: Adjust #SBATCH directives based on your data size and resource availability.
- **Monitoring Jobs**: Use squeue, scontrol, and sacct to monitor and manage your jobs.

### Getting Help
- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)
- **nf-core/rnaseq Documentation**:
  - Visit the [nf-core/rnaseq GitHub page](https://github.com/nf-core) for more information.

---

## Summary

By following these steps, you should be able to run bulk RNA-Seq analysis and differential expression analysis on the MSU HPCC using nf-core pipelines and SLURM. If you encounter any issues or have questions, don't hesitate to reach out to the support resources listed above.
