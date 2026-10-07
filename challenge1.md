---
title: "Challenge 1: Cracking the shell"
---

# Challenge 1: Cracking the shell

**Time:** 30 minutes · Work in pairs · Use the [command line cheat sheet](command_line_basics.html)

Every answer should be a command you typed. Write your commands down as you go; you will reuse them this afternoon.

## Part 1: Find your way around (5 min)

1. Print the directory you are in right now.
2. Go to `shell_data/untrimmed_fastq`. Use Tab to complete the names instead of typing them out.
3. List the files there, showing their sizes. Which file is bigger?
4. From inside `untrimmed_fastq`, list the contents of `sra_metadata` **without** leaving the directory you are in.
5. Return to your home directory using the shortest command you know.

## Part 2: Wildcards (5 min)

Go back to `shell_data/untrimmed_fastq`.

1. List only the files that end in `.fastq`.
2. List only the files whose names end in `977.fastq`.
3. In `/usr/bin`, list every file that ends in `.sh`.
4. In `/usr/bin`, list every file that starts with `c` and ends with `.sh`.

## Part 3: Look inside a FASTQ file (10 min)

1. Print the **first** complete read (4 lines) of `SRR098026.fastq`.
2. Print the **last** complete read of `SRR098026.fastq`. What is the read ID in its header line?
3. Open `SRR097977.fastq` in `less`. Search for the sequence `TTTTT`. Jump to the end of the file, then back to the start. Quit.
4. Look at the first read of `SRR098026.fastq` again. What do you notice about its sequence? What would that mean for analysis?

## Part 4: Protect your raw data (10 min)

1. Make a directory called `backup` inside `untrimmed_fastq`.
2. Copy `SRR098026.fastq` into `backup`, renaming the copy `SRR098026-backup.fastq` in the same command.
3. Remove write permission from the backup copy. Check that it worked with a long listing. Which letter changed?
4. Try to delete the backup copy with `rm`. What does the shell ask you? Answer `n`.
5. Use `history` to find the command you ran in step 2, and re-run it with `!` and its number.
6. Delete the whole `backup` directory. (Careful: there is no undo.)

## Bonus

- Without opening the file, how many lines does `SRR098026.fastq` have? How many reads is that?
- What does `ls -F` add to the listing in `shell_data`, and why is that useful?

---

*Adapted from the Data Carpentry lesson [Introduction to the Command Line for Genomics](https://datacarpentry.github.io/shell-genomics/) (CC-BY 4.0).*
