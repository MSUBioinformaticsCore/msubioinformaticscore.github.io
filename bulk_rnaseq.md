---
layout: post
title: "Comprehensive Bulk RNA-seq Analysis Using nf-core/rnaseq and nf-core/differentialabundance on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian, Nicholas Panchy
categories: jekyll update
---

## Overview

This guide will show you, step by step, how to analyze bulk RNA-seq data using the **nf-core/rnaseq** pipeline (for QC, alignment, and quantification) and the **nf-core/differentialabundance** pipeline for differential expression analysis and GSEA. Users can [jump directly to the differential expression steps](bulk_rnaseq.md#2-differential-expression-and-gsea) if they already have a counts table.

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
mkdir $HOME/rnaseq
cd $HOME/rnaseq
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
nano run_rnaseq.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=rnaseq
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=rnaseq-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/rnaseq/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/rnaseq/results" # Example path to results directory
WORKDIR="$SCRATCH/rnaseq/work" # Example path to work directory
CONFIG="$HOME/rnaseq/icer.config" # Example path to icer.config file

# Run the RNA-seq analysis
nextflow pull nf-core/rnaseq
nextflow run nf-core/rnaseq -r 3.19.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
-c $CONFIG
```
Make edits as needed. Save and close the file.

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
After completion, your output files will be in the `results` folder inside your `rnaseq` directory.

## Part 2: *Optional* – Differential Expression Analysis

If you already have a counts table, you can follow these additional steps to perform differential expression and GSEA using **nf-core/differentialabundance**.

### 1. Create a New Project Directory
Create a separate folder for the differential expression analysis:
```bash
mkdir $HOME/differential
cd $HOME/differential
```

### 2. Prepare the Samplesheet and Input Files
Create a ```samplesheet.csv``` for differential expression analysis:
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
The `nf-core/rnaseq` workflow (described above) creates raw counts and transcript length matrix files that can be used directly in the nf-core Differential Abundance workflow. Provide the paths to those files in the submission script in step 3 (below):
```bash
--matrix $HOME/rnaseq/results/star_salmon/salmon.merged.gene_counts.tsv \
--transcript_length_matrix $HOME/rnaseq/results/star_salmon/salmon.merged.gene_lengths.tsv
```
See [this](https://nf-co.re/differentialabundance/1.5.0/docs/usage/#abundance-values) documentation for more information on RNAseq gene counts for *nf-core/differentialabundance*.

#### Contrasts file
The contrasts file defines the groups of samples to compare.
Create a ```contrasts.csv``` for differential expression analysis:
```bash
nano contrasts.csv
```
Example content:
```csv
id,variable,reference,target,blocking
condition_control_treated,condition,control,treated,
```
**Note:** The tool expects a blank field (i.e., a trailing comma) the `blocking` column if when no blocking variables (e.g., batch) are used. See the *nf-core/differentialabundance* [documentation on the contrasts file](https://nf-co.re/differentialabundance/1.5.0/docs/usage/#contrasts-file) for a more detailed explanation.

### 3. Create the Job Submission Script for Differential Expression
Create a file called ```run_differential.sh```:
```bash
nano run_differential.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=differential
#SBATCH --time=3:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=differential-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the relative paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example reference genome
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/differential/samplesheet.csv" # Replace with path to sample sheet
MATRIX="$HOME/rnaseq/results/star_salmon/salmon.merged.gene_counts.tsv" # Example path to counts matrix
LENGTHS="$HOME/rnaseq/results/star_salmon/salmon.merged.gene_lengths.tsv" # Example path to gene lengths matrix
CONTRASTS="$HOME/differential/contrasts.csv" # Example path to contrasts file
OUTDIR="$HOME/differential/results" # Example path to results directory
WORKDIR="$SCRATCH/differential/work" # Example path to work directory
CONFIG="$HOME/rnaseq/icer.config" # Example path to icer.config file

# Run the pipeline
nextflow pull nf-core/differentialabundance
nextflow run nf-core/differentialabundance -r 1.5.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--matrix $MATRIX \
--transcript_length_matrix $LENGTHS \
--contrasts $CONTRASTS \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
-c $CONFIG
```
Save and close the file.

### 4. Submit the Differential Expression Job
Submit the job with:
```bash
sbatch run_differential.sh
```

### 5. Monitor Your Job
Check job status with:
```bash
squeue -u $USER
```
Once finished, your differential expression results will be in `$HOME/differential/results`.

## Quick Reminders
- **Never type file content into the terminal.** Always create or edit files using a text editor (like **nano**).
- Follow each step carefully.
- Visit the [`nf-core/rnaseq`](https://nf-co.re/rnaseq) or [`nf-core/differentialabundance`](https://nf-co.re/differentialabundance) webpage for more detailed instructions and use cases.

---

## Conclusion
Using **nf-core/rnaseq** and **nf-core/differentialabundance** on the MSU HPCC simplifies the process of bulk RNA-seq analysis, including QC, alignment, quantification, and downstream analysis. The combination of **Singularity** and **Nextflow** ensures a reproducible and efficient workflow tailored for high-performance computing environments.

---

### Getting Help

- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)
