---
layout: post
title: "Using nf-core/fetchngs for Data Transfer on MSU HPCC"
date: 2024-11-03
author: John Vusich, Leah Terrian, Nicholas Panchy
categories: jekyll update
---

## Overview
This guide will show you, step by step, how to download sequencing data from a database to the HPCC with **nf-core/fetchngs**.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Basic familiarity with the command line.

### 1. Create a Project Directory
Open your terminal and type the following command:
```bash
mkdir ~/fetchngs_project
cd ~/fetchngs_project
```
This creates the folder and moves you into it.

### 2. Create Your Data ID List
**Important:** Do not type the file contents directly into the terminal. Instead, create or edit a file using a text editor.

You need a list of database IDs (like SRA IDs). Create a file named ids.csv using a command line text editor (for example, nano). In your terminal, type:
```bash
nano ids.csv
```
Then, type each ID on a new line. For example:
```csv
SRR1234567
SRR1234568
SRR1234569
```
Save the file and exit your editor (in nano, press Ctrl+O to save and Ctrl+X to exit).

### 3. Create the Configuration File
**Important:** Do not type the file contents directly into the terminal. Instead, create or edit a file using a text editor.
Create a file called `icer.config` by typing:
```bash
nano icer.config
```
Copy and paste the following text into the file:
```groovy
process {
    executor = 'slurm'
}
```
Save the file and exit (again, use Ctrl+O then Ctrl+X in nano).

### 4. Prepare and Submit the Job
Now, create a job submission script to run the pipeline. Create a file named ```run_fetchngs.sh```:
```bash
nano run_fetchngs.sh
```
Copy and paste the following script into the file:
```bash
#!/bin/bash --login

#SBATCH --job-name=fetchngs_job
#SBATCH --time=3:59:00
#SBATCH --mem=16GB
#SBATCH --cpus-per-task=8

cd $HOME/fetchngs_project
module load Nextflow/24.04.2
nextflow run nf-core/fetchngs -r 1.12.0 -profile singularity --input ids.csv -c icer.config
```
Save and close the file.

To submit your job, type:
```bash
sbatch run_fetchngs.sh
```
This command sends your job to the SLURM scheduler on the HPCC.

### 5. Monitor Your Job and Check Your Downloads
You can see the status of your job by typing:
```bash
squeue -u $USER
```
Once the job is finished, your downloaded files will be in your ~/fetchngs_project directory.

## Quick Reminders
- **Never type file content into the terminal.** Always create or edit files using a text editor (like **nano**).
- Follow each step carefully.
- Visit the [nf-core/fetchngs webpage](https://nf-co.re/fetchngs) for more detailed instructions and use cases.
---

## Conclusion
Using **nf-core/fetchngs** on the MSU HPCC simplifies the process of transferring raw sequencing data and metadata, streamlining data acquisition for bioinformatics projects. The combination of **Singularity** and **Nextflow** ensures a reproducible and efficient workflow tailored for high-performance computing environments.

---

### Getting Help

- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)
  

