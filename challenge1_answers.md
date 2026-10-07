# Challenge 1: Answer key (instructors only)

Paths assume the Data Carpentry setup (`~/shell_data`). Run through this once on the workshop machines before class; the starred items depend on the exact data files.

## Part 1

1. `pwd`
2. `cd shell_data/untrimmed_fastq` (type `cd sh`, Tab, `u`, Tab)
3. `ls -l`, then compare the size column. Add `-h` (`ls -lh`) for readable sizes. \*
4. `ls ../sra_metadata`
5. `cd` (`cd ~` also works)

## Part 2

1. `ls *.fastq`
2. `ls *977.fastq`
3. `ls /usr/bin/*.sh`
4. `ls /usr/bin/c*.sh`

## Part 3

1. `head -n 4 SRR098026.fastq`
2. `tail -n 4 SRR098026.fastq`; the read ID is the first line, starting with `@`. \*
3. `less SRR097977.fastq`, then `/TTTTT`, `G`, `g`, `q`. Press `n` to go to the next match.
4. The first read of SRR098026 is almost entirely `N`s (unknown bases), with `!` quality scores, the lowest possible. Bad reads like this have to be found and filtered out before analysis. This sets up Challenge 2, where they find all such reads with `grep`.

## Part 4

1. `mkdir backup`
2. `cp SRR098026.fastq backup/SRR098026-backup.fastq`
3. `chmod -w backup/SRR098026-backup.fastq`, then `ls -l backup`. The `w`s in the permissions turn into `-`.
4. `rm backup/SRR098026-backup.fastq` asks whether to remove the write-protected file. Answer `n`.
5. `history`, then `!` + the number, e.g. `!42`.
6. `rm -r backup`. It will ask about the protected file again; answer `y`. (`rm -rf backup` skips the questions, which is exactly why to be careful with it.)

## Bonus

- `wc -l SRR098026.fastq`; divide by 4 for the number of reads. (`wc` isn't taught until the afternoon, so this is a stretch for fast pairs.) \*
- `ls -F` puts `/` after directories and `*` after executable programs, so you can tell files from folders at a glance.

## Common snags

- Typing the `$` prompt along with the command.
- `cd shell_data` from inside `untrimmed_fastq` fails, because relative paths start from where you are.
- Spaces in the wrong places: `ls*.fastq` or `cp file backup /name`.
- Getting stuck in `less` or `man`: press `q`.
- A half-typed command that won't run: Ctrl+C.
