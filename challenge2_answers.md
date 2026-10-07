# Challenge 2: Answer key (instructors only)

Paths assume the Data Carpentry setup (`~/shell_data`). Items marked \* depend on the exact data files. Run them once on the workshop machines and fill in the numbers before class.

## Part 1

1. `grep NNNNNNNNNN SRR098026.fastq`
2. `grep -B1 -A2 NNNNNNNNNN SRR098026.fastq`
3. Two ways: `grep -c NNNNNNNNNN SRR098026.fastq`, or `grep NNNNNNNNNN SRR098026.fastq | wc -l`. Count = \_\_\_ \*
4. `grep -c NNNNNNNNNN *.fastq`. Prints one count per file, `file:count`. \*

Teaching point: these counts assume `NNNNNNNNNN` only ever appears on sequence lines. `N` is a legal quality character in some encodings (Q45 in Phred+33, Q14 in old Phred+64 data), so a run of Ns in a quality line would inflate the count. Worth a quick mention for anyone who will use `grep` on their own FASTQ files.

## Part 2

1. `grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt`
2. `wc -l bad_reads.txt` = \_\_\_ \*. It is **not** a multiple of 4, because `grep` puts a `--` line between groups of matches that aren't next to each other. `less bad_reads.txt` shows them.
3. `grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt`
4. The `>` replaced the whole file, so the SRR097977 reads are gone. This is the most common real-world mistake with redirection.
5. `grep -h NNNNNNNNNN *.fastq | wc -l` (sequence lines only, so this equals the number of bad reads). Total = \_\_\_ \*

## Part 3

1. `grep -c SINGLE SraRunTable.txt` = \_\_\_ \*; `grep -c PAIRED SraRunTable.txt` = \_\_\_ \*
2. `grep -c -i single SraRunTable.txt`
3. `grep -c -v PAIRED SraRunTable.txt`. It is one more than the single-end count because the header line doesn't contain `PAIRED` either. (Check on the real file that every run is either `SINGLE` or `PAIRED`.) \*
4. ```bash
   grep PAIRED SraRunTable.txt > paired_runs.txt
   head -n 1 SraRunTable.txt > header_and_paired.txt
   cat paired_runs.txt >> header_and_paired.txt
   ```
   One-line version for fast pairs: `head -n 1 SraRunTable.txt > header_and_paired.txt; grep PAIRED SraRunTable.txt >> header_and_paired.txt`

## Part 4

1. ```bash
   for filename in *.fastq
   do
     echo ${filename}
   done
   ```
2. ```bash
   for filename in *.fastq
   do
     name=$(basename ${filename} .fastq)
     echo ${name}
   done
   ```
3. ```bash
   for filename in *.fastq
   do
     head -n 4 ${filename} >> first_reads.txt
   done
   ```
4. ```bash
   for filename in *.fastq
   do
     name=$(basename ${filename} .fastq)
     grep -B1 -A2 NNNNNNNNNN ${filename} > ${name}_bad.txt
   done
   ```
   Here `>` is right, because each pass writes a different file.
5. With `>`, each pass overwrites `first_reads.txt`, so only the last file's read survives. Also: running the step 3 loop twice with `>>` doubles the contents. Delete `first_reads.txt` before re-running.

## Part 5

1. ```bash
   # Find reads with 10 or more Ns in a row in all FASTQ files
   grep -B1 -A2 -h NNNNNNNNNN *.fastq | grep -v '^--' > scripted_bad_reads.txt
   echo "Script finished!"
   ```
2. `bash bad-reads-script.sh`
3. `chmod +x bad-reads-script.sh`, then `./bad-reads-script.sh`. `ls -l` should show `x` in the permissions.
4. `wc -l scripted_bad_reads.txt` = \_\_\_ \*. Divide by 4 for reads. It should match the Part 2 step 5 total.

## Bonus

- ```bash
  # Save bad reads per sample and report counts
  for filename in *.fastq
  do
    name=$(basename ${filename} .fastq)
    grep -B1 -A2 NNNNNNNNNN ${filename} | grep -v '^--' > ${name}_bad.txt
    echo "${name}: $(grep -c NNNNNNNNNN ${filename}) bad reads"
  done
  ```
- `*.fastq` would match `scripted_bad_reads.fastq` the next time the script runs, so `grep` would read its own output. A `.txt` name keeps output out of the wildcard.

## Common snags

- Spaces around `=` in `name = $(...)` make the shell look for a command called `name`.
- A loop typed with the `>` continuation prompt and a typo: Ctrl+C, then start over.
- Writing the script in nano with the `$` prompt included.
- `./bad-reads-script.sh` gives "Permission denied": they skipped `chmod +x`.
- Output files piling up from repeated `>>` runs. `ls` often, and `rm` stale outputs before re-running.
