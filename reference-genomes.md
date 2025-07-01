# reference-genomes
Reference genomes for popular model organisms from Ensembl.

# File Format Guide
FASTA (FAST-All): a text-based file representing nucleotide or protein sequences.

GTF (Gene Transfer Format): a text-based file storing information on gene structure, annotations, and features.

GFF3 (Generic Feature Format version 3): a text-based file storing 9 columns of data including gene IDs, source, and type.

## List of Reference Genomes that can be used from MSU HPCC common-data.
The genome FASTA and GTF files listed below can be used for bioinformatics analyses.

1. Human **GRCh38**

FASTA: /mnt/research/common-data/Bio/genomes/Ensembl_GRCh38/

GTF: /mnt/research/common-data/Bio/genomes/Ensembl_GRCh38/Homo_sapiens.GRCh38.112.gtf.gz/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

2. Mouse **GRCm38**

FASTA: /mnt/research/common-data/Bio/genomes/Emsembl_GRCm38_mm10/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz

GTF: /mnt/research/common-data/Bio/genomes/Emsembl_GRCm38_mm10/Mus_musculus.GRCm38.102.gtf.gz

3. Mouse **GRCm39**

FASTA: /mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz

GTF: /mnt/research/common-data/Bio/genomes/Ensembl_GRCm39_mm39/Mus_musculus.GRCm39.112.gtf.gz

4. Zebrafish **GRCz11**

FASTA: /mnt/research/common-data/Bio/genomes/Ensembl_GRCz11/Danio_rerio.GRCz11.dna.primary_assembly.fa.gz

GTF: /mnt/research/common-data/Bio/genomes/Ensembl_GRCz11/Danio_rerio.GRCz11.112.gtf.gz

4. Rat **mRatBN7.2**

FASTA: /mnt/research/common-data/Bio/genomes/Ensembl_mRatBN7.2/Rattus_norvegicus.mRatBN7.2.dna.toplevel.fa.gz

GTF: /mnt/research/common-data/Bio/genomes/Ensembl_mRatBN7.2/Rattus_norvegicus.mRatBN7.2.112.gtf.gz

5. Arabidopsis **TAIR10**

FASTA: /mnt/research/common-data/Bio/genomes/Ensembl_TAIR10/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz

GFF3: /mnt/research/common-data/Bio/genomes/Ensembl_TAIR10/Arabidopsis_thaliana.TAIR10.59.gff3.gz


## List of Reference Genomes that can be downloaded from Ensembl
The genome FASTA and GTF files listed below can be used for bioinformatics analyses.

1. Human

FASTA: https://ftp.ensembl.org/pub/release-112/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

GTF: https://ftp.ensembl.org/pub/release-112/gtf/homo_sapiens/Homo_sapiens.GRCh38.112.gtf.gz

2. Mouse

FASTA: https://ftp.ensembl.org/pub/release-112/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.primary_assembly.fa.gz

GTF: https://ftp.ensembl.org/pub/release-112/gtf/mus_musculus/Mus_musculus.GRCm39.112.gtf.gz

3. Zebrafish

FASTA: https://ftp.ensembl.org/pub/release-112/fasta/danio_rerio/dna/Danio_rerio.GRCz11.dna.primary_assembly.fa.gz

GTF: https://ftp.ensembl.org/pub/release-112/gtf/danio_rerio/Danio_rerio.GRCz11.112.gtf.gz 

4. Arabidopsis

FASTA: https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-59/fasta/arabidopsis_thaliana/dna/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa.gz

GFF3: https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-59/gff3/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.59.gff3.gz

## Downloading the reference genome
The reference genome FASTA and GTF files can be downloaded using the wget function on the command line. For example: 
```
wget https://ftp.ensembl.org/pub/release-112/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz

wget https://ftp.ensembl.org/pub/release-112/gtf/homo_sapiens/Homo_sapiens.GRCh38.112.gtf.gz
```
