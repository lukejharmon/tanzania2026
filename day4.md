---
layout: day
day: day4
title: "Day 4: Moving files, R, and a mock grant panel"
---

## Moving files between your laptop and the server {#moving-files}

09:00 – 09:45
{: .session-time}

Your work so far lives on a computer in the cloud. Today you will move a file **up** to it from your laptop,
and bring a file **down** to your laptop. We use `scp` ("secure copy"). It is built into both
**Mac Terminal** and **Windows PowerShell**, and the commands are exactly the same on both.

The cloud computers will be shut down after the workshop. Anything you want to keep, download today.
{: .tip}

### Step 1: Open a terminal on your laptop

This is a terminal on **your own laptop**, not the Terminal tab in RStudio.

- **Mac:** press Cmd + Space, type `Terminal`, press Enter.
- **Windows:** click Start, type `PowerShell`, and open **Windows PowerShell**. Do **not** choose *Windows PowerShell ISE*: it can't ask for passwords, so `scp` won't work there.

Check the prompt. If it starts with `dcuser@ip-...` you are on the server: open a new terminal on your laptop instead.

### Step 2: Find your server's name

`scp` needs your server's full name; the tinyurl will not work. Open your tinyurl in the browser and look at the
address bar. It shows something like:

```
http://ec2-11-22-33-44.compute-1.amazonaws.com:8787
```

Your server name is the part between `http://` and `:8787`, here `ec2-11-22-33-44.compute-1.amazonaws.com`.
Your server name is also listed in the [pairs sheet](https://docs.google.com/spreadsheets/d/1qHxClZ4czNaRe3vR5r_EFiA0GDB3H_ec172T2ExTgTQ/edit?usp=sharing).
In all the commands below, replace `SERVER` with your server name.

### Step 3: Upload a file to the server

First, download the data file for today's R lesson to your laptop:
[mouse_microbiome.csv](mouse_microbiome.csv). If your browser opens the file instead of saving it,
right-click the link and choose *Save link as* (or *Download linked file*).

Next, in your laptop terminal, go to your Downloads folder and check the file is there:

```bash
cd ~/Downloads
ls mouse_microbiome.csv
```

Now copy it up to your home folder on the server:

```bash
scp mouse_microbiome.csv dcuser@SERVER:
```

**Don't forget the colon (`:`) at the end.** Without it, `scp` doesn't connect to the server at all: it silently
makes a copy on your laptop called `dcuser@ec2-...`, with no password request.
{: .tip}

The first time, you will see `Are you sure you want to continue connecting (yes/no/[fingerprint])?`
Type `yes` and press Enter. Then type the password, `data4Carp`. **Nothing appears while you type the password.** That is normal: type it and press Enter.

Finally, check that it arrived: in RStudio, look in the **Files** pane (click the refresh arrow), or in the RStudio Terminal type `ls ~`.

### Step 4: Download a file from the server

This file is on every server. Copy it down to your laptop (the `.` at the end means "here", your Downloads folder):

```bash
scp dcuser@SERVER:shell_data/sra_metadata/SraRunTable.txt .
ls SraRunTable.txt
```

Open it in Excel, Numbers or a text editor: it is the metadata table you searched with `grep` on Tuesday.

### Cheat sheet

| Command | What it does |
|---|---|
| `scp file dcuser@SERVER:` | Upload `file` from your laptop to your home folder on the server |
| `scp dcuser@SERVER:path/to/file .` | Download a file from the server to the folder you are in |
| `scp -r dcuser@SERVER:folder .` | Download a whole folder (`-r` = recursive) |
| `cd ~/Downloads` | Go to your Downloads folder (Mac and Windows) |
| `ls` | List files (works in PowerShell too) |

Always run `scp` **on your laptop**. The laptop side is written as a plain path; the server side is `dcuser@SERVER:` followed by a path from your home folder on the server (nothing after the `:` means the home folder itself).

### If something goes wrong

| What you see | What it means | What to do |
|---|---|---|
| `No such file or directory` | You are not in the folder that has the file | `cd ~/Downloads`, then `ls` to check the file name |
| `Permission denied, please try again` | Wrong password | Type `data4Carp` again carefully (capital C) |
| `Could not resolve hostname` | Wrong server name | Copy it again from the address bar, without `http://` or `:8787` |
| No password request, and no file on the server | The `:` after the server name is missing | Add the `:` and run it again |
| Nothing happens, `Connection timed out`, `Connection reset` or `Broken pipe`, or the transfer stops partway | The internet dropped out or is too slow | Check that a web page loads, wait a minute, then run the same command again (press the up arrow to get it back) |
| No password prompt on Windows, the command hangs, or an error about the console or handle | You are in *Windows PowerShell ISE* | Close it and open **Windows PowerShell** (not ISE) |
| `Connection timed out` every time, even when the internet works | The network is blocking `scp` | Use RStudio instead (below) |
| `'scp' is not recognized` | Older Windows without scp | Use RStudio instead (below) |
| Prompt says `dcuser@ip-...` | You are typing on the server | Open a terminal on your laptop |

**Backup method using RStudio:** in the **Files** pane, click **Upload** to send a file from your laptop.
To download, tick a file, then click the gear icon (**More**) and choose **Export...**

### Go further

- Data Carpentry: [Moving and downloading data](https://datacarpentry.github.io/shell-genomics/05-writing-scripts.html#moving-and-downloading-data)
- For big files, move data directly between servers (with `wget` or `curl`) instead of through your laptop.
- [FileZilla](https://filezilla-project.org/) is a free drag-and-drop program that does the same job as `scp` (choose SFTP, port 22, with the same server name, username and password).
{: .lesson}

## Introduction to R {#intro-to-r}

09:45 – 12:15, with a short break
{: .session-time}

We will analyse the file you just uploaded: counts of DNA sequencing reads from five groups of bacteria
(phyla) in 15 mice. Each mouse was sampled twice, from the **gut** and from its **stool**.
**Question: do gut and stool samples have the same bacteria?**

### Getting started in RStudio

- **Console** (bottom left): type a command, press Enter, see the answer.
- **Script** (top left): click *File* > *New File* > *R Script*, then save it as `intro_R.R`. Type your code here so you keep it.
  Run the current line with **Ctrl + Enter** (Windows) or **Cmd + Enter** (Mac).
- **Environment** (top right): the objects you have made.
- **Files / Plots / Help** (bottom right).

Lines starting with `#` are comments: R ignores them. Use them to write notes to yourself.

### 1. R as a calculator

```r
2 + 3
10 / 4
2^5
sqrt(16)   # sqrt() is a function: the square root
```

### 2. Objects

`<-` stores a value under a name. Read it as "gets": `x <- 5` means "x gets 5".

```r
x <- 5
x
x * 2

counts <- 632
counts + 100
```

Names can contain letters, numbers, `_` and `.`, but cannot start with a number. R is case sensitive: `Counts` and `counts` are different objects.

### 3. Functions and help

A function takes **arguments** inside parentheses.

```r
round(3.14159)
round(3.14159, digits = 2)
round(3.14159, 2)    # same thing: arguments in the expected order don't need names
?round               # open the help page
```

### 4. Vectors

A vector is a list of values of the same kind. `c()` combines values into a vector.

```r
firm <- c(632, 136, 1174, 408, 831)   # Firmicutes counts from 5 mice
firm
length(firm)
mean(firm)
sum(firm)
max(firm)

firm[2]       # the 2nd value
firm[2:4]     # values 2 to 4

firm > 500          # TRUE or FALSE for each value
sum(firm > 500)     # how many are TRUE?

source <- c("Gut", "Gut", "Stool")    # text goes in quotes
class(firm)
class(source)
```

### 5. Read the data

```r
getwd()                                  # where is R looking? (should be /home/dcuser)
micro <- read.csv("mouse_microbiome.csv")

head(micro)       # first 6 rows
nrow(micro)       # number of rows: 30
ncol(micro)       # number of columns: 7
names(micro)      # column names
str(micro)        # structure: each column and its type
summary(micro)    # summary of every column
```

A **data frame** is a table: each row is a sample, each column is a vector.

If the upload didn't work, get the file directly from the course website instead:
`download.file("https://lukejharmon.github.io/tanzania2026/mouse_microbiome.csv", "mouse_microbiome.csv")`
{: .tip}

### 6. Work with columns

`$` picks out one column.

```r
micro$Firmicutes
mean(micro$Firmicutes)
median(micro$Firmicutes)

# make a new column: total reads in each sample
micro$Total <- micro$Firmicutes + micro$Proteobacteria + micro$Actinobacteria +
  micro$Bacteroidetes + micro$Other

# raw counts depend on how deeply each sample was sequenced,
# so compare proportions instead
micro$Firm_prop <- micro$Firmicutes / micro$Total
head(micro)
```

### 7. Subsetting

Square brackets choose rows and columns: `data[rows, columns]`. Leave one side empty to keep everything.

```r
micro[1, ]                                    # row 1, all columns
micro[1:3, c("Mouse", "Source", "Firm_prop")] # rows 1-3, three columns

gut   <- micro[micro$Source == "Gut", ]       # only the gut samples
stool <- micro[micro$Source == "Stool", ]     # only the stool samples
nrow(gut)

mean(gut$Firm_prop)
mean(stool$Firm_prop)

micro[micro$Firm_prop > 0.8, ]                # samples that are more than 80% Firmicutes
```

`==` asks "is it equal?" (a test). `=` and `<-` assign. Mixing them up is the most common R error.

### 8. Plots

```r
hist(micro$Firm_prop)

boxplot(Firm_prop ~ Source, data = micro)     # read ~ as "by": Firm_prop by Source

boxplot(Firm_prop ~ Source, data = micro,
        xlab = "Sample source", ylab = "Proportion Firmicutes",
        col = c("tan", "lightblue"))

plot(Bacteroidetes ~ Firmicutes, data = micro)
```

Save a plot from the **Plots** pane with *Export* > *Save as Image*.

### 9. A statistical test

```r
t.test(Firm_prop ~ Source, data = micro)
```

You should see means of about 0.16 (gut) and 0.49 (stool), with p ≈ 0.01: stool samples have a much higher proportion of Firmicutes.

**Think about it:** the same 15 mice were sampled twice. Are gut and stool samples really independent?
A **paired** test compares each mouse with itself:

```r
t.test(gut$Firm_prop, stool$Firm_prop, paired = TRUE)
```

### 10. Save your results and take them home

```r
write.csv(micro, "microbiome_results.csv", row.names = FALSE)
```

Now use what you learned this morning: in your **laptop** terminal, download it.

```bash
scp dcuser@SERVER:microbiome_results.csv .
```

Save your script too (`intro_R.R`) and download it the same way.

### 11. Let AI help you write code

AI chatbots such as [Claude](https://claude.ai), [ChatGPT](https://chatgpt.com) or [Gemini](https://gemini.google.com)
(all have free versions) can write R code for you. The trick is to tell them exactly what you have and what you want.

First, get a description of your data to paste into the chatbot:

```r
str(micro)
```

Then write a prompt like this one, pasting your own `str()` output where shown:

```
I'm using R with the ggplot2 package. I have a data frame called micro.
Here is the output of str(micro):

[paste the output here]

Each of 15 mice (column Mouse) was sampled twice: once from the gut and once
from the stool (column Source). Firm_prop is the proportion of reads from
Firmicutes. Make a publication-quality plot comparing Firm_prop between Gut and
Stool: boxplots, every sample as a point, and a line joining the two samples
from the same mouse. Use clear axis labels and a clean theme, then save it as
a PNG. Briefly explain what each line of code does.
```

The answer will look something like this. Copy it into your script and run it:

```r
library(ggplot2)

ggplot(micro, aes(x = Source, y = Firm_prop)) +
  geom_boxplot(aes(fill = Source), width = 0.5, alpha = 0.4, outlier.shape = NA) +
  geom_line(aes(group = Mouse), colour = "grey60") +      # join each mouse's two samples
  geom_point(aes(colour = Source), size = 3) +
  scale_fill_manual(values = c(Gut = "#E69F00", Stool = "#0072B2")) +
  scale_colour_manual(values = c(Gut = "#E69F00", Stool = "#0072B2")) +
  labs(x = "Sample source",
       y = "Proportion of reads from Firmicutes",
       title = "Firmicutes in gut and stool samples",
       subtitle = "Lines join the two samples from the same mouse") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")

ggsave("firmicutes_gut_vs_stool.png", width = 6, height = 5, dpi = 300)
```

The lines show something the boxplot hides: which samples belong together. In 9 of the 15 mice the stool sample has
more Firmicutes than the gut sample, some by a lot. Because the samples come in pairs, the paired test in section 9 is the right one. Download your PNG with `scp`, like the CSV in section 10.

**Using AI well:**

- **Run it and look.** Does the plot show what you asked for? Here: does each line really join the same mouse?
- **Read the code.** Ask the AI to explain any line you don't understand. You are responsible for code you use.
- **Paste errors back.** If the code fails, copy the error message into the chat and ask what went wrong.
- **Expect confident mistakes.** AI can invent column names, functions or packages, and choose the wrong statistical test. Check against your data and your question.
- **Check whether you're allowed.** Patient data, human genomic data, peer review material and other people's unpublished data often come with rules about where they can go. If in doubt, describe the data (like `str()`) rather than pasting it.
- **Be open about it.** Many journals ask you to say how you used AI; check their rules.

**Try it:** ask the AI to change the plot so the lines are coloured by whether Firmicutes went up or down from gut to stool.
Or ask for a stacked bar chart showing all five phyla for every sample.

### Cheat sheet

| Code | What it does |
|---|---|
| `x <- 5` | Store a value in an object |
| `c(1, 2, 3)` | Combine values into a vector |
| `mean()`, `median()`, `sum()`, `max()`, `length()` | Summaries of a vector |
| `?mean` | Help for a function |
| `read.csv("file.csv")` | Read a CSV file into a data frame |
| `head()`, `str()`, `summary()`, `nrow()`, `names()` | Look at a data frame |
| `data$column` | One column of a data frame |
| `data[rows, columns]` | Choose rows and columns |
| `data[data$Source == "Gut", ]` | Rows that match a condition |
| `hist()`, `boxplot(y ~ group, data = )`, `plot(y ~ x, data = )` | Basic plots |
| `t.test(y ~ group, data = )` | Compare two group means |
| `write.csv(data, "file.csv", row.names = FALSE)` | Save a data frame to a file |

### Stretch: back to the variant calls

The variants from the pipeline in the slides are already on your server.
Explore them with the same tools:

```r
variants <- read.csv("~/r_data/combined_tidy_vcf.csv")
dim(variants)                       # how many variants, how many columns?
table(variants$sample_id)           # variants found in each strain
mean(variants$DP)                   # average read depth at each variant
hist(variants$DP)
boxplot(DP ~ sample_id, data = variants)
```

Why does one strain have so many more variants than the others? (Hint: look up the Lenski
experiment in the [Background and Metadata](https://datacarpentry.github.io/wrangling-genomics/01-background.html) lesson.)

### Go further

- Data Carpentry: [Intro to R and RStudio for Genomics](https://datacarpentry.github.io/genomics-r-intro/), which uses the variant data above
- Keep using R after the workshop: install [R](https://cran.r-project.org/) and [RStudio Desktop](https://posit.co/download/rstudio-desktop/) on your laptop (both free), or use [Posit Cloud](https://posit.cloud/) in your browser
- [R exercises 1 to 4](resources.html#r-exercises) on the Resources page
{: .lesson}

## Mock grant review panel {#mock-grant-panel}

14:00 – 16:00
{: .session-time}

A mock review panel, following up on Tuesday's Specific Aims activity and homework.

- [Examples of NIH Specific Aims](specific_aims_examples.html)
- [How to tell your story](tellStory.pdf), Christine Parent (slides, PDF)
- [Elements of a successful grant application](balemba_nih_grant_writing.pdf), Onesmo Balemba (slides, PDF)
- [NIH R01 funding announcement, PA-25-301](PA-25-301%20R01.pdf) (PDF)

## Wrap-up {#wrap-up}

16:00 – 17:00
{: .session-time}

This week you:

- navigated a remote Linux computer from the command line
- searched, counted and combined files with `grep`, `wc`, pipes and redirection
- automated repeated work with loops
- checked sequencing quality with FastQC
- saw how a variant-calling pipeline turns reads into variants
- moved files between your laptop and a server with `scp`
- read, summarised, plotted and tested data in R

To carry on where we stopped (trimming, alignment, variant calling, microbiome analysis and more R), see [Keep going](keep-going.html).

Before you leave: download anything you want to keep from your cloud computer. Everything from the week is on the
[Resources](resources.html) page, which stays online.
