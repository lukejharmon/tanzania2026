---
title: Bioinformatics workshop - Tanzania 2026
---

# Bioinformatics workshop - Tanzania 2026

## Monday October 12, Day 1: Introduction to Bioinformatics: The Shell

| Time | Session |
|------|---------|
| 09:00 – 10:00 | [Introductions](#introductions) |
| 10:00 – 10:30 | [Introduction to project management](#introduction-to-project-management) |
| 10:30 – 12:00 | [Command line basics](#command-line-basics) |
| 12:00 – 13:30 | Lunch break |
| 13:30 – 15:00 | [Command line basics continued](#command-line-basics) |
| 16:00 – 17:00 | [Onesmo presentation](#onesmo-presentation) |

---

## Introductions

**09:00 – 10:00**

Talks from the three instructors.

---

## Introduction to project management

**10:00 – 10:30**

📄 Slides: [Introduction to project management](1-intro_project_management.pdf)

---

## Command line basics

### Code we used

```bash
# --- Logging in ---------------------------------------------------------
# Connect to your cloud computer (replace XX with your pair's address)
tinyurl.com/nmaistXX
# user: dcuser; password: data4Carp

# clear screen
clear
# go home
cd ~
# change directory
cd shell_data/untrimmed_fastq
# list
ls
# see the full contents of a file
cat SRR098026.fastq
# interactive file viewer
less SRR098026.fastq # type q to exit
# when you are in less: space is forward, b back, g beginning, G end, q quit

# head shows the file beginning; tail shows the file end
head SRR098026.fastq
tail SRR098026.fastq
head -n 4 SRR098026.fastq 

# copy a file
cp SRR098026.fastq SRR098026-copy.fastq
ls
# create a new directory
mkdir backup
ls -F
# move the file
mv SRR098026-copy.fastq backup
# check if it worked
ls
ls backup

# rename a file
cd backup
mv -i SRR098026-copy.fastq SRR098026-backup.fastq
ls

# file permissions
ls -l
chmod -w SRR098026-backup.fastq
ls -l
# check file permission by trying to delete
rm SRR098026-backup.fastq
cd ..
rm -r backup
ls

cp SRR097977.fastq SRR097977-backup.fastq
cp SRR098026.fastq SRR098026-backup.fastq
mkdir backup
mv *backup.fastq backup
cd backup
chmod -w *

```

### Cheat sheet

| Command | What it does |
|---|---|
| `pwd` | Show where you are |
| `ls` | List files (`-F` mark folders, `-l` details, `-h` readable sizes, `-a` hidden files) |
| `cd folder` | Move into a folder |
| `cd ..` | Move up one level |
| `cd` or `cd ~` | Go home |
| `man ls` | Manual page for a command (`q` to quit) |
| `Tab` | Autocomplete |
| `Ctrl + C` | Stop a running command |
| `*` | Wildcard: matches any characters |
| `cat file` | Print a whole file |
| `less file` | Scroll through a file (`q` to quit, `/word` to search) |
| `head -n 4` / `tail -n 4` | First / last 4 lines |
| `cp a b` | Copy `a` to `b` |
| `mv a b` | Move or rename `a` to `b` |
| `mkdir name` | Make a folder |
| `rm file` / `rm -r folder` | Delete (**permanent — no recycle bin**) |
| `chmod -w file` | Make a file read-only |
| `grep pattern file` | Find lines matching a pattern (`-v` invert, `-c` count, `-B`/`-A` lines before/after) |
| `>` | Send output to a file (overwrites) |
| `>>` | Add output to the end of a file |
| `\|` | Pipe: send output of one command into the next |
| `wc -l` | Count lines |
| `for x in ...; do ...; done` | Repeat a command for each item |
| `basename name .ext` | Strip the extension from a file name |

**Paths:** `/` at the start means "from the root" (an *absolute* path).
No `/` at the start means "from where I am now" (a *relative* path). `~` means your home folder.

**A FASTQ read is always 4 lines:** `@` header · sequence · `+` · quality scores.


### Go further

📘 Data Carpentry lessons:
- [Introducing the Shell](https://datacarpentry.github.io/shell-genomics/01-introduction.html)
- [Navigating Files and Directories](https://datacarpentry.github.io/shell-genomics/02-the-filesystem.html)
---

## Onesmo presentation

**16:00 – 17:00**

# Day 2 · Tuesday 13 October

| Time | Session |
|------|---------|
| 09:00 – 09:30 | [From sequencing reads to variants: the workflow](#from-sequencing-reads-to-variants-the-workflow) |
| 09:30 – 12:30 | Hands-on: [Searching, redirecting and pipes](#searching-redirecting-and-pipes) · [Variables and loops](#variables-and-loops) · [Getting the data and FastQC](#getting-the-data-and-quality-control-with-fastqc) |
| 12:30 – 14:00 | Lunch break |
| 14:00 – 17:00 | [Science communication with Christine and Onesmo](#science-communication-with-christine-parent) |
| 17:00 – 18:00 | [Film: *Snail Hunters*](#film-snail-hunters) |

---

## From sequencing reads to variants: the workflow

**09:00 – 09:30**

An overview of the whole pipeline we are building this week:
raw reads → quality control → trimming → alignment to a reference → variant calling → analysis in R.

📄 Slides: [Variant calling workflow](LINK-TO-SLIDES)

---

## Searching, redirecting and pipes

**09:30 – 12:30** (hands-on, part 1 of 3)

### Code we used

```bash
cd ~/shell_data/sra_metadata

# --- Searching with grep -------------------------------------------------
# find all of the lines in the file that contain PAIRED
grep PAIRED SraRunTable.txt

# count the lines that contain PAIRED (-c = count)
grep -c PAIRED SraRunTable.txt

# give me all lines that are NOT SINGLE (-v = invert the match)
grep -v SINGLE SraRunTable.txt

# options can be combined: count the lines that are NOT SINGLE
grep -cv SINGLE SraRunTable.txt

# --- Redirecting output to a file ----------------------------------------
# > sends the output into a file instead of the screen (overwrites the file!)
grep SRR097977 SraRunTable.txt > metadata.txt

# wc = word count: prints lines, words, characters
wc metadata.txt

# how many lines are in the new file? (-l = lines only)
wc -l metadata.txt
# answer: 1

# how many lines are in the SraRunTable.txt file?
wc -l SraRunTable.txt

# --- Appending ------------------------------------------------------------
# put the PAIRED and SINGLE lines together in one file
grep PAIRED SraRunTable.txt > metadata.txt     # > starts a fresh file
grep SINGLE SraRunTable.txt >> metadata.txt    # >> adds to the end of the file
less metadata.txt                              # look at it (q to quit)
wc -l metadata.txt

# --- Pipes ----------------------------------------------------------------
# | sends the output of one command straight into the next - no file needed
grep SINGLE SraRunTable.txt | wc -l
```

### Cheat sheet

| Command | What it does |
|---|---|
| `grep pattern file` | Print lines that contain `pattern` |
| `grep -c pattern file` | **Count** matching lines |
| `grep -v pattern file` | Lines that do **not** match |
| `grep -cv pattern file` | Combine options: count lines that do not match |
| `command > file` | Save output to a file (**overwrites** it) |
| `command >> file` | **Append** output to the end of a file |
| `command1 \| command2` | **Pipe**: output of command 1 becomes input of command 2 |
| `wc file` | Count lines, words and characters |
| `wc -l file` | Count lines only |
| `less file` | Scroll through a file (`q` to quit) |

⚠️ `>` silently replaces whatever was in the file. Use `>>` when you want to add to it.

### Go further

📘 Data Carpentry lesson: [Redirection](https://datacarpentry.github.io/shell-genomics/04-redirection.html)

---

## Variables and loops

(hands-on, part 2 of 3)

### Code we used

```bash
# --- Variables -------------------------------------------------------------
# store a value in a variable (no spaces around the =)
foo=abc

# see what is stored using echo; $ means "the value of"
echo foo is $foo

# this does not work: the shell looks for a variable called fooEFG, which doesn't exist
echo foo is $fooEFG

# this works: curly braces mark where the variable name ends
echo foo is ${foo}EFG

# --- Loops -----------------------------------------------------------------
cd ~/shell_data/untrimmed_fastq

# for every .fastq file, add its first 2 lines to seq_info.txt
for filename in *.fastq
do
    head -n 2 ${filename} >> seq_info.txt
done

# check the result: 2 lines per file
wc -l seq_info.txt
```

### Cheat sheet

| Command | What it does |
|---|---|
| `name=value` | Create a variable (**no spaces** around `=`) |
| `$name` | Use the value of a variable |
| `${name}` | Same, but safe when text follows: `${name}_1.fastq` |
| `echo text` | Print text to the screen |
| `for x in list` | Start a loop: `x` takes each value in turn |
| `do ... done` | The commands to repeat go between `do` and `done` |

**Loop pattern to remember:**

```bash
for filename in *.fastq
do
    some_command ${filename}
done
```

### Go further

📘 Data Carpentry lesson: [Redirection — Writing for loops](https://datacarpentry.github.io/shell-genomics/04-redirection.html#writing-for-loops)

---

## Getting the data and quality control with FastQC

(hands-on, part 3 of 3)

### Code we used

```bash
# --- Set up a project folder ----------------------------------------------
# -p makes any missing parent folders too, and doesn't complain if it already exists
mkdir -p ~/dc_workshop/data/untrimmed_fastq
cd ~/dc_workshop/data/untrimmed_fastq

# We can download the data from the European Nucleotide Archive (EBI) like this:
# curl -O ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_1.fastq.gz
# Students, do not do this right now, please! The files are large and the network is slow.

# Instead, copy the copies already on your machine (. = "here")
cp ~/.backup/untrimmed_fastq/*fastq.gz .
ls -l

# --- Look at a FASTQ file --------------------------------------------------
# unzip one file so we can read it
gunzip SRR2584863_1.fastq.gz
ls -lh                              # compare the sizes: compressed vs uncompressed

# how many lines? (divide by 4 = number of reads)
wc -l SRR2584863_1.fastq

# the first read: header, sequence, +, quality scores
head -n 4 SRR2584863_1.fastq

# --- FastQC quality control -----------------------------------------------
# run FastQC on every file, zipped or not
fastqc *.fastq*

# tidy up: move the results into their own folder
mkdir -p ~/dc_workshop/results/fastqc_untrimmed_reads
mv *.zip ~/dc_workshop/results/fastqc_untrimmed_reads
mv *.html ~/dc_workshop/results/fastqc_untrimmed_reads

# --- Look at the results --------------------------------------------------
cd ~/dc_workshop/results/fastqc_untrimmed_reads

# unzip can only do one file at a time, so loop over them
for filename in *.zip
do
    unzip $filename
done

# combine every summary into one file
mkdir -p ~/dc_workshop/docs
cat */summary.txt > ~/dc_workshop/docs/fastqc_summaries.txt
head ~/dc_workshop/docs/fastqc_summaries.txt
less ~/dc_workshop/docs/fastqc_summaries.txt
```

**Try this:** which checks failed? `grep FAIL ~/dc_workshop/docs/fastqc_summaries.txt`

**Viewing the HTML reports:** in RStudio, go to the *Files* pane →
`dc_workshop/results/fastqc_untrimmed_reads` → click an `.html` file → *View in Web Browser*.

### Cheat sheet

| Command | What it does |
|---|---|
| `mkdir -p path/to/folder` | Make a folder, including any missing parent folders |
| `cp source/*fastq.gz .` | Copy files here (`.` = current folder) |
| `curl -O URL` | Download a file from the internet |
| `gunzip file.gz` | Uncompress a `.gz` file |
| `fastqc *.fastq*` | Run FastQC on all FASTQ files (makes `.html` + `.zip` per file) |
| `unzip file.zip` | Unzip one zip file |
| `cat */summary.txt` | `*/` = inside every folder here |

**FASTQ format, 4 lines per read:**

```
@SRR2584863.1 HWI-ST957:...      ← header (read name)
CGTGCGCTTGATCGGAGTGACATAGAA...   ← sequence
+                                ← separator
@@@DDDDDHHHHFHJJJIHGIJIJIIH...   ← quality score for each base
```

**FastQC summary:** each check is `PASS`, `WARN` or `FAIL`. A `FAIL` doesn't always mean bad data;
some checks (like *Per base sequence content*) often fail for normal reasons.

### Go further

📘 Data Carpentry lessons:
- [Background and Metadata](https://datacarpentry.github.io/wrangling-genomics/01-background.html)
- [Assessing Read Quality](https://datacarpentry.github.io/wrangling-genomics/02-quality-control.html)

---

## Lunch break

**12:30 – 14:00**

---

## Science communication with Christine Parent

### Introduction to project management

**10:00 – 10:30**

📄 Slides: [How to tell your story](tellStory.pdf)

---

## Film: *Snail Hunters*

**17:00 – 18:00**


## Thursday October 15, Day 4: Putting it all together

| Time | Session |
|------|---------|
| 09:00 - 11:00 | Plotting results in R |
| 11:00 - 12:00 | Wrap-up and summary of all materials |
| 12:00 - 13:30 | Lunch break |
| 13:30 - 15:00 | Group work |
| 15:00 - 16:00 | Present group work |
