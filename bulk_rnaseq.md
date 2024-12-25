---
layout: post
post title: "Comprehensive Bulk RNA-seq Analysis Using nf-core/rnaseq and nf-core/differential-abundance on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview

The **MSU HPCC**, managed by ICER, is a powerful environment for bioinformatics workflows. This guide explains how to run the **nf-core/rnaseq** pipeline for RNA-seq pre-processing and the **nf-core/differential-abundance** pipeline for differential expression analysis and GSEA. Users can click [here](bulk_rnaseq.md#2-differential-expression-and-gsea) to skip directly to the differential abundance and GSEA steps if they already have a counts table.

## Key Benefits

- **Reproducibility**: Community-curated workflows ensure standardized analysis.
- **Portability**: Run seamlessly on various infrastructures.
- **Scalability**: Handles datasets of different sizes efficiently.

## Prerequisites

- Access to MSU HPCC with a valid ICER account.
- Basic knowledge of **Singularity** and **Nextflow**.

## Step-by-Step Guide

### Note on Directory Variables

- `$HOME`: User's home directory (`/mnt/home/username`).
- `$SCRATCH`: User's scratch directory, ideal for intermediate and large data files.

### Note on Working Directory

Intermediate files are stored in a working directory specified by the `-w` flag. Keeping intermediate data separate from the final output helps organize results and save space.

### 1. Pre-processing with nf-core/rnaseq

#### 1.1 Load Nextflow Module

```bash
module load Nextflow
```

#### 1.2 Create an Analysis Directory

```bash
mkdir $HOME/rnaseq_project
cd $HOME/rnaseq_project
```

- Modify `$HOME/rnaseq_project` as needed.

#### 1.3 Prepare Sample Sheet for Pre-processing

Create a `samplesheet.csv` for **nf-core/rnaseq** pre-processing:

```csv
sample,fastq_1,fastq_2,strandness
CONTROL_REP1,/path/to/CONTROL_REP1_R1.fastq.gz,/path/to/CONTROL_REP1_R2.fastq.gz,auto
CONTROL_REP2,/path/to/CONTROL_REP2_R1.fastq.gz,/path/to/CONTROL_REP2_R2.fastq.gz,auto
TREATMENT_REP1,/path/to/TREATMENT_REP1_R1.fastq.gz,/path/to/TREATMENT_REP1_R2.fastq.gz,auto
TREATMENT_REP2,/path/to/TREATMENT_REP2_R1.fastq.gz,/path/to/TREATMENT_REP2_R2.fastq.gz,auto
```

Ensure paths to FASTQ files are correct and `strandness` is specified appropriately.

#### 1.4 Configure ICER Environment

Create `icer.config`:

```groovy
process {
    executor = 'slurm'
}
```

#### 1.5 Run nf-core/rnaseq

##### Example SLURM Submission Script

```bash
#!/bin/bash

#SBATCH --job-name=rnaseq_job
#SBATCH --time=48:00:00
#SBATCH --mem=64GB
#SBATCH --cpus-per-task=16

cd $HOME/rnaseq_project
module load Nextflow/23.10.0

nextflow pull nf-core/rnaseq
nextflow run nf-core/rnaseq -r 3.14.0 --input ./samplesheet.csv -profile singularity --outdir ./rnaseq_results --genome GRCh38 -work-dir $SCRATCH/rnaseq_work -c ./icer.config
```

- Modify `--outdir` and `--genome` as needed.

### 2. Differential Expression and GSEA

If you already have a counts table, you can begin from here.

#### 2.1 Create a Differential Expression Project Directory

```bash
mkdir $HOME/differential_abundance_project
cd $HOME/differential_abundance_project
```

- Modify the path as needed.

#### 2.2 Prepare Input Data for Differential Abundance

Create a `samplesheet.csv` for **nf-core/differential-abundance**:

```csv
sample,condition,replicate,batch
CONTROL_REP1,control,1,A
CONTROL_REP2,control,2,B
TREATMENT_REP1,treated,1,A
TREATMENT_REP2,treated,2,B
```

Ensure the `sample` column matches the IDs in the counts table.

Additional input files:

- Use the `--matrix` parameter to specify your counts table (e.g., `--matrix salmon.merged.gene_counts.tsv`).
- For best practices, include a transcript length matrix (e.g., `--transcript_length_matrix salmon.merged.gene_lengths.tsv`).
- Prepare a contrasts file for defining groups of samples with the `--contrasts` parameter (e.g., `--contrasts contrasts.csv`).

An example contrasts file:

```csv
id,variable,reference,target,blocking
condition_control_treated,condition,control,treated,
condition_control_treated_blockrep,condition,control,treated,replicate;batch
```

- Use the `--matrix` parameter to specify your counts table (e.g., `--matrix salmon.merged.gene_counts.tsv`).
- For best practices, include a transcript length matrix (e.g., `--transcript_length_matrix salmon.merged.gene_lengths.tsv`).
- Prepare a contrasts file for defining groups of samples with the `--contrasts` parameter (e.g., `--contrasts contrasts.csv`).

#### 2.3 Run nf-core/differential-abundance

##### Example SLURM Submission Script

```bash
#!/bin/bash

#SBATCH --job-name=diff_abundance_job
#SBATCH --time=24:00:00
#SBATCH --mem=32GB
#SBATCH --cpus-per-task=8

cd $HOME/differential_abundance_project
module load Nextflow/23.10.0

nextflow pull nf-core/differential-abundance
nextflow run nf-core/differential-abundance -r 1.1.0 --input samplesheet.csv --matrix ./salmon.merged.gene_counts.tsv --transcript_length_matrix salmon.merged.gene_lengths.tsv -profile singularity --outdir ./diff_abundance_results -c ./icer.config
```

- Adjust `--input`, `--matrix`, and `--outdir` paths as needed.

## Best Practices

- **Check Logs**: Review pipeline logs for any warnings or errors.
- **Resource Optimization**: Tailor `#SBATCH` settings based on dataset size.
- **Storage Management**: Ensure adequate space for intermediate and final data.

## Getting Help

For assistance:

- **nf-core Community**: [nf-core website](https://nf-co.re)
- **ICER Support**: [MSU ICER support](https://icer.msu.edu/contact)
- **Nextflow Documentation**: [Nextflow docs](https://www.nextflow.io/docs/latest/index.html)

## Conclusion

Running **nf-core/rnaseq** and **nf-core/differential-abundance** on the MSU HPCC provides a streamlined and efficient path from raw data to differential expression and GSEA. This integrated guide helps maximize the HPCC’s capabilities for comprehensive bulk RNA-seq analysis.

