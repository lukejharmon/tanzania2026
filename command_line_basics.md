# Shell for Genomics: Cheat Sheet

Oct 6, 2026 · @Luke Harmon

One-page command reference for the Data Carpentry [Introduction to the Command Line for Genomics](https://datacarpentry.github.io/shell-genomics/aio.html) lesson, in teaching order. Example files are the lesson's: `~/shell_data/untrimmed_fastq/` (SRR097977.fastq, SRR098026.fastq) and `~/shell_data/sra_metadata/SraRunTable.txt`.

## Getting started

Type only what comes after the `$` prompt. Never type the `$` itself.

| Command / key | What it does |
| --- | --- |
| `clear` or Ctrl+L | Clear the screen |
| Tab | Auto-complete a file or directory name; press twice to see options |
| Up / Down arrows | Scroll through previous commands |
| `history` | Numbered list of recent commands |
| `!260` | Re-run command number 260 from `history` |
| Ctrl+C | Cancel the running or half-typed command |
| Ctrl+R | Search back through command history |
| `man ls` | Manual page for a command (Space = forward, b = back, q = quit) |
| `ls --help` | Shorter help summary for most commands |

## Navigating files and directories

| Command | What it does | Example |
| --- | --- | --- |
| `pwd` | Print the directory you are in | `pwd` |
| `ls` | List contents | `ls shell_data` |
| `ls -F` | Mark directories with `/`, programs with `*` | `ls -F` |
| `ls -l` | Long listing: permissions, owner, size, date | `ls -l untrimmed_fastq` |
| `ls -a` | Include hidden files (names starting with `.`) | `ls -a` |
| `cd dir` | Move into a directory | `cd shell_data/untrimmed_fastq` |
| `cd ..` | Up one level | `cd ..` |
| `cd` or `cd ~` | Go home | `cd` |

| Symbol | Means |
| --- | --- |
| `/` at the start | Root of the file system: an absolute path, e.g. `/home/dcuser/shell_data` |
| no leading `/` | Relative path, starting from where you are now |
| `~` | Your home directory, e.g. `ls ~/shell_data` |
| `.` | The current directory |
| `..` | The parent directory, e.g. `ls ../../` |

Common stumble: `cd shell_data` fails from inside `untrimmed_fastq` because relative paths only look in the current directory. Use `cd ..` or the full path.

## Working with files

| Command | What it does | Example |
| --- | --- | --- |
| `*` wildcard | Matches any characters | `ls *.fastq`, `ls *977.fastq` |
| `cat file` | Print the whole file | `cat SRR098026.fastq` |
| `less file` | Scroll through a file, read-only | `less SRR097977.fastq` |
| `head -n N` | First N lines (default 10) | `head -n 4 SRR098026.fastq` |
| `tail -n N` | Last N lines (default 10) | `tail -n 1 SRR098026.fastq` |
| `cp src dest` | Copy | `cp SRR098026.fastq SRR098026-copy.fastq` |
| `mkdir dir` | Make a directory | `mkdir backup` |
| `mv src dest` | Move or rename | `mv SRR098026-copy.fastq backup/SRR098026-backup.fastq` |
| `rm file` | Delete, permanently | `rm -i SRR098026-backup.fastq` (asks first) |
| `rm -r dir` | Delete a directory and everything in it | `rm -r backup` |
| `chmod -w file` | Remove write permission (protect raw data) | `chmod -w SRR098026-backup.fastq` |

Inside `less`: Space = forward, b = back, g = top, G = end, `/text` = search forward, `?text` = search back, n = next match, q = quit.

The shell has no trash can. `rm` and `rm -r` cannot be undone.

A FASTQ record is 4 lines:

1. `@` header with the read ID
2. The sequence
3. `+` (sometimes the ID again)
4. Quality scores, one character per base

## Searching, redirection and loops

| Command | What it does | Example |
| --- | --- | --- |
| `grep pattern file` | Print lines containing pattern | `grep NNNNNNNNNN SRR098026.fastq` |
| `grep -B1 -A2` | Also print 1 line before, 2 after (whole FASTQ record) | `grep -B1 -A2 NNNNNNNNNN SRR098026.fastq` |
| `grep -c` | Count matching lines | `grep -c NNNNNNNNNN *.fastq` |
| `grep -i` | Ignore case | `grep -c -i single SraRunTable.txt` |
| `grep -v` | Lines that do NOT match | `grep -v '^--'` |
| `>` | Send output to a file (overwrites) | `grep PAIRED SraRunTable.txt > metadata.txt` |
| `>>` | Append to a file | `grep SINGLE SraRunTable.txt >> metadata.txt` |
| `\|` | Pipe output into the next command | `grep SINGLE SraRunTable.txt \| wc -l` |
| `wc -l` | Count lines | `wc -l bad_reads.txt` |
| `basename f .ext` | Strip the extension off a name | `basename SRR097977.fastq .fastq` |
| `echo` | Print text or a variable | `echo ${filename}` |

Never redirect into a file your wildcard also reads: `grep ... *.fastq > bad_reads.fastq` loops forever. Use a `.txt` name instead.

For loop template (Ctrl+C escapes a half-typed loop):

```bash
for filename in *.fastq
do
  name=$(basename ${filename} .fastq)
  echo ${name}
  head -n 2 ${filename} >> seq_info.txt
done
```

- `$filename` or `${filename}` reads the variable; braces keep it separate from text that follows, e.g. `${name}_2019.txt`.
- `$(command)` captures a command's output into a variable.

## Scripts and moving data

| Command / key | What it does |
| --- | --- |
| `nano file` | Open (or create) a file in the nano editor |
| Ctrl+O then Enter | Save in nano |
| Ctrl+X | Exit nano |
| Ctrl+W | Search in nano |
| `bash script.sh` | Run a script |
| `chmod +x script.sh` | Make it executable, then run with `./script.sh` |
| `which program` | Show where an installed program lives |
| `find ~ -name '*.txt'` | Find files by name |
| `wget URL` | Download a file |
| `curl -O URL` | Download a file (needs `-O` to save it) |
| `scp file user@host:/path/` | Copy a file to a remote machine |
| `scp user@host:/path/file .` | Copy a file from a remote machine |

`scp` always runs on your own laptop, not on the remote machine. Windows users without `scp` can use `pscp.exe` from PuTTY.

The lesson's script, `bad-reads-script.sh`:

```bash
grep -B1 -A2 -h NNNNNNNNNN *.fastq | grep -v '^--' > scripted_bad_reads.txt
echo "Script finished!"
```

## Project organization

Every project gets the same three folders, and raw data stays write-protected.

```bash
mkdir -p ~/dc_workshop/docs ~/dc_workshop/data ~/dc_workshop/results
ls -R ~/dc_workshop
```

| Folder | Holds |
| --- | --- |
| `data/` | Raw data, never edited (`chmod -w`) |
| `results/` | Everything your analysis produces |
| `docs/` | Notes and documentation |

Keep a log of what you ran, outside the project folder so it can rebuild the project:

```bash
history | tail -n 7 >> dc_workshop_log_2026_10_12.sh
nano dc_workshop_log_2026_10_12.sh   # add # comments, delete mistakes
```

Lines starting with `#` are comments; the shell skips them.

## Sources

- [Introduction to the Command Line for Genomics, all-in-one view](https://datacarpentry.github.io/shell-genomics/aio.html), Data Carpentry, CC-BY 4.0
