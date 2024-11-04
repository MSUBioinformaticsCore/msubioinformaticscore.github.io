---
layout: post
title: "Using nf-core/fetchngs for Data Transfer on MSU HPCC"
date: 2024-11-03
author: "John Vusich"
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

### 3. Configure ICER Environment
Create an `icer.config` file for using SLURM with **Nextflow**:
```groovy
process {
    executor = 'slurm'
}
```

### 4. Run nf-core/fetchngs
Download sequencing files and metadata:
```bash
nextflow run nf-core/fetchngs -profile singularity --input accession_list.csv -c icer.config
```

### Example Accession List File
Create an `accession_list.csv` file with the following format:
```plaintext
SRR1234567
SRR1234568
SRR1234569
```
Each line should contain a unique accession ID for the data you wish to download.
- Replace `accession_list.csv` with a file containing the list of accession IDs you wish to retrieve.
- The `-profile singularity` flag ensures **Singularity** containers are used with ICER-specific configurations.

### 5. Review and Manage Downloads
Ensure that the transferred files are stored and organized correctly:
- Check your output directories for completeness.
- Use `sacct` or `squeue` to monitor job progress and confirm job completion.

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

