---
title: Installing the workshop software on a cluster
---

# Installing the workshop software on a cluster

This page explains how to install everything used in this workshop on a Linux computing cluster, such as the
NM-AIST cluster. It is written for two readers:

- **System administrators** who want to install the software once, for everyone ([Part A](#shared-install)).
- **Individual users** without administrator rights, who can install it in their own home folder ([Part B](#personal-install)).

Everything is installed with **conda**, which needs no root access and keeps the tools separate from the system software.

| Part | What it covers |
|---|---|
| [What gets installed](#what-gets-installed) | The tools and R packages |
| [A. Shared install](#shared-install) | One installation for all users (administrators) |
| [B. Personal install](#personal-install) | Your own installation in your home folder |
| [C. Workshop data](#workshop-data) | Putting the lesson data on the cluster |
| [D. Running jobs](#running-jobs) | Using the tools through the job scheduler |
| [E. Test the installation](#test) | Check that everything works |
| [F. Questions for IT](#questions-for-it) | Things to agree with the cluster administrators |

## What gets installed {#what-gets-installed}

Two conda environments, defined in files you can download:

- [genomics.yml](assets/env/genomics.yml): **command-line tools**: FastQC, Trimmomatic, BWA, samtools, bcftools (with `vcfutils.pl`), Kraken2, kraken-biom, sra-tools, plus `curl`, `wget` and `nano`.
- [r-workshop.yml](assets/env/r-workshop.yml): **R** with tidyverse (including ggplot2), ape, patchwork, RColorBrewer, vegan and phyloseq.

They are kept separate because R and the bioinformatics tools install faster and break less often in their own environments.

Space needed: about 2 GB for Miniforge and the command-line tools, and 2 to 3 GB more for R. The workshop data adds a few GB
(see [Part C](#workshop-data)). A Kraken2 reference database is optional and large (8 GB for a small one, much more for the standard one).
{: .tip}

## A. Shared install, for administrators {#shared-install}

Install Miniforge once in a shared folder that all users can read, for example `/opt/miniforge3` or `/shared/apps/miniforge3`.
Replace `/shared/apps` below with your cluster's software location.

```bash
# 1. Download and install Miniforge into a shared folder (-b = no questions, -p = install location)
cd /tmp
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
bash Miniforge3-Linux-x86_64.sh -b -p /shared/apps/miniforge3

# 2. Load conda into this shell
source /shared/apps/miniforge3/etc/profile.d/conda.sh

# 3. Use strict channel priority (avoids mixing incompatible packages)
conda config --system --set channel_priority strict

# 4. Download the environment files and create both environments
curl -L -O https://lukejharmon.github.io/tanzania2026/assets/env/genomics.yml
curl -L -O https://lukejharmon.github.io/tanzania2026/assets/env/r-workshop.yml
conda env create -f genomics.yml
conda env create -f r-workshop.yml

# 5. Let all users read and run the installation
chmod -R a+rX /shared/apps/miniforge3
```

**Make it easy for users to load.** Either tell users to add this line to their `~/.bashrc`:

```bash
source /shared/apps/miniforge3/etc/profile.d/conda.sh
```

or, if the cluster uses environment modules (`module load ...`), create a module that runs the same line.
Users then turn on the tools with:

```bash
conda activate genomics      # command-line tools
conda activate r-workshop    # R
```

Users cannot change a shared environment. If they need extra packages, they can make their own environments
in their home folder (Part B) or clone the shared one: `conda create -n my-genomics --clone genomics`.

## B. Personal install, without administrator rights {#personal-install}

Any user can do this in their own home folder.

```bash
# 1. Install Miniforge in your home folder; answer "yes" when asked to initialise conda
cd ~
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
bash Miniforge3-Linux-x86_64.sh

# 2. Close and reopen your terminal (or log out and in), then check conda works
conda --version

# 3. Create the environments
curl -L -O https://lukejharmon.github.io/tanzania2026/assets/env/genomics.yml
curl -L -O https://lukejharmon.github.io/tanzania2026/assets/env/r-workshop.yml
conda env create -f genomics.yml
conda env create -f r-workshop.yml

# 4. Turn on the tools
conda activate genomics
```

Home folders on clusters are often small. If yours is, ask IT where to keep software
(often a "project" or "work" folder) and install Miniforge there instead: `bash Miniforge3-Linux-x86_64.sh -p /path/to/work/miniforge3`.
{: .tip}

**No internet on the cluster?** Some clusters block downloads from compute or even login nodes.
Install on a node that has internet (often the login node or a special "data transfer" node), or ask IT.

## C. Workshop data {#workshop-data}

The lessons expect data in these folders in each user's home folder:

| Folder | Contents | Used in |
|---|---|---|
| `~/shell_data/` | Two small FASTQ files and the SRA run table | Shell lessons (Days 1 and 2) |
| `~/dc_workshop/data/untrimmed_fastq/` | Six paired-end FASTQ files (*E. coli*) | Quality control, trimming |
| `~/dc_workshop/data/trimmed_fastq_small/` | Subsampled trimmed reads | Alignment, variant calling |
| `~/dc_workshop/data/ref_genome/` | *E. coli* REL606 reference genome | Alignment, variant calling |
| `~/dc_workshop/taxonomy/` | Kraken reports and `cuatroc.biom` | Microbiome analysis in R |
| `~/r_data/` | `combined_tidy_vcf.csv` | R lessons |

**Option 1: copy it from a workshop cloud computer** (while they are still running). On the cloud computer, pack the data
into one file:

```bash
tar czf workshop-data.tar.gz -C ~ shell_data r_data dc_workshop/taxonomy .backup/untrimmed_fastq
```

Download it to your laptop with `scp` (see [Moving files](day4.html#moving-files)), upload it to the cluster the same way,
then on the cluster:

```bash
# shared copy for everyone (administrators), or use ~ for just yourself
mkdir -p /shared/data/workshop
tar xzf workshop-data.tar.gz -C /shared/data/workshop

# each user copies what they need into their home folder
cp -r /shared/data/workshop/shell_data /shared/data/workshop/r_data ~/
mkdir -p ~/dc_workshop/data/untrimmed_fastq
cp -r /shared/data/workshop/dc_workshop/taxonomy ~/dc_workshop/
cp /shared/data/workshop/.backup/untrimmed_fastq/*fastq.gz ~/dc_workshop/data/untrimmed_fastq/
```

**Option 2: download the public data directly on the cluster.** The commands are on the
[Keep going](keep-going.html#get-the-data) page: FASTQ files from ENA in part 3, the reference genome and
subsampled reads in part 5. The shell-lesson data and Kraken files are on the cloud computers only, so use Option 1 for those.

## D. Running jobs {#running-jobs}

On most clusters you log in to a **login node**, which is shared by everyone and only for light work: editing files,
copying data, installing software. Heavy work (trimming, alignment) goes to **compute nodes** through a job scheduler.
Many clusters use **SLURM**; ask IT which one yours uses.

**An interactive session** (a terminal on a compute node, good for following the lessons):

```bash
srun --cpus-per-task=2 --mem=8G --time=02:00:00 --pty bash
conda activate genomics
```

**A batch job** (runs on its own, good for the whole pipeline). Save this as `variant_calling.slurm`:

```bash
#!/bin/bash
#SBATCH --job-name=variant_calling
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=variant_calling_%j.log

source /shared/apps/miniforge3/etc/profile.d/conda.sh   # or ~/miniforge3/etc/profile.d/conda.sh
conda activate genomics

bash ~/dc_workshop/scripts/run_variant_calling.sh
```

The pipeline script is in [Keep going, part 7](keep-going.html#automation). Submit and check the job with:

```bash
sbatch variant_calling.slurm     # submit
squeue -u $USER                  # is it waiting or running?
cat variant_calling_*.log        # read the output when it finishes
```

### Cheat sheet

| Command | What it does |
|---|---|
| `conda activate genomics` | Turn on the command-line tools |
| `conda activate r-workshop` | Turn on R |
| `conda deactivate` | Turn off the current environment |
| `conda env list` | List environments |
| `srun --pty bash` | Interactive terminal on a compute node (SLURM) |
| `sbatch job.slurm` | Submit a batch job (SLURM) |
| `squeue -u $USER` | List your jobs |
| `scancel 12345` | Cancel job number 12345 |

**R on a cluster:** start R in a terminal with `conda activate r-workshop`, then `R`. Graphical RStudio is not part of this
install; if IT can offer RStudio Server or Open OnDemand, that gives the same RStudio you used in the workshop.

## E. Test the installation {#test}

Run this after installing. Every line should print a version number, and the last line should print `OK`.

```bash
conda activate genomics
fastqc --version
trimmomatic -version
bwa 2>&1 | grep Version
samtools --version | head -1
bcftools --version | head -1
which vcfutils.pl
kraken2 --version | head -1
kraken-biom --version
find $CONDA_PREFIX -name NexteraPE-PE.fa | head -1     # Trimmomatic's adapter file
conda deactivate

conda activate r-workshop
Rscript -e 'library(ggplot2); library(ape); library(phyloseq); library(vegan); cat("OK\n")'
conda deactivate
```

Then try a real job: run [Keep going, parts 5 and 6](keep-going.html#alignment) on one sample.

## F. Questions for IT {#questions-for-it}

Agree on these with the cluster administrators before students start:

- **Where should shared software and shared data live**, and how much space is there?
- **How do users get accounts**, and how big are home folders?
- **Which job scheduler** does the cluster use, and what are the limits (CPUs, memory, time) per job?
- **Is there internet access** from login nodes or compute nodes, for installing software and downloading data?
- **Can students use RStudio Server or Open OnDemand**, or only the terminal?
- **Who looks after the installation** when tools need updating?
