---
layout: post
post title: "Comprehensive Bulk RNA-seq Analysis Using nf-core/rnaseq and nf-core/differential-abundance on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian, Nicholas Panchy
categories: jekyll update
---

## Overview

This guide will show you, step by step, how to analyze bulk RNA-seq data using the **nf-core/rnaseq** pipeline (for QC, alignment, and quantification) and the **nf-core/differential-abundance** pipeline for differential expression analysis and GSEA. Users can click [here](bulk_rnaseq.md#2-differential-expression-and-gsea) to skip directly to the differential abundance and GSEA steps if they already have a counts table.

## Key Benefits

- **Reproducibility**: Community-curated workflows ensure standardized analysis.
- **Portability**: Run seamlessly on various infrastructures.
- **Scalability**: Handles datasets of different sizes efficiently.

## Prerequisites

- Access to MSU HPCC with a valid ICER account.
- Basic familiarity with the command line.

## Part 1: Pre-processing with nf-core/rnaseq

#### 1. Create Your Project Directory
Make a new folder for your RNA-seq analysis:
```bash
mkdir $HOME/rnaseq_project
cd $HOME/rnaseq_project
```
This command creates the directory and moves you into it.

#### 2. Prepare Your Sample Sheet
You need to create a file called ```samplesheet.csv``` that lists your samples and their FASTQ file paths. Use a text editor (like nano) to create this file:
```bash
nano samplesheet.csv
```
Then, add your sample information in CSV format. For example:
```pgsql
sample,fastq_1,fastq_2,strandness
CONTROL_REP1,/path/to/CONTROL_REP1_R1.fastq.gz,/path/to/CONTROL_REP1_R2.fastq.gz,auto
CONTROL_REP2,/path/to/CONTROL_REP2_R1.fastq.gz,/path/to/CONTROL_REP2_R2.fastq.gz,auto
TREATMENT_REP1,/path/to/TREATMENT_REP1_R1.fastq.gz,/path/to/TREATMENT_REP1_R2.fastq.gz,auto
TREATMENT_REP2,/path/to/TREATMENT_REP2_R1.fastq.gz,/path/to/TREATMENT_REP2_R2.fastq.gz,auto
```
Save the file (in nano, press Ctrl+O then Ctrl+X to exit).

#### 3. Create the Configuration File
Do not type file content directly into the terminal—use a text editor instead. Create a file named icer.config:
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
nano run_rnaseq.sh
```
Paste in the following script:
```bash
#!/bin/bash --login

#SBATCH --job-name=rnaseq_job
#SBATCH --time=24:00:00
#SBATCH --mem=8GB
#SBATCH --cpus-per-task=4

cd $HOME/rnaseq_project
module purge
module load Nextflow/24.10.2

# Pull the latest nf-core/rnaseq pipeline
nextflow pull nf-core/rnaseq

# Run the pipeline
nextflow run nf-core/rnaseq -r 3.18.0 -profile singularity --input ./samplesheet.csv --outdir ./rnaseq_results --genome GRCh38 -work-dir $SCRATCH/rnaseq_work -c ./icer.config
```
Save and close the file.

#### 5. Submit Your Job
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
After completion, your output files will be in the rnaseq_results folder inside your project directory.

## Part 2: *Optional* – Differential Expression Analysis

If you already have a counts table and want to perform differential expression and GSEA using nf-core/differential-abundance, follow these additional steps.

### 1. Create a New Project Directory
Create a separate folder for the differential expression analysis:
```bash
mkdir $HOME/diff_exp_project
cd $HOME/diff_exp_project
```

### 2. Prepare the Samplesheet and Input Files
Create a ```samplesheet.csv``` for differential analysis:
```bash
nano samplesheet.csv
```
Example content:
```pgsql
sample,condition,replicate,batch
CONTROL_REP1,control,1,A
CONTROL_REP2,control,2,B
TREATMENT_REP1,treated,1,A
TREATMENT_REP2,treated,2,B
```

Also, ensure you have:
- (**Required**) A counts file (e.g., ```salmon.merged.gene_counts.tsv```)
- (*Optional*) For best practices, a transcript length matrix (e.g., ```salmon.merged.gene_lengths.tsv```)
- (**Required**) A contrasts file (e.g., ```contrasts.csv```)

#### Counts and transcript length files
The nf-core RNAseq workflow (described above) creates a raw counts and transcript length matrix file that can be used directly in the nf-core Differential Abundance workflow. Provide the paths to those files in the submission script in step 3 (below):
```bash
--matrix $HOME/rnaseq_project/rnaseq_results/star_salmon/salmon.merged.gene_counts.tsv \
--transcript_length_matrix $HOME/rnaseq_project/rnaseq_results/star_salmon/salmon.merged.gene_lengths.tsv
```
See [this](https://nf-co.re/differentialabundance/1.5.0/docs/usage/#abundance-values) documentation for more information on RNAseq gene counts for *nf-core/differentialabundance*.

#### Contrasts file
The contrasts file defines the groups of samples to compare.
```bash
--contrasts '[path to contrasts file]'
```
Example ```contrasts.csv``` file:
```csv
id,variable,reference,target,blocking
condition_control_treated,condition,control,treated,
condition_control_treated_blockrep,condition,control,treated,replicate;batch
```
See [this](https://nf-co.re/differentialabundance/1.5.0/docs/usage/#contrasts-file) documentation for more information on the contrasts file for *nf-core/differentialabundance*.

### 3. Create the Job Submission Script for Differential Expression
Create a file called ```run_diff_exp.sh```:
```bash
nano run_diff_exp.sh
```
Paste in the following script:
```bash
#!/bin/bash --login

#SBATCH --job-name=diff_exp_job
#SBATCH --time=3:59:00
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=8

cd $HOME/diff_exp_project
module load Nextflow/24.10.2

# Pull the latest nf-core/differential-abundance pipeline
nextflow pull nf-core/differential-abundance

# Run the pipeline
nextflow run nf-core/differential-abundance -r 1.5.0 -profile singularity --input samplesheet.csv --matrix $HOME/rnaseq_project/rnaseq_results/star_salmon/salmon.merged.gene_counts.tsv  $HOME/rnaseq_project/rnaseq_results/star_salmon/salmon.merged.gene_lengths.tsv --outdir ./diff_exp_results -c ./icer.config
```
Save and close the file.

### 4. Submit the Differential Expression Job
Submit the job with:
```bash
sbatch run_diff_exp.sh
```

### 5. Monitor Your Job
Check job status with:
```bash
squeue -u $USER
```
Once finished, your differential expression results will be in the diff_exp_results folder.

## Quick Reminders
- **Never type file content into the terminal.** Always create or edit files using a text editor (like **nano**).
- Follow each step carefully.
- Visit the [nf-core/rnaseq](https://nf-co.re/rnaseq) or [nf-core/differentialabundance](https://nf-co.re/differentialabundance) webpage for more detailed instructions and use cases.

---

## Conclusion
Using **nf-core/rnaseq** and **nf-core/differentialabundance** on the MSU HPCC simplifies the process of bulk RNAseq analysis, including QC, alignment, quantification, and downstream analysis. The combination of **Singularity** and **Nextflow** ensures a reproducible and efficient workflow tailored for high-performance computing environments.

---

### Getting Help

- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)
  

