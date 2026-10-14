---
layout: day
day: day1
title: "Day 1: The shell"
---

## Introductions {#introductions}

09:00 – 10:00
{: .session-time}

Talks from the three instructors.

## Introduction to project management {#introduction-to-project-management}

10:00 – 10:30
{: .session-time}

Slides: [Introduction to project management](1-intro_project_management.pdf) (PDF)

## Command line basics {#command-line-basics}

10:30 – 12:00 and 13:30 – 15:00
{: .session-time}

### Code we used

```bash
# --- Logging in ---------------------------------------------------------
# Open your cloud computer in a web browser: tinyurl.com/nmaistXX
# (replace XX with your pair number)
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
| Tab | Autocomplete |
| Ctrl + C | Stop a running command |
| `*` | Wildcard: matches any characters |
| `cat file` | Print a whole file |
| `less file` | Scroll through a file (`q` to quit, `/word` to search) |
| `head -n 4` / `tail -n 4` | First / last 4 lines |
| `cp a b` | Copy `a` to `b` |
| `mv a b` | Move or rename `a` to `b` |
| `mkdir name` | Make a folder |
| `rm file` / `rm -r folder` | Delete (**permanent: there is no recycle bin**) |
| `chmod -w file` | Make a file read-only |

**Paths:** `/` at the start means "from the root" (an *absolute* path).
No `/` at the start means "from where I am now" (a *relative* path). `~` means your home folder.

**A FASTQ read is always 4 lines:** `@` header, sequence, `+`, quality scores.

The full one-page reference: [shell cheat sheet](command_line_basics.html).

### Practice

- [Challenge 1: Cracking the shell](challenge1.html)
- [Challenge 2: Loops and redirects](challenge2.html), with the [programming cheat sheet](programming_command_line.html)

### Go further

- Data Carpentry: [Introducing the Shell](https://datacarpentry.github.io/shell-genomics/01-introduction.html)
- Data Carpentry: [Navigating Files and Directories](https://datacarpentry.github.io/shell-genomics/02-the-filesystem.html)
- Data Carpentry: [Working with Files and Directories](https://datacarpentry.github.io/shell-genomics/03-working-with-files.html)
{: .lesson}

## Presentation: Onesmo Balemba {#onesmo-presentation}

16:00 – 17:00
{: .session-time}

*Does gut microbiome dysbiosis drive gastrointestinal neuropathy and dysmotility in type 2 diabetes?*

Slides: [Gut microbiome and GI neuropathy in type 2 diabetes](balemba_gut_microbiome_seminar.pdf) (PDF, 3.6 MB)
