---
layout: post
title: "Running CUT&RUN Analysis on MSU HPCC Using nf-core/cutandrun and SLURM"
date: 2024-10-14
author: "John Vusich"
categories: jekyll update
---

# Running CUT&RUN Analysis on MSU HPCC Using nf-core/cutandrun and SLURM

This tutorial provides step-by-step instructions for analyzing CUT&RUN data on the Michigan State University High-Performance Computing Center (MSU HPCC) using the `nf-core/cutandrun` pipeline and SLURM as the job executor. It is designed for users new to Linux and High-Performance Computing (HPC).

---

## Prerequisites

- **MSU HPCC Account**: Ensure you have an active account on the MSU HPCC.
- **Basic Command Line Knowledge**: Familiarity with Linux command-line operations.
- **FASTQ Files**: Your CUT&RUN data files.
- **Reference Genome and GTF Files**: Available in ICER common-data or downloadable from Ensembl.
- **Web Browser**: Access to MSU HPCC OnDemand via Chrome, Firefox, or Safari.

---

## Step-by-Step Guide

### 1. Create a Directory for Analysis

- **Log in to HPCC OnDemand**:
  - Navigate to [MSU HPCC OnDemand](https://ondemand.hpcc.msu.edu/).

- **Navigate to Home Directory**:
  - Click on **"Files"** in the navigation bar.
  - Select **"Home Directory"**.

- **Create a New Directory**:
  - Click **"New Directory"**.
  - Name your directory (e.g., `cutandrun`).
  - Navigate into the newly created `cutandrun` directory.

- **Upload Your Data**:
  - Upload your FASTQ files into this directory.

---

### 2. Create a Samplesheet for CUT&RUN Pre-processing

- **Create Samplesheet File**:
  - In your `cutandrun` directory, click **"New File"**.
  - Name the file `samplesheet.csv`.

- **Edit Samplesheet**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Enter your sample information in CSV format. Below is a template:

    ```csv
    group,replicate,fastq_1,fastq_2,control
    h3k27me3,1,h3k27me3_rep1_r1.fastq.gz,h3k27me3_rep1_r2.fastq.gz,igg_ctrl
    h3k27me3,2,h3k27me3_rep2_r1.fastq.gz,h3k27me3_rep2_r2.fastq.gz,igg_ctrl
    igg_ctrl,1,igg_rep1_r1.fastq.gz,igg_rep1_r2.fastq.gz,
    igg_ctrl,2,igg_rep2_r1.fastq.gz,igg_rep2_r2.fastq.gz,
    ```

    *Note*: Replace the paths with the actual paths to your FASTQ files.

- **Save** the `samplesheet.csv` file.

---

### 3. Create a Nextflow Configuration File

- **Create Config File**:
  - In your `cutandrun` directory, click **"New File"**.
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

---

### 4. Obtain the Reference Genome and GTF Files

- **Option 1: Use ICER Common-Data**:
  - The following organisms have updated reference genomes and GTF/GFF3 files in `common-data`: human, mouse, rat, zebrafish, and Arabidopsis.
  - Paths to these files can be found [here](https://github.com/johnvusich/reference-genomes).

- **Option 2: Download from Ensembl**:
  - Open a terminal in your `cutandrun` directory by clicking **"Open in Terminal"**.
  - Run the following commands to download the genome and GTF files (replace with your organism of interest):

    ```bash
    wget https://ftp.ensembl.org/pub/release-108/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
    wget https://ftp.ensembl.org/pub/release-108/gtf/homo_sapiens/Homo_sapiens.GRCh38.108.gtf.gz
    ```

    *Note*: Downloading large files may take several minutes.

---

### 5. Write a Bash Script to Run the CUT&RUN Pipeline Using SLURM

- **Create Bash Script**:
  - In your `cutandrun` directory, click **"New File"**.
  - Name the file `run_cutandrun.sb`.

- **Edit Bash Script**:
  - Click the `⋮` symbol next to the file and select **"Edit"**.
  - Write the script using `#SBATCH` directives to set resources. Here's a template:

    ```bash
    #!/bin/bash

    #SBATCH --job-name=cutandrun_pipeline
    #SBATCH --time=24:00:00
    #SBATCH --mem=24GB
    #SBATCH --cpus-per-task=8

    cd $HOME/cutandrun
    module load Nextflow/23.10.0

    nextflow pull nf-core/cutandrun
    nextflow run nf-core/cutandrun -r 3.2.2 \
        --input ./samplesheet.csv \
        -profile singularity \
        --outdir ./cutandrun_results \
        --fasta ./Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz \
        --gtf ./Homo_sapiens.GRCh38.108.gtf.gz \
        -work-dir $SCRATCH/cutandrun_work \
        -c ./nextflow.config
    ```

    *Note*: Adjust resource allocations and file paths according to your data and requirements.

- **Save** the `run_cutandrun.sb` file.

---

### 6. Run the CUT&RUN Pipeline

- **Open Terminal**:
  - In your `cutandrun` directory, click **"Open in Terminal"**.

- **Submit the Job to SLURM**:

    ```bash
    sbatch run_cutandrun.sb
    ```

- **Check Job Status**:

    ```bash
    squeue -u $USER
    ```

    *Note*: Replace `$USER` with your username if necessary.

---

## Additional Information

### Understanding Key Terms

- **nf-core**: A community effort to collect a curated set of analysis pipelines built using Nextflow.
- **Nextflow**: A workflow management system that enables scalable and reproducible scientific workflows.
- **SLURM**: A workload manager used in HPC environments to schedule jobs.
- **Singularity**: A container platform used to package applications for reproducibility.

### Tips for New Users

- **File Paths**: Ensure all file paths in your scripts and samplesheets are correct.
- **Resource Allocation**: Adjust `#SBATCH` directives based on your data size and resource availability.
- **Monitoring Jobs**: Use `squeue`, `scontrol`, and `sacct` to monitor and manage your jobs.

---

## Conclusion
By following these steps, you should be able to run CUT&RUN analysis on the MSU HPCC using the nf-core pipeline and SLURM. If you encounter any issues or have questions, don't hesitate to reach out to the support resources listed above.

---

### Getting Help

- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)

- **nf-core/cutandrun Documentation**:
  - Visit the [nf-core/cutandrun GitHub page](https://github.com/nf-core/cutandrun) for more information.
