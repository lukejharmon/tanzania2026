# Course website: how to edit

The site builds automatically on GitHub Pages (Jekyll). No local setup needed.

## Change the schedule
Edit `_data/schedule.yml`. The home page and the timeline at the top of each day page are both built from it.
Each session can have an `anchor`: the id of the matching heading on the day page (`## Title {#anchor}`).

## Add material to a day
Edit `day1.md`, `day2.md`, `day4.md`. Each session follows the same pattern:

    ## Session title {#anchor}

    09:00 – 10:00
    {: .session-time}

    ### Code we used
    ```bash
    # commands with comments
    ```

    ### Cheat sheet
    | Command | What it does |
    |---|---|
    | `ls` | List files |

    ### Go further
    - Data Carpentry: [Lesson name](https://...)
    {: .lesson}

Always leave a blank line before a table or a code block.
To put a `|` inside a table cell, write `<code>a &#124; b</code>`.

## Add a new day
Copy `day4.md` to `day5.md`, change `day:` in its header, and add a matching entry (with `page: /day5.html`) to `_data/schedule.yml`.

## Announcements
Write them at the bottom of `index.md`; they appear in a box on the home page.

## Hidden files
`challenge1_answers.md` and `challenge2_answers.md` are listed under `exclude` in `_config.yml`, so they are not published. Delete a line there to publish one.

## Look and feel
All styling is in `assets/site.css`. Page templates are in `_layouts/`.
