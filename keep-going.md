---
title: Keep going
---

# Keep going

We didn't have time for everything this week. This page has the rest of the material, in order, so you can
work through it on your own. Each part has the code with comments, a cheat sheet, and a link to the full
Data Carpentry lesson, which explains every step in more detail.

| Part | What you'll do |
|---|---|
| [1. Set up](#set-up) | Get a computer with the tools installed |
| [2. Shell scripts](#shell-scripts) | Save commands in a file and run them all at once |
| [3. Get the data](#get-the-data) | Download the *E. coli* sequencing reads |
| [4. Trim the reads](#trimming) | Remove low-quality bases and adapters with Trimmomatic |
| [5. Align to a reference genome](#alignment) | Map reads to the genome with BWA and samtools |
| [6. Call variants](#variant-calling) | Find mutations with bcftools, then look at them |
| [7. Automate the pipeline](#automation) | One script that runs steps 5 and 6 for every sample |
| [8. Microbiome data in R](#microbiome) | Taxonomy and diversity with phyloseq |
| [9. More R](#more-r) | Exercises, plotting, and trees |

## 1. Set up {#set-up}

You need a Unix terminal with the bioinformatics tools installed. There are three ways to get one.

**The workshop cloud computer.** Everything is already installed, but the computers will be shut down after
the workshop. Use them while you can, and download what you want to keep (see [Moving files](day4.html#moving-files)).

**Your own computer.** Mac and Linux already have a Unix terminal. On **Windows**, install the Windows Subsystem
for Linux first: open PowerShell **as administrator**, run `wsl --install`, restart, then open *Ubuntu* from the Start menu.
In that terminal, install the tools with conda:

```bash
# 1. Install Miniforge (a small version of conda), then close and reopen the terminal
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

# 2. Make an environment with the workshop tools
conda create -n genomics -c conda-forge -c bioconda fastqc trimmomatic bwa samtools bcftools

# 3. Turn it on (do this every time you open a new terminal)
conda activate genomics
```

On a newer Mac (M1 or later), if conda says it can't find a package, put `CONDA_SUBDIR=osx-64` in front of the `conda create` command.
{: .tip}

**The NM-AIST computing cluster.** Ask NM-AIST IT whether the workshop software has been installed, and how to get an account.

## 2. Shell scripts {#shell-scripts}

A script is a text file of commands. Writing your commands in a script means you can run them again, change them,
and share them, and you have a record of exactly what you did.

### Code

```bash
cd ~/shell_data/untrimmed_fastq

# open a new file in the nano text editor
nano bad-reads-script.sh
```

Type these two lines into nano, then save with **Ctrl + O**, Enter, and exit with **Ctrl + X**:

```bash
grep -B1 -A2 -h NNNNNNNNNN *.fastq | grep -v '^--' > scripted_bad_reads.txt
echo "Script finished!"
```

```bash
# run the script
bash bad-reads-script.sh

# or make it executable, then run it directly
chmod +x bad-reads-script.sh
./bad-reads-script.sh

wc -l scripted_bad_reads.txt      # how many lines? how many reads is that?
```

### Cheat sheet

| Command | What it does |
|---|---|
| `nano file.sh` | Edit a text file in the terminal (Ctrl+O save, Ctrl+X exit) |
| `bash file.sh` | Run a script |
| `chmod +x file.sh` | Make a script executable |
| `./file.sh` | Run an executable script in this folder |
| `grep -h` | Leave file names out of grep's output |
| `grep -v '^--'` | Remove the `--` lines that `grep -A`/`-B` adds between matches |

### Go further

- Data Carpentry: [Writing Scripts and Working with Data](https://datacarpentry.github.io/shell-genomics/05-writing-scripts.html)
{: .lesson}

## 3. Get the data {#get-the-data}

The data are paired-end reads from three *E. coli* strains in Richard Lenski's long-term evolution experiment.

```bash
mkdir -p ~/dc_workshop/data/untrimmed_fastq
cd ~/dc_workshop/data/untrimmed_fastq
```

**On the workshop cloud computer**, the files are already there. Copy them:

```bash
cp ~/.backup/untrimmed_fastq/*fastq.gz .
```

**Anywhere else**, download them from the European Nucleotide Archive. These files are large (hundreds of MB each),
so use a fast connection:

```bash
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_1.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_2.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_1.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_2.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_1.fastq.gz
curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_2.fastq.gz
```

If `ftp://` downloads fail on your network, try the same addresses starting with `https://` instead.
{: .tip}

If you haven't yet, run FastQC on them: the code is on the [Day 2 page](day2.html#fastqc).

### Go further

- Data Carpentry: [Background and Metadata](https://datacarpentry.github.io/wrangling-genomics/01-background.html)
- Data Carpentry: [Assessing Read Quality](https://datacarpentry.github.io/wrangling-genomics/02-quality-control.html)
{: .lesson}

## 4. Trim the reads {#trimming}

FastQC showed that some reads have low-quality ends and leftover sequencing adapters. Trimmomatic cuts them off.

### Code

```bash
cd ~/dc_workshop/data/untrimmed_fastq

# find the file of adapter sequences that came with Trimmomatic, and copy it here
find ~ $CONDA_PREFIX -name NexteraPE-PE.fa 2>/dev/null
# then copy the path it prints, for example on the workshop computer:
cp ~/.miniconda3/pkgs/trimmomatic-0.38-0/share/trimmomatic-0.38-0/adapters/NexteraPE-PE.fa .

# trim one pair of files
#   SLIDINGWINDOW:4:20  cut once the average quality over 4 bases drops below 20
#   MINLEN:25           throw away reads shorter than 25 bases after trimming
#   ILLUMINACLIP:...    remove Nextera adapter sequences
trimmomatic PE SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz \
                SRR2589044_1.trim.fastq.gz SRR2589044_1un.trim.fastq.gz \
                SRR2589044_2.trim.fastq.gz SRR2589044_2un.trim.fastq.gz \
                SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15

ls -lh SRR2589044*        # compare file sizes before and after
```

Now do every sample with a loop. `basename` turns `SRR2589044_1.fastq.gz` into `SRR2589044`,
so the loop can build the names of the `_2` file and the output files:

```bash
for infile in *_1.fastq.gz
do
  base=$(basename ${infile} _1.fastq.gz)
  trimmomatic PE ${infile} ${base}_2.fastq.gz \
               ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
               ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
               SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
done

# move the trimmed files to their own folder
mkdir -p ../trimmed_fastq
mv *.trim* ../trimmed_fastq
ls ../trimmed_fastq
```

The `un` files hold reads whose partner was thrown away. We only use the paired files from here on.

### Cheat sheet

| Code | What it does |
|---|---|
| `trimmomatic PE in_1 in_2 out_1 out_1un out_2 out_2un steps` | Trim paired-end reads: 2 inputs, 4 outputs, then trimming steps |
| `SLIDINGWINDOW:4:20` | Cut when the average quality in a 4-base window falls below 20 |
| `MINLEN:25` | Drop reads shorter than 25 bases |
| `find ~ -name file` | Search for a file by name |
| `base=$(basename ${infile} _1.fastq.gz)` | Save the sample name in a variable |

### Go further

- Data Carpentry: [Trimming and Filtering](https://datacarpentry.github.io/wrangling-genomics/03-trimming.html)
{: .lesson}

## 5. Align to a reference genome {#alignment}

Alignment finds where each read came from in a reference genome. To make it fast, we use a small subset of the trimmed reads.

### Code

```bash
cd ~/dc_workshop

# download the reference genome (E. coli REL606, the ancestor of the experiment)
mkdir -p data/ref_genome
curl -L -o data/ref_genome/ecoli_rel606.fasta.gz ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz
gunzip data/ref_genome/ecoli_rel606.fasta.gz
head data/ref_genome/ecoli_rel606.fasta

# download a small subset of trimmed reads
curl -L -o sub.tar.gz https://ndownloader.figshare.com/files/14418248
tar xvf sub.tar.gz
mv sub/ ~/dc_workshop/data/trimmed_fastq_small

# folders for the results
mkdir -p results/sam results/bam results/bcf results/vcf

# index the reference genome (needed once)
bwa index data/ref_genome/ecoli_rel606.fasta

# align one sample's reads to the reference
bwa mem data/ref_genome/ecoli_rel606.fasta \
    data/trimmed_fastq_small/SRR2584866_1.trim.sub.fastq \
    data/trimmed_fastq_small/SRR2584866_2.trim.sub.fastq > results/sam/SRR2584866.aligned.sam

# convert the text SAM file to a compressed BAM file
samtools view -S -b results/sam/SRR2584866.aligned.sam > results/bam/SRR2584866.aligned.bam

# sort the alignments by position in the genome
samtools sort -o results/bam/SRR2584866.aligned.sorted.bam results/bam/SRR2584866.aligned.bam

# summary: how many reads mapped?
samtools flagstat results/bam/SRR2584866.aligned.sorted.bam
```

### Cheat sheet

| Command | What it does |
|---|---|
| `bwa index ref.fasta` | Prepare the reference genome for alignment (once) |
| `bwa mem ref.fasta r1.fq r2.fq > out.sam` | Align paired reads; output is a SAM file |
| `samtools view -S -b in.sam > out.bam` | Convert SAM (text) to BAM (compressed) |
| `samtools sort -o out.sorted.bam in.bam` | Sort alignments by genome position |
| `samtools flagstat file.bam` | Count mapped and unmapped reads |
| `tar xvf file.tar.gz` | Unpack an archive |

### Go further

- Data Carpentry: [Variant Calling Workflow](https://datacarpentry.github.io/wrangling-genomics/04-variant_calling.html), first half
- The [variant calling workflow slides](variant.pdf) from Tuesday
{: .lesson}

## 6. Call variants {#variant-calling}

A variant is a position where the reads disagree with the reference: a mutation that evolved in the experiment.

### Code

```bash
cd ~/dc_workshop

# count the read bases at each position of the genome
bcftools mpileup -O b -o results/bcf/SRR2584866_raw.bcf \
    -f data/ref_genome/ecoli_rel606.fasta results/bam/SRR2584866.aligned.sorted.bam

# find variants (E. coli has one copy of its genome: ploidy 1)
bcftools call --ploidy 1 -m -v -o results/vcf/SRR2584866_variants.vcf results/bcf/SRR2584866_raw.bcf

# filter out low-quality variants
vcfutils.pl varFilter results/vcf/SRR2584866_variants.vcf > results/vcf/SRR2584866_final_variants.vcf

# look at the variants (q to quit); lines starting with # are the header
less -S results/vcf/SRR2584866_final_variants.vcf

# how many variants?
grep -v "#" results/vcf/SRR2584866_final_variants.vcf | wc -l

# look at the alignment around a variant in the terminal
samtools index results/bam/SRR2584866.aligned.sorted.bam
samtools tview results/bam/SRR2584866.aligned.sorted.bam data/ref_genome/ecoli_rel606.fasta
# in tview: g then type a position like CP000819.1:50 to jump there; ? for help; q to quit
```

To see the alignments in a graphical viewer, download the `.bam`, `.bam.bai`, `.fasta` and `.vcf` files
with `scp` and open them in the free [IGV](https://igv.org/doc/desktop/) program on your laptop.

### Cheat sheet

| Command | What it does |
|---|---|
| `bcftools mpileup -O b -o raw.bcf -f ref.fasta file.bam` | Summarise read bases at every position |
| `bcftools call --ploidy 1 -m -v -o out.vcf raw.bcf` | Call variants (`-v` keeps only variant sites) |
| `vcfutils.pl varFilter in.vcf > out.vcf` | Filter variants |
| <code>grep -v "#" file.vcf &#124; wc -l</code> | Count variants (skip header lines) |
| `samtools index file.bam` | Index a sorted BAM (needed for viewing) |
| `samtools tview file.bam ref.fasta` | View alignments in the terminal |

### Go further

- Data Carpentry: [Variant Calling Workflow](https://datacarpentry.github.io/wrangling-genomics/04-variant_calling.html), second half
{: .lesson}

## 7. Automate the pipeline {#automation}

Steps 5 and 6 for one sample took about ten commands. A script with a loop runs them for every sample.
Save this as `~/dc_workshop/scripts/run_variant_calling.sh` (use `mkdir -p ~/dc_workshop/scripts` and `nano`):

```bash
set -e      # stop at the first error
cd ~/dc_workshop/results

genome=~/dc_workshop/data/ref_genome/ecoli_rel606.fasta

bwa index $genome

mkdir -p sam bam bcf vcf

for fq1 in ~/dc_workshop/data/trimmed_fastq_small/*_1.trim.sub.fastq
    do
    echo "working with file $fq1"

    base=$(basename $fq1 _1.trim.sub.fastq)
    echo "base name is $base"

    fq1=~/dc_workshop/data/trimmed_fastq_small/${base}_1.trim.sub.fastq
    fq2=~/dc_workshop/data/trimmed_fastq_small/${base}_2.trim.sub.fastq
    sam=~/dc_workshop/results/sam/${base}.aligned.sam
    bam=~/dc_workshop/results/bam/${base}.aligned.bam
    sorted_bam=~/dc_workshop/results/bam/${base}.aligned.sorted.bam
    raw_bcf=~/dc_workshop/results/bcf/${base}_raw.bcf
    variants=~/dc_workshop/results/vcf/${base}_variants.vcf
    final_variants=~/dc_workshop/results/vcf/${base}_final_variants.vcf

    bwa mem $genome $fq1 $fq2 > $sam
    samtools view -S -b $sam > $bam
    samtools sort -o $sorted_bam $bam
    samtools index $sorted_bam
    bcftools mpileup -O b -o $raw_bcf -f $genome $sorted_bam
    bcftools call --ploidy 1 -m -v -o $variants $raw_bcf
    vcfutils.pl varFilter $variants > $final_variants

    done
```

```bash
bash ~/dc_workshop/scripts/run_variant_calling.sh

# how many variants in each strain?
for f in ~/dc_workshop/results/vcf/*_final_variants.vcf
do
    echo $f
    grep -v "#" $f | wc -l
done
```

One strain has far more variants than the others. Why? (The [background lesson](https://datacarpentry.github.io/wrangling-genomics/01-background.html) explains.)

### Go further

- Data Carpentry: [Automating a Variant Calling Workflow](https://datacarpentry.github.io/wrangling-genomics/05-automation.html)
{: .lesson}

## 8. Microbiome data in R {#microbiome}

This part uses the **workshop cloud computer**, which has a taxonomy table (from the program Kraken) for three microbial
metagenome samples from Cuatro Ciénegas, Mexico, in `~/dc_workshop/taxonomy`. In the RStudio **Console**:

```r
library(phyloseq)
library(ggplot2)

setwd("~/dc_workshop/taxonomy/")
merged_metagenomes <- import_biom("cuatroc.biom")

# tidy the taxonomy labels: remove prefixes like "k__" and name the columns
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data) <- c("Kingdom", "Phylum", "Class", "Order",
                                                  "Family", "Genus", "Species")

# which phyla are present?
unique(merged_metagenomes@tax_table@.Data[, "Phylum"])

# keep only bacteria, and count reads per sample
merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")
sample_sums(merged_metagenomes)

# alpha diversity: how many taxa, and how evenly spread, in each sample?
plot_richness(physeq = merged_metagenomes,
              measures = c("Observed", "Chao1", "Shannon"))
```

### Go further

- The Carpentries [Metagenomics Analysis lesson](https://carpentries-lab.github.io/metagenomics-analysis/): taxonomic assignment, phyloseq, diversity and abundance plots
{: .lesson}

## 9. More R {#more-r}

- Repeat the [Day 4 R lesson](day4.html#intro-to-r) with a different column: is there a difference in *Bacteroidetes* between gut and stool?
- Work through [R exercises 1 to 4](resources.html#r-exercises). Exercise 4 builds and plots phylogenetic trees with the `ape` package, using the *Anolis* lizard data on the Resources page.
- Data Carpentry: [Intro to R and RStudio for Genomics](https://datacarpentry.github.io/genomics-r-intro/), which goes on to `dplyr` and `ggplot2` using the variant data from part 6.
- Install [R](https://cran.r-project.org/) and [RStudio Desktop](https://posit.co/download/rstudio-desktop/) on your own computer (both free), or use [Posit Cloud](https://posit.cloud/) in your browser.
