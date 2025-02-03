---
layout: post
title: "Using nf-core/fetchngs for Data Transfer on MSU HPCC"
date: 2024-11-03
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview
The **MSU HPCC**, managed by ICER, is equipped with tools to facilitate seamless data transfer for bioinformatics projects. The **nf-core/fetchngs** pipeline is particularly useful for retrieving raw sequencing files and metadata from public databases directly to the HPCC. This guide provides a step-by-step approach to using **nf-core/fetchngs** effectively.

## Key Benefits of nf-core/fetchngs
**nf-core/fetchngs** is designed to:

- **Automate Data Retrieval**: Simplifies downloading raw sequencing data and metadata.
- **Enhance Reproducibility**: Ensures consistency in data acquisition.
- **Seamless Integration**: Works well with existing **nf-core** pipelines for downstream analysis.

## Prerequisites
- Access to MSU HPCC with a valid ICER account.
- Familiarity with using **Singularity** and **Nextflow** modules.

## Step-by-Step Tutorial
### 1. Load Nextflow Module
Ensure **Nextflow** is available in your environment:
```bash
module load Nextflow
```

### 2. Create a Directory
Set up a dedicated directory for your data transfer tasks:
```bash
mkdir ~/fetchngs_project
cd ~/fetchngs_project
```

### 3. Prepare Sample Sheet
Create a list of SRA, GEO, ENA, or DDBJ database IDs (`ids.csv`) with the following format:
```csv
SRR1234567
SRR1234568
SRR1234569
```

### 4. Configure ICER Environment
Create an `icer.config` file for using SLURM with **Nextflow**:
```groovy
process {
    executor = 'slurm'
}
```

### 5. Run nf-core/fetchngs

### Example SLURM Job Submission Script
Below is a shell script for submitting an **nf-core/fetchngs** job to SLURM:

```bash
#!/bin/bash --login

#SBATCH --job-name=fetchngs_job
#SBATCH --time=72:00:00
#SBATCH --mem=64GB
#SBATCH --cpus-per-task=16

cd $HOME/fetchngs_project
module load Nextflow/24.04.2
nextflow run nf-core/fetchngs -r 1.12.0 -profile singularity --input ids.csv -c icer.config
```


Each line should contain a unique accession ID for the data you wish to download.
- Replace `ids.csv` with a file containing the list of database IDs you wish to retrieve.
- The `-profile singularity` flag ensures **Singularity** containers are used with ICER-specific configurations.

### 5. Review and Manage Downloads
Ensure that the transferred files are stored and organized correctly:
- Check your output directories for completeness.
- Use `squeue -u $USER` to monitor job progress and confirm job completion.

## Best Practices
- **Organize Accession Lists**: Maintain a clear and well-documented list of accession IDs.
- **Use SLURM Job Scripts**: For large downloads, submit jobs using SLURM scripts to manage resource allocation.
- **Monitor Disk Space**: Ensure sufficient storage on the HPCC for downloaded data.

---

## Conclusion
Using **nf-core/fetchngs** on the MSU HPCC simplifies the process of transferring raw sequencing data and metadata, streamlining data acquisition for bioinformatics projects. The combination of **Singularity** and **Nextflow** ensures a reproducible and efficient workflow tailored for high-performance computing environments.

---

### Getting Help

- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)

- **nf-core/fetchngs Documentation**:
  - Visit the [nf-core/fetchngs GitHub page](https://github.com/nf-core/fetchngs)) for more information.

