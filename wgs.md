---
layout: post
title: "Running nf-core/sarek on MSU HPCC"
date: 2024-11-04
author: John Vusich, Leah Terrian, Nicholas Panchy
categories: jekyll update
---

## Overview
This guide details how to run the **nf-core/sarek** pipeline for whole genome sequencing (WGS) analysis, ensuring efficient and reproducible workflows.

## Key Benefits of nf-core/sarek

- **Reproducible WGS Analysis**: Supports germline and somatic variant calling.
- **Portability**: Runs seamlessly across various computing infrastructures.
- **Scalability**: Handles both small-scale and large-scale WGS datasets.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic familiarity with the command line.

### Note on Directory Variables
On the MSU HPCC:
- `$HOME` refers to the user’s home directory (`/mnt/home/username`).
- `$SCRATCH` refers to the user’s scratch directory, ideal for temporary files and large data processing.

### Note on Working Directory
The working directory, where intermediate and temporary files are stored, can be specified using the `-w` flag when running the pipeline. This keeps outputs and temporary data organized.

## Step-by-Step Tutorial

### 1. Create a Project Directory
Make a new folder for your WGS analysis:
```bash
mkdir $HOME/sarek
cd $HOME/sarek
```
This command creates the directory and moves you into it.

### 2. Prepare Sample Sheet
You need to create a file called ```samplesheet.csv``` that lists your samples and their FASTQ file paths. Create and edit the file in [OnDemand](https://ondemand.hpcc.msu.edu/) or use a text editor (like nano) to create this file:
```bash
nano samplesheet.csv
```
Then, add your sample information in CSV format. For example:
```csv
subject,sex,tumor,fastq_1,fastq_2
sample1,male,yes,/path/to/sample1_R1.fastq.gz,/path/to/sample1_R2.fastq.gz
sample2,female,no,/path/to/sample2_R1.fastq.gz,/path/to/sample2_R2.fastq.gz
```
Save the file (in nano, press Ctrl+O then Ctrl+X to exit).

### 3. Create a Configuration File
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

### 4. Prepare the Job Submission Script
Now, create a shell script to run the pipeline. Create a file called run_sarek.sh:
```bash
nano run_sarek.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=sarek
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=sarek-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/sarek/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/sarek/results" # Example path to results directory
WORKDIR="$SCRATCH/sarek/work" # Example path to work directory
CONFIG="$HOME/sarek/icer.config" # Example path to icer.config file

# Run the WGS analysis
nextflow pull nf-core/sarek
nextflow run nf-core/sarek -r 3.5.1 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
--tools cnvkit,strelka \
-c $CONFIG
```
Make edits as needed. Save and close the file.

### 5. Submit Your Job
Submit your job to SLURM by typing:
```bash
sbatch run_sarek.sh
```
This sends your job to the scheduler on the HPCC.

### 6. Monitor Your Job
Check the status of your job with:
```bash
squeue -u $USER
```
After completion, your output files will be in the `results` folder inside your `sarek` directory.

### Note on Sarek Starting Step and Tools
The `nf-core/sarek` pipeline gives the option to use different variant calling tools and start at different steps in the analysis. By default, nf-core/sarek starts at the pre-processing/mapping step and uses `Strelka` for variant calling. Read [here](https://nf-co.re/sarek/latest/docs/usage#how-can-the-different-steps-be-used) and [here](https://nf-co.re/sarek/3.5.1/docs/usage/#start-with-mapping---step-mapping-default) for more information on starting at different steps in the analysis. [Here is a note on the compatibility of the available Sarek tools](https://nf-co.re/sarek/latest/docs/usage#which-variant-calling-tool-is-implemented-for-which-data-type) that can be designated using the `--tools` parameter. For more information and to see the available tools and input format, go to [nf-core/sarek parameters](https://nf-co.re/sarek/3.5.1/parameters/#main-options) and click the `Help text` option under `--tools`. To see the available starting steps and input format, go to [nf-core/sarek parameters](https://nf-co.re/sarek/3.5.1/parameters/#input-output-options) and click the drop down starting with `mapping (default)` next to the `--step` parameter. Check out the `nf-core/sarek` [troubleshooting documentation](https://nf-co.re/sarek/3.5.1/docs/usage/#troubleshooting--faq).

### Note on Reference Genomes
Common reference genomes are located in the research common-data space on the HPCC. Refer to the README file for details. For more guidance on downloading reference genomes from Ensembl, see this [GitHub repository](https://github.com/johnvusich/reference-genomes).

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

---

## Conclusion
Running **nf-core/sarek** on the MSU HPCC is streamlined using **Singularity** and **Nextflow**. This guide ensures reproducible and scalable WGS analysis, maximizing the HPCC’s computational resources for bioinformatics research.

---
