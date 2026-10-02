---
layout: post
title: "HPCC Data Handling Guide: Uploading, Storing, and Sharing Sequencing Data"
date: 2024-08-03
author: John Vusich, Leah Terrian, Dev Arnab
categories: jekyll update
---

## Getting Data on the HPCC

Welcome to the HPCC data handling guide. This documentation is designed to help new users understand how to upload, store, download, and share sequencing data within the High-Performance Computing Cluster (HPCC) environment.

There are two common ways to get sequencing data onto the HPCC:

1. **Upload data you already have** on a computer or external drive.
2. **Download existing data** from a public repository such as NCBI, GEO, or SRA.

---

### 1. New Sequencing Data

- If your sequencing data is stored on a local computer or external drive, you will need to transfer it to the HPCC before processing it.
- The most appropriate transfer method depends on the size and location of your data.

#### FTP / SFTP (File Transfer Protocol)
- FTP (File Transfer Protocol) is a method for transferring files between computers. You may also encounter **SFTP (SSH File Transfer Protocol)**, which provides a secure, encrypted way to transfer files.
- For HPCC users, SFTP or other secure transfer methods should be used rather than standard FTP.
- You can transfer files using tools such as the command line, MobaXterm, or other SFTP clients.
For detailed instructions, see the [MSU HPCC File Transfer documentation](https://docs.icer.msu.edu/File_transfer/).

#### Open OnDemand
- Open OnDemand provides a web-based interface for managing files on the HPCC. It is a convenient option for smaller file transfers because you can upload files through your web browser without using command-line tools.
- Log in to Open OnDemand, navigate to **Files**, select the appropriate storage location, and use the upload option to transfer your files.
- See the [MSU HPCC File Transfer documentation](https://docs.icer.msu.edu/File_transfer/) for more information.

#### Hard Drive
- If data is stored on a physical hard drive, connect it to a workstation that has access to the HPCC.
- For large datasets, you may need to use a command-line transfer method such as **SCP (Secure Copy)** or **rsync**. These tools securely copy files between your computer and the HPCC.
- After transferring important data, verify that the files were copied successfully. Checksums can be used to confirm that the transferred files are identical to the originals.

#### Globus
- For very large datasets, **Globus** is often more appropriate than uploading files through a web browser.
- Globus is a file-transfer service designed to efficiently move large amounts of data between computers and storage systems.
- To use Globus, select the location containing your data as the **source** and the HPCC as the **destination**, select the files you want to transfer, and start the transfer.
See the [MSU HPCC Globus documentation](https://docs.icer.msu.edu/Large_file_transfer_%28Globus%29/) for detailed instructions.

---

### 2. Existing Sequencing Data

If the data you need is already publicly available, it is generally more efficient to download it directly to the HPCC rather than downloading it to your computer first.

#### nf-core/fetchngs
- The **nf-core/fetchngs** workflow can be used to retrieve sequencing data from public repositories directly to the HPCC.
- You provide the relevant **accession numbers**, which are unique identifiers assigned to datasets in repositories such as SRA, and `fetchngs` retrieves the associated sequencing data.

#### NCBI, GEO, and SRA
- **NCBI (National Center for Biotechnology Information)** hosts several biological databases, including:
- **SRA (Sequence Read Archive)** — stores raw sequencing data.
- **GEO (Gene Expression Omnibus)** — stores functional genomics data, such as gene expression datasets.

The **SRA Toolkit** can be used to download sequencing data from SRA. Tools such as `fastq-dump` can convert SRA data into **FASTQ** files, a common format for storing sequencing reads.

---

## Sharing Data with the Public and/or Collaborators

After completing your analysis, you may need to share your data with collaborators or submit it to a public repository.

Before sharing data, check that you have permission to share it and that it does not contain sensitive information that should not be made public.

### 1. Uploading to NCBI and Submitting Data to GEO

#### Preparing Data for Submission
Before submission, make sure your data is organized and that the associated **metadata** is complete.
Metadata describes the data and may include:

- Sample information
- Experimental conditions
- Sequencing information
- Experimental design
- Data processing information

Make sure sample names and identifiers are consistent between your sequencing files and metadata.

#### NCBI Submission
- Create an account on NCBI and use the appropriate submission system for your data.
- For raw sequencing data, this generally involves submitting the sequencing files along with the required sample and experiment metadata.
- Always check the current NCBI submission requirements before submitting your data.

#### GEO Submission
- GEO accepts functional genomics data, including processed data such as gene expression matrices.
- Depending on the study, raw sequencing data may also need to be deposited in SRA or another appropriate NCBI repository.
- Include sufficient metadata and a description of the study so that other researchers can understand and reuse the data.

---

## Additional Notes

- Always back up important data before transferring or modifying it.
- Check that you have sufficient storage space before uploading large datasets.
- Keep track of where your data is stored and which datasets have been processed or shared.
- Use Globus or another appropriate transfer method for large datasets.
- Check data-use agreements and institutional policies before sharing research data.
- See the [MSU HPCC File Transfer documentation](https://docs.icer.msu.edu/File_transfer/) for detailed instructions on transferring files to and from the HPCC.
- Submit a ticket to ICER for questions related to data handling, storage, or security.

By following these guidelines, you can efficiently manage sequencing data within the HPCC and share it appropriately with collaborators or the research community.
