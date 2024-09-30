---
layout: post
title: "Instructions for Sharing Data With the Bioinformatics Core on the MSU HPCC"
date: 2024-09-25
categories: jekyll update
---

# Instructions for Sharing Data With Bioinformatics Core Clients on the MSU HPCC

These step-by-step instructions are designed to help Bioinformatics Core consultants familar to Linux and High-Performance Computing (HPC) share and transfer data with Bioinformatics Core clients using the Michigan State University High-Performance Computing Center (MSU HPCC).

## Step-by-Step Guide

1. **Create a personal shared directory** 
    - Within the **/mnt/research/bioinformaticsCore/shared/** directory, create a directory to be shared with your client. It may be easiest to structure this by creating a directory named with your MSU NetID, then creating another directory within it with the project name. I.e. /mnt/research/bioinformaticsCore/shared/terrianl/20240930_BhattacharyaLab_snRNAseq_shared.

2. **Set proper permissions for sharing**
    - Ensure that the client will be able to copy files in and out of the shared directory by running **chmod -777 -R /path/to/shared/folder**
        - **Replace** "/path/to/shared/folder" with the actual path.
        - **Note**: The -R flag changes permissions for the directory. Don't use -R if you want to change permissions for a single file.

3. **Inform the client of the path to the shared directory**
    - Send your client the shared directory path. I.e. /mnt/research/bioinformaticsCore/shared/terrianl/20240930_BhattacharyaLab_snRNAseq_shared.
    - You may also share these intructions with them: [sharing_data_on_hpcc_documentation](./sharing_data_on_hpcc_documentation.md)

4. **Close folder permissions**
    - Once your client notifies you that they are done copying data into or out of the shared directory, protect their data by closing the folder permissions.
    - Run **chmod -770 -R /path/to/shared/folder**
