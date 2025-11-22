

## Execution Steps

1. always read `.memory/summary.md` first to understand successful outcomes so far.
2. update `AGENTS.md` to indicate which phase is being worked on and by whom.
3. If there are any `[NEEDS-HUMAN]` tasks in `.memory/todo.md`, stop and wait for human intervention.
4. follow the research guidelines above.
5. when you are blocked by actions that require human intervention, create a `.memory/todo.md` file listing the tasks that need to be done by a human. tag it with `[NEEDS-HUMAN]` on the task line.
6. after completing a phase, refer to [phase completion checklist](#phase-completion-checklist).
7. commit changes with clear messages referencing relevant files.

## Human Interaction

- If you need clarification or additional information, please ask a human for assistance.
- print a large ascii box in chat indicating that human intervention is needed, and list the tasks from `TODO.md` inside the box.
- wait for human to complete the tasks before proceeding.

## Research Guidelines

- store findings in `.memory/` directory
- all notes in `.memory/` must be in markdown format
- except for `.memory/summary.md`, all notes in `.memory/` must follow the filename convention of `.memory/<type>-<id>-<title>.md`
- where `<type>` is one of: `research`, `phase`, `guide`, `notes`, `implementation`
- Always keep `.memory/summary.md` up to date with current status, prune incorrect or outdated information.
- when finishing a phase, refer to [phase completion checklist](#phase-completion-checklist).
- use `.memory/todo.md` to track remaining tasks.
- when committing changes, follow conventional commit guidelines.
- Use clear commit messages referencing relevant files for changes.

## Documentation Guidelines

- when promoting notes from `.memory/` to `docs/`, ensure they are well-structured and formatted for clarity.
- use appropriate headings, bullet points, and code blocks to enhance readability.
- cross-reference related documents within `docs/` to create a cohesive knowledge base.
- regularly review and update documentation in `docs/` to ensure accuracy and relevance.
- when inconsistencies arise between `.memory/` notes and `docs/`, prioritize updating `docs/` to reflect the most accurate information. if in doubt, consult a human for clarification.

## Phase Completion Checklist

- [ ] Update `.memory/summary.md` with findings from the phase.
- [ ] Review accumulated notes for candidates for promotion to long term documentation in `docs/`.
- [ ] Prune outdated or incorrect information from `.memory/` notes.
- [ ] update `AGENTS.md` to indicate which phase is being worked on and by whom.
