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
| 13:30 – 15:00 | [Programming the command line](#programming-the-command-line) |
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

**10:30 – 12:00**

### Code we used

```bash
# --- Logging in ---------------------------------------------------------
# Connect to your cloud computer (replace with your pair's address)
ssh dcuser@ec2-XX-XX-XX-XX.compute-1.amazonaws.com

# --- Where am I? ---------------------------------------------------------
pwd                     # print working directory: where you are right now
whoami                  # which user you are logged in as
ls                      # list the files and folders here
ls -F                   # same, but folders end in /
ls -l                   # long listing: permissions, size, date
ls -lh                  # long listing with human-readable sizes (K, M, G)
ls -a                   # show hidden files (names starting with .)

# --- Moving around -------------------------------------------------------
cd shell_data           # go into a folder
cd untrimmed_fastq      # go one level deeper
cd ..                   # go up one level
cd                      # go home, from anywhere
cd ~/shell_data/untrimmed_fastq   # full path, using ~ for home

# --- Shortcuts -----------------------------------------------------------
# Tab        : autocomplete file and folder names (use it constantly!)
# Up arrow   : bring back the previous command
# Ctrl + C   : cancel a command that is running or stuck
history                 # list the commands you have run
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

**Paths:** `/` at the start means "from the root" (an *absolute* path).
No `/` at the start means "from where I am now" (a *relative* path). `~` means your home folder.

### Go further

📘 Data Carpentry lessons:
- [Introducing the Shell](https://datacarpentry.github.io/shell-genomics/01-introduction.html)
- [Navigating Files and Directories](https://datacarpentry.github.io/shell-genomics/02-the-filesystem.html)

---

## Programming the command line

**13:30 – 15:00**

### Code we used

```bash
cd ~/shell_data/untrimmed_fastq

# --- Wildcards -----------------------------------------------------------
ls *.fastq              # every file ending in .fastq
ls SRR097977*           # every file starting with SRR097977

# --- Looking inside files ------------------------------------------------
cat SRR098026.fastq     # dump the whole file to the screen (careful with big files!)
less SRR097977.fastq    # scroll through a file: space = page down, q = quit
head -n 4 SRR098026.fastq   # first 4 lines = the first read
tail -n 4 SRR098026.fastq   # last 4 lines = the last read

# --- Copying, moving, renaming, deleting --------------------------------
cp SRR098026.fastq SRR098026-copy.fastq   # copy a file
mkdir backup                               # make a new folder
mv SRR098026-copy.fastq backup/            # move a file into a folder
mv backup/SRR098026-copy.fastq backup/SRR098026-backup.fastq   # rename
chmod -w backup/SRR098026-backup.fastq     # remove write permission (protect it)
rm -r backup                               # delete a folder and everything in it (no undo!)

# --- Searching with grep -------------------------------------------------
grep NNNNNNNNNN SRR098026.fastq            # lines containing 10 Ns in a row
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq    # plus 1 line before and 2 after = the whole read
grep -v NNNNNNNNNN SRR098026.fastq         # lines that do NOT match

# --- Saving output -------------------------------------------------------
grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt    # write to a file (overwrites!)
grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt   # append to the end of a file

# --- Counting, and pipes -------------------------------------------------
wc -l bad_reads.txt                        # count lines in a file
grep NNNNNNNNNN SRR098026.fastq | wc -l    # | sends output of one command into the next

# --- Loops ---------------------------------------------------------------
for filename in *.fastq
do
    head -n 2 ${filename}                  # print the first 2 lines of each file
done

# basename strips part of a name - useful for naming output files
basename SRR097977.fastq .fastq            # prints: SRR097977
```

### Cheat sheet

| Command | What it does |
|---|---|
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

**A FASTQ read is always 4 lines:** `@` header · sequence · `+` · quality scores.

### Go further

📘 Data Carpentry lessons:
- [Working with Files and Directories](https://datacarpentry.github.io/shell-genomics/03-working-with-files.html)
- [Redirection](https://datacarpentry.github.io/shell-genomics/04-redirection.html)
- [Full shell-genomics lesson](https://datacarpentry.github.io/shell-genomics/)

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
