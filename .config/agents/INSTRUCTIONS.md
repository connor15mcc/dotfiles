# Personal Rules

Every rule below is a gate. Read the TRIGGER. If the trigger matches, apply the
ACTION. If a SKIP line matches, ignore the gate.

## Gate: Version control

TRIGGER: You need to read, record, or change version control state.

ACTION:

1. Use `jj`. Never use `git`. This includes `git commit`, `git branch`,
   `git checkout`, `git add`, and `git stash`.
2. Make every change in the working-copy change `@`. Edit the files. `jj`
   records the edits in `@` automatically.
3. Run only read-only `jj` commands, for example `jj log`, `jj diff`, `jj show`,
   `jj status`, and `jj op log`.
4. Before a command that changes history or bookmarks, ask the user. Examples:
   `jj new`, `jj describe`, `jj squash`, `jj rebase`, `jj abandon`,
   `jj bookmark set`, `jj git push`.
5. If the user asks for separate, stacked, or merged changes, put each
   dependency in the jj graph. Never leave dependent changes as siblings and
   describe the dependency in text.
   - If change B needs change A to work, make A an ancestor of B. Examples: B
     calls code that A adds, or the test in B needs a helper from A.
   - If changes are independent, make them siblings. Join them with a merge
     change.
6. Keep an empty, undescribed change at the top of the stack. Make it the
   working-copy change `@`.
   - After you finish a change, run `jj new` to create the empty change above
     it. Do not ask the user first.
   - If `@` is a described change, run `jj new` before you edit files. Do not
     ask the user first.
   - Never work in the megamerge change itself.
   - Never leave `@` on a described change when you stop work.

SKIP: The user explicitly names the command or the target change.

## Gate: Write or change code

TRIGGER: You add code, or you change the behavior of code.

ACTION: Use a TDD flow. Write the failing test first. Run the test. Then write
the code.

SKIP: Documentation, configuration, and refactors that keep the same behavior.

## Gate: Type a comment in a source file

TRIGGER: You are about to type a comment character in a source file.

ACTION: Delete the comment. Keep the comment only if the code cannot carry the
fact. If the comment stays, use present tense.

NEVER: Decorative or marker comments, for example `# ---- helpers ----`.

## Gate: You do not know a fact

TRIGGER: You do not know an API, a convention, a version, or a value, and you
are about to write it from memory.

ACTION: Never guess. Search `~/src` first. Then search Sourcegraph. Name the
file or the link that supports the choice.

## Gate: Delegate work

TRIGGER: A task needs a subagent.

ACTION: Spawn the subagent directly. Never use workflows.

## Gate: Write technical text

TRIGGER: You write a pull request description, documentation, a README, a
runbook, a procedure, an error message, release notes, or a report.

SKIP: Marketing copy and brand writing.

ACTION: Apply the ASD-STE100 Simplified Technical English rules below.

### Step 1: Classify the passage

Procedural text tells the reader what to do:

- Imperative mood.
- Maximum 20 words per sentence.
- One instruction per sentence.

Descriptive text explains:

- Simple tenses.
- Maximum 25 words per sentence.
- One topic per paragraph, maximum six sentences.

Never mix the two types in one passage.

### Step 2: Verbs

- Allowed forms: infinitive, imperative, simple present, simple past, simple
  future, past participle as an adjective.
- No present perfect. Write "completed" instead of "has completed".
- No "-ing" verb forms. Write a new sentence instead of ", making it easy".
- Active voice. Use passive voice only in descriptive text when the agent is
  unknown.
- Allowed modals: can, will, must.
- Banned modals: should, would, may, might, could. For "should", write "must" if
  the action is required. Delete the sentence if the action is optional.

### Step 3: Sentences

- No contractions. Keep the articles. Keep "that", for example "make sure that
  the file exists".
- Put the condition before the command, with a comma: "If the test fails, read
  the log."
- No semicolons. Write two sentences.
- Use a vertical list for more than two items or steps.

### Step 4: Words

- One word, one meaning, for the whole document.
- Use "make sure that" for the check, verify, and confirm concept. The
  dictionary rejects all three words as verbs.
- Noun chains of maximum three words. Break a longer chain with prepositions,
  for example "the timeout value for the connection pool".
- Delete words that carry no fact: simply, seamlessly, robust, powerful,
  comprehensive, leverage, "in order to", "it is worth noting".
- Replace: utilize → use, prior to → before, in the event that → if, e.g. → for
  example.
- American spelling.

### Step 5: Warnings

Put the command or the condition first, then the risk: "Do not run this against
production. The command deletes rows."

### Never touch

- Code blocks, identifiers, CLI commands, file paths, quoted error messages, and
  product names. Each one counts as one word toward the sentence limits.
- Facts. If the source gives no number and no cause, keep the general statement.
  Do not invent specifics.

### Self-check before you return the text

1. Scan for contractions, "has been", "should", ", making", and semicolons.
2. Count the words in your three longest sentences. Split every sentence over
   the limit.
3. Collapse synonym rotation to one word.
