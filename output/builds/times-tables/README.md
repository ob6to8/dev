#agent-authored

# Times Tables Practice

A small practice app for a kid learning their times tables. It shows a
multiplication question, takes a typed answer, and says whether it's right or wrong.

## Use it

Open `index.html` in any browser — double-click the file, or serve the folder
(`python3 -m http.server`) and visit it. No build step, no dependencies, no network
access; it's a single self-contained HTML file that also works offline.

## How it works

- Questions are single-digit only: both numbers are between 1 and 9.
- Type an answer and press **Enter** (or click **Check**).
- Right answers say so; wrong answers show the correct product alongside what was
  entered, so the right answer is always visible before moving on.
- Press **Enter** again (or click **Next**) for a new question.
- Correct / asked / streak counters track the session. **Reset score** clears them.
- **Practice** picks between all tables mixed together or drilling a single table
  (e.g. the 7s, which appear on either side of the × sign).

Scores live in memory only — reloading the page starts a fresh session.
