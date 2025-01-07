Base Kraken2,Bracken,KrakenTools instructions HPCC
 

### Creating the Bracken/KrakenTools conda environment ###
# Load the conda module
module purge
module load Miniforge3
# Create the environment using a .yml file
conda env create --file /mnt/research/common-data/BioinformaticsCore/conda_environment_files/bracken_krakentools.yml
### Using the Bracken/KrakenTools conda environment ###
# Load the conda and Kraken moduels
module purge
module load Kraken2
module load Miniforge3
# Activate you conda environment
conda activate bracken_krakentools
# Get Sample data
wget -qnc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR136/008/SRR13697208/SRR13697208_1.fastq.gz
wget -qnc ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR136/008/SRR13697208/SRR13697208_2.fastq.gz
gunzip SRR13697208_*
# Setup Kraken database
wget -qnc https://genome-idx.s3.amazonaws.com/kraken/k2_standard_eupath_20201202.tar.gz
mkdir protocol_db
tar xvfz k2_standard_eupath_20201202.tar.gz -C protocol_db
# Run Kraken2
kraken2 --db protocol_db --report SRR13697208.k2report --report-minimizer-data --minimum-hit-groups 3 SRR13697208_1.fastq SRR13697208_2.fastq > SRR13697208.kraken2
# EXPECTED RESULTS:
#Loading database information... done.
#748792 sequences (92.54 Mbp) processed in 4.552s (9869.7 Kseq/m, 1219.74 Mbp/m).
#  505229 sequences classified (67.47%)
#  243563 sequences unclassified (32.53%)
# Run Brakcken
bracken -d protocol_db -i SRR13697208.k2report -o SRR13697208.bracken -w SRR13697208.breport -r 100 -l S -t 10
# EXPECTED RESULTS:
# >> Checking for Valid Options...
# >> Running Bracken
#       >> python src/est_abundance.py -i SRR13697208.k2report -o SRR13697208.bracken -k #protocol_db/database100mers.kmer_distrib -l S -t 10
#PROGRAM START TIME: 11-14-2024 19:20:37
#>> Checking report file: SRR13697208.k2report
#BRACKEN SUMMARY (Kraken report: SRR13697208.k2report)
#    >>> Threshold: 10
#    >>> Number of species in sample: 180
#          >> Number of species with reads > threshold: 46
#          >> Number of species with reads < threshold: 134
#    >>> Total reads in sample: 748792
#          >> Total reads kept at species level (reads > threshold): 335020
#          >> Total reads discarded (species reads < threshold): 334
# >> Reads distributed: 169848
# >> Reads not distributed (eg. no species above threshold): 27
# >> Unclassified reads: 243563
#BRACKEN OUTPUT PRODUCED: SRR13697208.bracken
# Use KrakenTools script to get alpha diversity
alpha_diversity.py -f SRR13697208.bracken -a BP
# EXPECTED RESULTS:
# Berger-parker's diversity: 0.9820183500776472
### DONE ###