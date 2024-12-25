---
layout: post 
title: "Using nf-core pipelines on the MSU HPCC" 
date: 2024-11-03 
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview

The MSU HPCC (High-Performance Computing Cluster), managed by ICER (Institute for Cyber-Enabled Research), provides a robust environment for running bioinformatics workflows efficiently. This guide will cover the optimal way to use **nf-core** pipelines on the HPCC, ensuring a streamlined, reproducible, and user-friendly experience.

## Why nf-core?

**nf-core** is a collection of high-quality bioinformatics pipelines built using **Nextflow**. These pipelines are designed to be:

- **Reproducible**: Ensuring that results can be consistently replicated.
- **Portable**: Running seamlessly across various computing environments.
- **Scalable**: Capable of handling datasets of different sizes, from small-scale experiments to large genomic projects.

## Leveraging Singularity and Nextflow Modules

At MSU’s HPCC, **Singularity** and **Nextflow** are preloaded and accessible across all development and compute nodes. This built-in infrastructure is key for optimal use of **nf-core** pipelines without the added complexity of alternative package management systems like **conda**.

### Benefits of Using Singularity

- **Complete Environment Encapsulation**: With **Singularity**, all dependencies, including system-level libraries, are contained within the pipeline’s image, ensuring that each run uses an identical environment.
- **Reproducibility**: Running pipelines in **Singularity** containers guarantees consistent results, avoiding the version drift and dependency conflicts sometimes seen with package managers.
- **Ease of Use**: Users don’t need to manage or activate separate environments; the containers handle everything.

### Nextflow Module Management

**Nextflow** can be managed directly using the `module load nextflow` command on the HPCC. This approach ensures:

- **Version Control**: The module system allows users to specify and maintain the **Nextflow** version they need, contributing to reproducibility.
- **Simplified Workflow Execution**: There’s no need to install or configure **Nextflow** manually, reducing setup time and potential errors.

## Running an nf-core Pipeline on the MSU HPCC

Here’s a step-by-step guide to running an **nf-core** pipeline using **Singularity** and **Nextflow**:

1. **Load the Nextflow Module**:

   ```bash
   module load Nextflow
   ```

   This command ensures **Nextflow** is available in your current environment.

2. **Set Up Your  Directory**: Navigate to or create a directory where you want to run the pipeline:

   ```bash
   mkdir ~/my_pipeline_run
   cd ~/my_pipeline_run
   ```

3. **Download the Pipeline**:
   Pull the desired **nf-core** pipeline:

   ```bash
   nextflow pull nf-core/rnaseq
   ```

4. **Run the Pipeline with Singularity**:

   ```bash
   nextflow run nf-core/rnaseq -profile singularity -w $SCRATCH/my_pipeline_run
   ```

   - The `-profile singularity` ensures the pipeline runs using **Singularity** with configurations optimized for the HPCC environment.
   - The `-resume` flag allows for continuation from the last checkpoint if a run is interrupted.

### Example Command for a Specific Pipeline

To run the nf-core/rnaseq pipeline with a custom SLURM configuration, first create an icer.config file in your working directory:

```
process {
    executor = 'slurm'
}
```

This configuration file ensures that Nextflow submits jobs to the SLURM scheduler on the HPCC.

Then, execute the following command:

```bash
nextflow run nf-core/rnaseq -profile singularity --input samplesheet.csv --genome GRCh38
```

## Best Practices for Running Pipelines

- **Use Job Scripts**: Submit jobs to the SLURM scheduler using job scripts to manage resources efficiently.
- **Monitor Resource Usage**: Use `sacct` or `squeue` to track job status and resource consumption.
- **Adjust Configurations as Needed**: Ensure the `icer.config` file is used for custom resource requests specific to HPCC nodes.

## Conclusion

The MSU HPCC, managed by ICER, is well-equipped for running **nf-core** pipelines using **Singularity** and the **Nextflow** module system. This setup simplifies pipeline execution, maximizes reproducibility, and avoids unnecessary complications from external dependency managers like **conda**.

With **Singularity** and **Nextflow** seamlessly integrated, researchers can focus on their analyses, confident in the consistency and reliability of their computational environment.

---

### Getting Help

- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)

- **nf-core/cutandrun Documentation**:
  - Visit the [nf-core/cutandrun GitHub page](https://github.com/nf-core/cutandrun) for more information.
