---
layout: post
title: "Running nf-core/methylseq on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview
This guide shows you how to run the **nf-core/methylseq** pipeline for methylation (bisulfite-sequencing) analysis, ensuring efficiency and reproducibility.

## Key Benefits of nf-core/methylseq

- **Reproducible Methylation Analysis**: Comprehensive and standardized workflows.
- **Portability**: Runs seamlessly across computing environments.
- **Scalability**: Processes both small and large datasets effectively.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic understanding of **Singularity** and **Nextflow**.

### Note on Directory Variables
On the MSU HPCC:
- `$HOME` refers to the user’s home directory (`/mnt/home/username`).
- `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory
The working directory, which stores intermediate and temporary files, can be specified using the `-w` flag when running the pipeline. This helps keep outputs and temporary data organized.

## Step-by-Step Tutorial

#### 1. Create a Project Directory
Make a new folder for your RNA-seq analysis:
```bash
mkdir $HOME/methylseq
cd $HOME/methylseq
```
This command creates the directory and moves you into it.

#### 2. Prepare a Sample Sheet
You need to create a file called ```samplesheet.csv``` that lists your samples and their FASTQ file paths. Use a text editor (like nano) to create this file:
```bash
nano samplesheet.csv
```
Then, add your sample information in CSV format. For example:
```csv
sample,fastq_1,fastq_2,replicate
sample1,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz,1
sample2,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz,1
```
Save the file (in nano, press Ctrl+O then Ctrl+X to exit).

#### 3. Create a Configuration File
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
Now, create a shell script to run the pipeline. Create a file called run_methylseq.sh:
```bash
nano run_methylseq.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=methylseq
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=methylseq-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/methylseq/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/methylseq/results" # Example path to results directory
WORKDIR="$SCRATCH/methylseq/work" # Example path to work directory
CONFIG="$HOME/methylseq/icer.config" # Example path to icer.config file

# Run the pipeline
nextflow pull nf-core/methylseq
nextflow run nf-core/methylseq -r 3.0.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
--bismark_index $HOME/methylseq/bismark_index
-c $CONFIG
./Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz -work-dir $SCRATCH/methylseq_work -c ./nextflow.config
```
Make edits as needed. Save and close the file.

#### 5. Submit Your Job
Submit your job to SLURM by typing:
```bash
sbatch run_methylseq.sh
```
This sends your job to the scheduler on the HPCC.

### 6. Monitor Your Job
Check the status of your job with:
```bash
squeue -u $USER
```
After completion, your output files will be in the `results` folder inside your `methylseq` directory.

### Note on Reference Genomes
Common reference genomes are located in the research common-data space on the HPCC. Refer to the README file for details. For guidance on downloading reference genomes from Ensembl, see this [GitHub repository](https://github.com/johnvusich/reference-genomes).

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

---

## Conclusion
Running **nf-core/methylseq** on the MSU HPCC is simplified using **Singularity** and **Nextflow**. This guide ensures reproducible and efficient methylation analysis, leveraging the HPCC’s computational capabilities for bioinformatics research.

---
