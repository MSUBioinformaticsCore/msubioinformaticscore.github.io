---
layout: post
title: "HPCC Data Handling Guide: Uploading, Storing, and Sharing Sequencing Data"
date: 2024-08-03
categories: jekyll update
---

Welcome to the HPCC data handling guide. This documentation is designed to help new users understand the procedures for uploading, storing, and sharing data within the High-Performance Computing Cluster (HPCC) environment. It covers how to bring new sequencing data into the HPCC, access existing data, and share data with collaborators or the public through NCBI and GEO.

## Getting Data on the HPCC

### 1. New Sequencing Data

To upload new sequencing data to the HPCC, follow these methods:

#### FTP (File Transfer Protocol)
- Use an FTP client to connect to the HPCC server. Credentials and server details should be provided by your system administrator.
- Navigate to your designated directory on the server and upload your sequencing data.

#### Hard Drive
- If data is on a physical hard drive, connect it to a workstation that has access to the HPCC.
- Use secure copy (SCP) or rsync commands to transfer data from the hard drive to the HPCC storage. Ensure data integrity by verifying file checksums post-transfer.

#### Globus
- For large datasets, use Globus, a reliable file transfer service.
- Ensure you have access to a Globus endpoint on the HPCC. Transfer data by selecting source and destination endpoints, then initiating the transfer through the Globus web interface.

### 2. Existing Sequencing Data

#### nf-core/fetchngs
- The nf-core/fetchngs tool can be used to fetch sequencing data from repositories directly to the HPCC.
- Configure the tool with your project details and data accession numbers to automate the download process.

#### NCBI, GEO, SRA
- For data stored in NCBI, GEO, or SRA, use the SRA-toolkit to download the required datasets.
- Commands such as fastq-dump can be used to retrieve data in FASTQ format, which is standard for sequencing data.

## Sharing Data with the Public and/or Collaborators

### 1. Uploading to NCBI and Submitting Data to GEO

#### Preparing Data for Submission
- Ensure that your data is properly annotated and organized. Metadata should include details about the experimental setup, sample information, and sequencing parameters.
- Data should be cleaned and validated to meet the submission requirements of NCBI and GEO.

#### NCBI Submission
- Create an account on NCBI and access the submission portal.
- Follow the guidelines for submitting raw data (FASTQ files) and associated metadata. Be sure to complete all required fields to ensure your submission is comprehensive.

#### GEO Submission
- To submit data to GEO, use the GEO submission portal. GEO accepts processed data (like gene expression matrices) and raw data (like FASTQ files).
- Include comprehensive metadata and a detailed description of the study to facilitate data reuse.

## Additional Notes
- Always backup your data before transferring or submitting to avoid data loss.
- Regularly update your local and HPCC data inventories to keep track of what has been uploaded, processed, or shared.
- Submit a ticket to ICER for questions related to data handling and security.

By following these guidelines, you can efficiently manage your sequencing data within the HPCC environment and ensure it is accessible for your research and collaborations.
