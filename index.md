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

## Tuesday October 13, Day 2: Sequence data

| Time | Session |
|------|---------|
| 09:00 - 10:00 | Assessing read quality |
| 10:00 - 11:30 | Trimming and filtering |
| 11:30 - 12:00 | Challenge 3: Wrangling sequence data |
| 12:00 - 13:30 | Lunch break |
| 13:30 - 15:00 | Scientific communication - Christine |
| 15:00 - 17:00 | Challenge 4: How to present your data (present to each other) |

## Wednesday October 14, Day 3: Variant calling and R

| Time | Session |
|------|---------|
| 09:00 - 11:30 | Variant calling |
| 11:30 - 12:00 | Challenge 5: Your pipeline |
| 12:00 - 13:30 | Lunch break |
| 13:30 - 15:00 | Introduction to R |
| 15:00 - 16:00 | Sequences and trees in R |
| 16:00 - 17:00 | Revisit communication (present to whole group) |

## Thursday October 15, Day 4: Putting it all together

| Time | Session |
|------|---------|
| 09:00 - 11:00 | Plotting results in R |
| 11:00 - 12:00 | Wrap-up and summary of all materials |
| 12:00 - 13:30 | Lunch break |
| 13:30 - 15:00 | Group work |
| 15:00 - 16:00 | Present group work |
