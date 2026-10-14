---
layout: day
day: day2
title: "Day 2: Searching, loops and quality control"
---

## From sequencing reads to variants {#from-reads-to-variants}

09:00 – 09:30
{: .session-time}

An overview of the whole pipeline we are building this week:
raw reads, quality control, trimming, alignment to a reference, variant calling, then analysis in R.

Slides: [Variant calling workflow](variant.pdf)

**Today's code comes from these Data Carpentry lessons.** Read them to review, or to keep going past where we stopped:

- [Shell Genomics: Redirection](https://datacarpentry.github.io/shell-genomics/04-redirection.html): grep, `>`, `>>`, pipes, `wc`, variables, `for` loops. Still to read: using `basename` in loops.
- [Shell Genomics: Writing Scripts](https://datacarpentry.github.io/shell-genomics/05-writing-scripts.html): writing scripts and downloading data.
- [Wrangling Genomics: Background and Metadata](https://datacarpentry.github.io/wrangling-genomics/01-background.html): where the *E. coli* data comes from (the Lenski experiment).
- [Wrangling Genomics: Assessing Read Quality](https://datacarpentry.github.io/wrangling-genomics/02-quality-control.html): getting the data and running FastQC. Still to read: reading the FastQC plots, finding failed checks with `grep FAIL`.
{: .lesson}

## Searching, redirecting and pipes {#searching-redirecting-and-pipes}

09:30 – 12:30, hands-on part 1 of 3
{: .session-time}

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
| <code>command1 &#124; command2</code> | **Pipe**: output of command 1 becomes input of command 2 |
| `wc file` | Count lines, words and characters |
| `wc -l file` | Count lines only |
| `less file` | Scroll through a file (`q` to quit) |

`>` silently replaces whatever was in the file. Use `>>` when you want to add to it.
{: .tip}

### Go further

- Data Carpentry: [Redirection](https://datacarpentry.github.io/shell-genomics/04-redirection.html)
{: .lesson}

## Variables and loops {#variables-and-loops}

Hands-on part 2 of 3
{: .session-time}

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

The loop pattern to remember:

```bash
for filename in *.fastq
do
    some_command ${filename}
done
```

### Go further

- Data Carpentry: [Redirection: writing for loops](https://datacarpentry.github.io/shell-genomics/04-redirection.html#writing-for-loops)
{: .lesson}

## Getting the data and quality control with FastQC {#fastqc}

Hands-on part 3 of 3
{: .session-time}

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

**Viewing the HTML reports:** in RStudio, go to the *Files* pane, open
`dc_workshop/results/fastqc_untrimmed_reads`, click an `.html` file and choose *View in Web Browser*.

### Cheat sheet

| Command | What it does |
|---|---|
| `mkdir -p path/to/folder` | Make a folder, including any missing parent folders |
| `cp source/*fastq.gz .` | Copy files here (`.` = current folder) |
| `curl -O URL` | Download a file from the internet |
| `gunzip file.gz` | Uncompress a `.gz` file |
| `fastqc *.fastq*` | Run FastQC on all FASTQ files (makes an `.html` and a `.zip` per file) |
| `unzip file.zip` | Unzip one zip file |
| `cat */summary.txt` | `*/` = inside every folder here |

A FASTQ file stores 4 lines per read:

```
@SRR2584863.1 HWI-ST957:...      <- header (read name)
CGTGCGCTTGATCGGAGTGACATAGAA...   <- sequence
+                                <- separator
@@@DDDDDHHHHFHJJJIHGIJIJIIH...   <- quality score for each base
```

In the FastQC summary each check is `PASS`, `WARN` or `FAIL`. A `FAIL` doesn't always mean bad data;
some checks (like *Per base sequence content*) often fail for normal reasons.

### Go further

- Data Carpentry: [Background and Metadata](https://datacarpentry.github.io/wrangling-genomics/01-background.html)
- Data Carpentry: [Assessing Read Quality](https://datacarpentry.github.io/wrangling-genomics/02-quality-control.html)
{: .lesson}

## Science communication {#science-communication}

14:00 – 17:00, with Christine Parent and Onesmo Balemba
{: .session-time}

- Slides: [How to tell your story](tellStory.pdf), Christine Parent (PDF)
- Slides: [Elements of a successful grant application](balemba_nih_grant_writing.pdf), Onesmo Balemba (PDF)
- Sample NIH Specific Aims: [Examples](specific_aims_examples.html)
- NIH R01 funding announcement: [PA-25-301](PA-25-301%20R01.pdf) (PDF)

## Film: *Snail Hunters* {#snail-hunters}

17:00 – 18:00
{: .session-time}

A documentary by Jim Aikman following University of Idaho evolutionary biologists to the Galápagos, where they study
land snails rather than the islands' famous tortoises and boobies.

<a class="video" href="https://www.youtube.com/watch?v=0qiAMNMxrJU" aria-label="Watch the Snail Hunters trailer on YouTube">
  <img src="https://i.ytimg.com/vi/0qiAMNMxrJU/hqdefault.jpg" alt="Still from the Snail Hunters trailer" loading="lazy">
  <span class="video-play" aria-hidden="true"></span>
</a>

Trailer: [Snail Hunters on YouTube](https://www.youtube.com/watch?v=0qiAMNMxrJU)
