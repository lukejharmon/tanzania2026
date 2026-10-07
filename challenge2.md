---
title: "Challenge 2: Loops and redirects"
---

# Challenge 2: Loops and redirects

**Time:** 60 minutes · Work in pairs · Use the [programming cheat sheet](programming_command_line.html)

This morning you found a read made almost entirely of `N`s. Now you will find **all** the bad reads, count them, and write a script that does the job for you. Work in `~/shell_data/untrimmed_fastq` unless a question says otherwise.

## Part 1: Find the bad reads (10 min)

A "bad read" here is any read containing 10 Ns in a row: `NNNNNNNNNN`.

1. Print every **sequence line** in `SRR098026.fastq` that contains `NNNNNNNNNN`.
2. Now print the **whole FASTQ record** (all 4 lines) for each of those reads.
3. How many bad reads are in `SRR098026.fastq`? Find the answer two different ways.
4. Search **both** FASTQ files at once and count the bad reads in each file with one command.

## Part 2: Save and combine results (15 min)

1. Save the full records of the bad reads in `SRR098026.fastq` to a file called `bad_reads.txt`.
2. Count the lines in `bad_reads.txt`. Is that a whole number of reads? If not, why not? (Hint: look at it with `less`.)
3. Add the bad reads from `SRR097977.fastq` to the **end** of `bad_reads.txt` without losing what is already there.
4. Run your command from step 1 again. What happened to the reads from `SRR097977.fastq`?
5. In one line, using a pipe, count the bad-read lines across both files **without** creating any file.

## Part 3: Metadata (10 min)

Go to `~/shell_data/sra_metadata`.

1. How many runs in `SraRunTable.txt` are single-end (`SINGLE`)? How many are paired-end (`PAIRED`)?
2. Count the lines that contain the word "single" in **any** capitalization.
3. How many lines do **not** contain `PAIRED`? Why is that number one more than the number of single-end runs?
4. Save all the `PAIRED` lines to `paired_runs.txt`, then add the header line (the first line of the file) to `header_and_paired.txt` followed by the paired lines.

## Part 4: Loops (15 min)

Back in `~/shell_data/untrimmed_fastq`.

1. Write a loop that prints the name of each `.fastq` file.
2. Change it to print each name **without** the `.fastq` extension.
3. Write a loop that saves the first read (4 lines) of every FASTQ file into one file, `first_reads.txt`.
4. Write a loop that, for each FASTQ file, saves its bad reads to a separate file named after the sample, e.g. `SRR097977_bad.txt`.
5. What goes wrong if you use `>` instead of `>>` in step 3?

## Part 5: Write a script (10 min)

1. In `nano`, create `bad-reads-script.sh` that:
    - starts with a `#` comment saying what it does
    - finds the bad reads in all FASTQ files and writes them, without the `--` separator lines, to `scripted_bad_reads.txt`
    - prints "Script finished!" when done
2. Run it with `bash`.
3. Make it executable and run it the other way.
4. How many lines are in `scripted_bad_reads.txt`? How many reads is that?

## Bonus

- Change your Part 4 loop into a script that also prints how many bad reads it found in each file.
- Why is it safer to name the output `scripted_bad_reads.txt` than `scripted_bad_reads.fastq`?

---

*Adapted from the Data Carpentry lesson [Introduction to the Command Line for Genomics](https://datacarpentry.github.io/shell-genomics/) (CC-BY 4.0).*
