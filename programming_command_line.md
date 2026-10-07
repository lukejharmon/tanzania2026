---
title: "Programming the command line: cheat sheet"
---

# Programming the command line: cheat sheet

Monday afternoon. Covers searching files, redirection, pipes, loops and scripts. Example files are in `~/shell_data/untrimmed_fastq/` and `~/shell_data/sra_metadata/`.

## Searching with grep

| Command | What it does | Example |
| --- | --- | --- |
| `grep pattern file` | Print lines containing the pattern | `grep NNNNNNNNNN SRR098026.fastq` |
| `grep -B1 -A2` | Also print 1 line Before and 2 lines After each match (a whole FASTQ record) | `grep -B1 -A2 NNNNNNNNNN SRR098026.fastq` |
| `grep -c` | Count matching lines instead of printing them | `grep -c NNNNNNNNNN SRR098026.fastq` |
| `grep -i` | Ignore upper/lower case | `grep -i single SraRunTable.txt` |
| `grep -v` | Lines that do **not** match | `grep -v '^--' bad_reads.txt` |
| `grep -h` | Leave file names off the output when searching several files | `grep -h NNNNNNNNNN *.fastq` |

`grep` separates groups of `-A`/`-B` results with a `--` line. `grep -v '^--'` removes those lines.

## Redirection and pipes

| Symbol | What it does | Example |
| --- | --- | --- |
| `>` | Write output to a file, **replacing** what was there | `grep -B1 -A2 NNNNNNNNNN SRR098026.fastq > bad_reads.txt` |
| `>>` | Add output to the **end** of a file | `grep -B1 -A2 NNNNNNNNNN SRR097977.fastq >> bad_reads.txt` |
| `\|` | Send one command's output into the next command | `grep -B1 -A2 NNNNNNNNNN SRR098026.fastq \| wc -l` |
| `wc -l` | Count lines (`wc` alone: lines, words, characters) | `wc -l bad_reads.txt` |
| `less` at the end of a pipe | Scroll through long output | `grep SINGLE SraRunTable.txt \| less` |

FASTQ arithmetic: 4 lines = 1 read. Divide a FASTQ line count by 4 to get the number of reads.

**Never write into a file your wildcard also reads.** `grep ... *.fastq > bad_reads.fastq` makes `grep` read its own output and run forever. Name output files `.txt`. Press Ctrl+C if a command seems stuck.

## Variables

| Syntax | What it does | Example |
| --- | --- | --- |
| `name=value` | Set a variable (no spaces around `=`) | `foo=grape` |
| `$name` or `${name}` | Use the variable's value | `echo ${foo}` |
| `${name}_text` | Braces keep the name separate from text after it | `echo ${foo}_juice` |
| `$(command)` | Capture a command's output | `name=$(basename SRR097977.fastq .fastq)` |
| `basename file .ext` | Strip the extension from a file name | `basename SRR097977.fastq .fastq` |
| `echo` | Print text or a variable | `echo "Done"` |

## For loops

```bash
for filename in *.fastq
do
  name=$(basename ${filename} .fastq)
  echo ${name}
  head -n 2 ${filename} >> seq_info.txt
done
```

- The loop runs the commands between `do` and `done` once for every file matching `*.fastq`, with `${filename}` set to that file's name.
- While you type a loop, the prompt changes to `>`. That means the shell is waiting for `done`.
- Made a typo and can't go back? Press Ctrl+C and start again.
- Use `>>` inside a loop. `>` would overwrite the file on every pass, leaving only the last result.

## Scripts

| Command / key | What it does |
| --- | --- |
| `nano bad-reads-script.sh` | Create or open a file in the nano editor |
| Ctrl+O, then Enter | Save |
| Ctrl+X | Exit nano |
| `bash bad-reads-script.sh` | Run the script |
| `chmod +x bad-reads-script.sh` | Make the script executable |
| `./bad-reads-script.sh` | Run an executable script in the current directory |
| `ls -l` | Check for `x` in the permissions |

The lesson's script:

```bash
grep -B1 -A2 -h NNNNNNNNNN *.fastq | grep -v '^--' > scripted_bad_reads.txt
echo "Script finished!"
```

Lines starting with `#` are comments. Add one at the top of every script saying what it does.

---

*Adapted from the Data Carpentry lesson [Introduction to the Command Line for Genomics](https://datacarpentry.github.io/shell-genomics/) (CC-BY 4.0).*
