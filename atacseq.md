---
layout: post
title: "Running nf-core/atacseq on MSU HPCC"
date: 2024-11-03
author: John Vusich, Leah Terrian
categories: jekyll update
---

## Overview

The **MSU HPCC**, managed by ICER, provides an efficient and scalable environment for running complex bioinformatics analyses. This tutorial will guide you through running the **nf-core/atac-seq** pipeline on the HPCC, ensuring reproducibility and optimal performance. Users can [jump directly to the differential accessibility analysis steps](#part-2-optional--differential-accessibility-analysis) if they already have a peaks matrix from nf-core/atacseq.


## Key Benefits of nf-core/atacseq

**nf-core/atac-seq** is designed for:

- **Reproducible ATAC-seq Analysis**: Provides robust, community-curated workflows.
- **Portability**: Runs seamlessly across different computing environments.
- **Scalability**: Capable of processing small- to large-scale ATAC-seq datasets.

## Prerequisites

- Access to MSU HPCC with a valid ICER account.
- Basic familiarity with the command line.

### Note on Directory Variables

On the MSU HPCC:

- `$HOME` automatically routes to the user's home directory (`/mnt/home/username`).
- `$SCRATCH` automatically routes to the user's scratch directory, which is ideal for temporary files and large data processing.

### Note on Working Directory

The working directory, which stores intermediate and temporary files, can be specified separately using the `-w` flag when running the pipeline. This helps keep your analysis outputs and temporary data organized.

## Step-by-Step Tutorial

## Part 1: Pre-processing with nf-core/atacseq

#### 1. Create a Project Directory
Make a new folder for your ATAC-seq analysis:
```bash
mkdir $HOME/atacseq
cd $HOME/atacseq
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
Now, create a shell script to run the pipeline. Create a file called run_atacseq.sh:
```bash
nano run_atacseq.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=atacseq
#SBATCH --time=24:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=atacseq-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example GRCm39
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/atacseq/samplesheet.csv" # Example path to sample sheet
OUTDIR="$HOME/atacseq/results" # Example path to results directory
WORKDIR="$SCRATCH/atacseq/work" # Example path to work directory
CONFIG="$HOME/atacseq/icer.config" # Example path to icer.config file

# Run the ATAC-seq analysis
nextflow pull nf-core/atacseq
nextflow run nf-core/atacseq -r 2.1.2 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
--read_length 150 \
-c $CONFIG
```
Make edits as needed. Modify `--read_length` to match the number of base pairs per read in your fastq files (commonly = 100 or 150).
Save and close the file.

#### 5. Submit Your Job
Submit your job to SLURM by typing:
```bash
sbatch run_atacseq.sh
```
This sends your job to the scheduler on the HPCC.

### 6. Monitor Your Job
Check the status of your job with:
```bash
squeue -u $USER
```
After completion, your output files will be in the `results` folder inside your `atacseq` directory.

## Part 2: *Optional* – Differential Accessibility Analysis

After running initial ATAC-seq analysis, you can follow these additional steps to perform differential accessibility analysis using **nf-core/differentialabundance**.
Adapted from [Pierre Lindenbaum's guide](https://gist.github.com/lindenb/593ad97a884d465a04b15a8578af69b4).

### 1. Create a New Project Directory
Create a separate folder for the differential accessibility analysis:
```bash
mkdir $HOME/differential
```

#### 2. Tidy the features file
The nf-core/atacseq pipeline produced the following output: `$HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/consensus_peaks.mRp.clN.annotatePeaks.txt`
```csv
PeakID (cmd=annotatePeaks.pl consensus_peaks.mRp.clN.bed genome.fa -gid -gtf genes.gtf -cpu 6)	Chr	Start	End	Strand	Peak Score	Focus Ratio/Region Size	Annotation (...)
Interval_332495	chr9	124851870	124853798	+	0	NA	promoter-TSS (WDR38) (...)
Interval_128586	chr17	26937319	26937399	+	0	NA	Intergenic (...)
Interval_331654	chr9	120441459	120442773	+	0	NA	intron (CDK5RAP2, intron 23 of 37) (...)
Interval_267936	chr6	5032815	5034691	+	0	NA	exon (LYRM4, exon 4 of 4) (...)
Interval_343213	chrX	130530694	130530770	+	0	NA	Intergenic (...)
Interval_214618	chr3	52490455	52491417	+	0	NA	intron (NISCH, intron 7 of 8) (...)
Interval_284446	chr6	159683511	159683887	+	0	NA	intron (SOD2, intron 3 of 4) (...)
Interval_219482	chr3	108008329	108008684	+	0	NA	Intergenic (...)
Interval_113578	chr16	1025293	1025709	+	0	NA	Intergenic (...)
```
tidy the spaces, replace "PeakId" with "gene_id", using
```bash
cd $HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/
sed 's/^PeakID[^\t]*/gene_id/'consensus_peaks.mRp.clN.annotatePeaks.txt |\
	sed -r '1 s/[^A-Za-z0-9_\t]+/_/g' |\
	sed 's/Gene_Name/gene_name/'  > differentialabundance.atacseq.GRCh38.annot.tsv
```
it now looks like:
```csv
gene_id	Chr	Start	End	Strand	Peak_Score	Focus_Ratio_Region_Size	Annotation (...)
Interval_332495	chr9	124851870	124853798	+	0	NA	promoter-TSS (WDR38) (...)
Interval_128586	chr17	26937319	26937399	+	0	NA	Intergenic (...)
Interval_331654	chr9	120441459	120442773	+	0	NA	intron (CDK5RAP2, intron 23 of 37) (...)
Interval_267936	chr6	5032815	5034691	+	0	NA	exon (LYRM4, exon 4 of 4) (...)
Interval_343213	chrX	130530694	130530770	+	0	NA	Intergenic (...)
Interval_214618	chr3	52490455	52491417	+	0	NA	intron (NISCH, intron 7 of 8) (...)
Interval_284446	chr6	159683511	159683887	+	0	NA	intron (SOD2, intron 3 of 4) (...)
Interval_219482	chr3	108008329	108008684	+	0	NA	Intergenic (...)
Interval_113578	chr16	1025293	1025709	+	0	NA	Intergenic (...)
```

#### 3. Tidy the matrix file
The atacseq pipeline produced the following output: `$HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/consensus_peaks.mRp.clN.featureCounts.txt`
```csv
# Program:featureCounts v2.0.1; Command:"featureCounts" "-F" "SAF" "-O" "--fracOverlap" "0.2" "-p" "-T" "6" "-a" "consensus_peaks.mRp.clN.saf" "-s" "0" "-o" "consensus_peaks.mRp.clN.featureCounts.txt" "QX_F_SRS7605858_REP2.mLb.clN.sorted.bam" "QX_F_SRS7605858_REP1.mLb.clN.sorted.bam" "YR_F_SRS7606898_REP1.mLb.clN.sorted.bam" "YR_F_SRS7606898_REP2.mLb.clN.sorted.bam" "QX_M_SRS7604988_REP1.mLb.clN.sorted.bam" "QX_M_SRS7604988_REP2.mLb.clN.sorted.bam" "QX_M_SRS7755799_REP1.mLb.clN.sorted.bam" "QX_M_SRS7755799_REP2.mLb.clN.sorted.bam" "QX_F_SRS7604526_REP1.mLb.clN.sorted.bam" "QX_F_SRS7604526_REP2.mLb.clN.sorted.bam" "ZP_M_SRS7604190_REP2.mLb.clN.sorted.bam" "ZP_M_SRS7604190_REP1.mLb.clN.sorted.bam" "QX_F_SRS7756262_REP1.mLb.clN.sorted.bam" "QX_F_SRS7756262_REP2.mLb.clN.sorted.bam" "YR_F_SRS7606597_REP1.mLb.clN.sorted.bam" "YR_F_SRS7606597_REP2.mLb.clN.sorted.bam" "ZP_F_SRS7606383_REP1.mLb.clN.sorted.bam" "ZP_F_SRS7606383_REP2.mLb.clN.sorted.bam" "YR_M_SRS7605759_REP2.mLb.clN.sorted.bam" "YR_M_SRS7605759_REP1.mLb.clN.sorted.bam" "LA_M_SRS7604996_REP2.mLb.clN.sorted.bam" "LA_M_SRS7604996_REP1.mLb.clN.sorted.bam"  (...)
Geneid	Chr	Start	End	Strand	Length	QX_F_SRS7605858_REP2.mLb.clN.sorted.bam	QX_F_SRS7605858_REP1.mLb.clN.sorted.bam	YR_F_SRS7606898_REP1.mLb.clN.sorted.bam (...)
Interval_1	chr1	10009	10619	+	611	486	377	671 (...)
Interval_2	chr1	13043	13515	+	473	35	30	61 (...)
Interval_3	chr1	14396	14795	+	400	44	26	46 (...)
Interval_4	chr1	15629	17902	+	2274	124	112	155 (...)
Interval_5	chr1	28730	29603	+	874	76	80	136 (...)
Interval_6	chr1	136407	136812	+	406	28	20	34 (...)
Interval_7	chr1	137922	139478	+	1557	47	38	77 (...)
Interval_8	chr1	180747	184640	+	3894	886	760	1106 (...)
```
replace GenId with gene_id, remove some columns, sanitize the sample names:
```bash
cd $HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/
tail -n +2 consensus_peaks.mRp.clN.featureCounts.txt |cut -f1,7- |\
	sed 's%.mLb.clN.sorted.bam%%g' |\
	sed 's/^Geneid/gene_id/' > differentialabundance.atacseq.GRCh38.featureCount.tsv
```
it now looks like:
```csv
gene_id	QX_F_SRS7605858_REP2	QX_F_SRS7605858_REP1	YR_F_SRS7606898_REP1	YR_F_SRS7606898_REP2	QX_M_SRS7604988_REP1	QX_M_SRS7604988_REP2	QX_M_SRS7755799_REP1
Interval_1	486	377	671	235	117	76	193
Interval_2	35	30	61	21	10	11	49
Interval_3	44	26	46	17	7	12	27
Interval_4	124	112	155	85	29	36	103
Interval_5	76	80	136	50	53	46	176
Interval_6	28	20	34	19	7	5	9
Interval_7	47	38	77	27	18	19	16
Interval_8	886	760	1106	409	183	118	368
Interval_9	108	85	142	68	25	28	57
```

#### 4. Build a samplesheet
Build a samplesheet manually (see [here](https://nf-co.re/differentialabundance/1.5.0/docs/usage/#observations-samplesheet-input) for an example) or generate one using the header of differentialabundance.atacseq.GRCh38.featureCount.tsv if the phenotype is in the sample names, for example:
```bash
cd $HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/
head -n 1 differentialabundance.atacseq.GRCh38.featureCount.tsv |\
	 cut -f2- | tr "\t" "\n" |\
   awk -F '_' 'BEGIN {printf("sample,tissue,sex,tissue_sex\n");} {printf("%s,%s,%s,%s_%s\n",$0,$1,$2,$1,$2);}' > $HOME/differential/samplesheet.csv
```
The samplesheet is now located in `$HOME/differential` and looks like:
```csv
sample,tissue,sex,tissue_sex
QX_F_SRS7605858_REP2,QX,F,QX_F
QX_F_SRS7605858_REP1,QX,F,QX_F
YR_F_SRS7606898_REP1,YR,F,YR_F
(...)
```

#### 5. Build a contrasts file
The contrasts file is build manually (see [here](https://nf-co.re/differentialabundance/1.5.0/docs/usage/#contrasts-file) for more info), for example:
```csv
id,variable,reference,target
YR_F_vs_M,tissue_sex,YR_F,YR_M
ZP_F_vs_M,tissue_sex,ZP_F,ZP_M
QX_F_vs_M,tissue_sex,QX_F,QX_M
```

#### 6. Create the Job Submission Script
Create a file called ```run_differential.sh```:
```bash
cd $HOME/differential/
nano run_differential_atac.sh
```
Paste in the following script:
```bash
#!/bin/bash --login
#SBATCH --job-name=differential
#SBATCH --time=3:00:00
#SBATCH --mem=4GB
#SBATCH --cpus-per-task=1
#SBATCH --output=differential-%j.out

# Load Nextflow
module purge
module load Nextflow

# Set the relative paths to the genome files
GENOME_DIR="/mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39" #Example reference genome
FASTA="$GENOME_DIR/genome.fa" # Example FASTA
GTF="$GENOME_DIR/genes.gtf" # Example GTF

# Define the samplesheet, outdir, workdir, and config
SAMPLESHEET="$HOME/differential/samplesheet.csv" # Replace with path to sample sheet
MATRIX="$HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/differentialabundance.atacseq.GRCh38.featureCount.tsv" # Example path to counts matrix
FEATURES="$HOME/atacseq/results/bwa/merged_replicate/macs2/narrow_peak/consensus/differentialabundance.atacseq.GRCh38.annot.tsv" # Example path to gene lengths matrix
CONTRASTS="$HOME/differential/contrasts.csv" # Example path to contrasts file
OUTDIR="$HOME/differential/results" # Example path to results directory
WORKDIR="$SCRATCH/differential/work" # Example path to work directory
CONFIG="$HOME/atacseq/icer.config" # Example path to icer.config file

# Run the pipeline
nextflow pull nf-core/differentialabundance
nextflow run nf-core/differentialabundance -r 1.5.0 -profile singularity -work-dir $WORKDIR -resume \
--input $SAMPLESHEET \
--matrix $MATRIX \
--features $FEATURES \
--features_metadata_cols "gene_id,gene_name" \
--features_id_col gene_id \
--features_name_col "gene_name" \
--sizefactors_from_controls false \
--contrasts $CONTRASTS \
--outdir $OUTDIR \
--fasta $FASTA \
--gtf $GTF \
-c $CONFIG
```
Save and close the file.

#### 7. Submit the Differential Expression Job
Submit the job with:
```bash
sbatch run_differential_atac.sh
```

#### 8. Monitor Your Job
Check job status with:
```bash
squeue -u $USER
```
Once finished, your differential expression results will be in `$HOME/differential/results/report/study.html`.

## Note on Reference Genomes

Common reference genomes can be found in the /mnt/research/common-data/Bio/ folder on the HPCC. You can find guidance on finding reference genomes on the HPCC or downloading them from Ensembl in this [GitHub repository](https://github.com/johnvusich/reference-genomes).

## Best Practices

- **Check Logs**: Regularly inspect log files generated by the pipeline for any warnings or errors.
- **Resource Allocation**: Adjust the `icer.config` to optimize resource usage based on dataset size.
- **Storage Management**: Ensure adequate storage space for intermediate and final results.

## Getting Help

If you encounter any issues or have questions while running **nf-core/atacseq** on the HPCC, consider the following resources:

- **nf-core Community**: Visit the [nf-core website](https://nf-co.re) for documentation, tutorials, and community support.
- **ICER Support**: Contact ICER consultants through the [MSU ICER support page](https://icer.msu.edu/contact) for assistance with HPCC-specific questions.
- **Slack Channel**: Join the **nf-core** Slack channel for real-time support and to engage with other users and developers.
- **Nextflow Documentation**: Refer to the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for more details on workflow customization and troubleshooting.

---

## Conclusion

Running **nf-core/atac-seq** on the MSU HPCC is streamlined with **Singularity** and **Nextflow** modules. This setup supports reproducible, efficient, and large-scale ATAC-seq analyses. By following this guide, you can take full advantage of the HPCC's computing power for your bioinformatics projects.

---
