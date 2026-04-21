---
name: skill-creator
version: 2.3.0
description: Create or improve a small, reusable Minis skill. Use when the user wants to build a new skill, rewrite an existing one, turn repeated instructions into a skill, or tighten a skill's trigger wording, workflow, or boundaries.
---

# Skill Creator

Create or revise a Minis skill with the **smallest reusable structure first**.

## Use When

Use this skill when the user wants to:
- create a new skill
- rewrite or clean up an existing skill
- turn repeated instructions into a reusable skill
- improve a skill's trigger wording, workflow, or boundaries

Do not use it for one-off prompts with no reuse value.

## Default Structure

Create skills under:
- `/var/minis/skills/<skill-name>/SKILL.md`

Start with:

```text
skill-name/
└── SKILL.md
```

Only add extra directories when clearly needed:
- `scripts/` — repeatable executable scripts
- `references/` — long reference material
- `assets/` — reusable templates or materials

Do not create README, changelog, or lifecycle paperwork by default.

## Core Rules

1. Start with the minimum viable skill:
   - precise `description`
   - clear workflow
   - explicit boundaries
   - action-oriented instructions

2. Only include non-obvious knowledge:
   - user-environment specifics
   - easy-to-get-wrong details
   - preferred workflow rules
   - tool, file, or edge-handling rules

3. Prefer execution over explanation:
   - ordered steps
   - concrete defaults
   - explicit decision rules
   - short examples

4. Boundaries are required:
   - what it should do
   - what it should not do
   - when to use defaults
   - when to ask briefly

Do not add governance, scoring, publish, or maintenance machinery unless the user explicitly wants that.

## Required Anatomy

Every skill must have `SKILL.md` with:
- `name`
- `description`
- goal / use case
- workflow
- boundaries
- output expectations

Keep core operating logic in `SKILL.md`. Move large supporting material to `references/` only when justified.

## Description Rule

The `description` should state:
1. what the skill does
2. when to use it
3. how the user may ask for it

Prefer:
- `Do X. Use when the user wants Y, Z, or says ...`

Weak:
- `A powerful workflow orchestration skill.`

Better:
- `Create or improve a Minis skill. Use when the user wants to build a new skill, rewrite an existing skill, or turn repeated instructions into a reusable workflow.`

## Workflow Rule

A good default workflow:
1. identify the repeated task
2. confirm it is worth making reusable
3. define the minimum viable scope
4. decide whether `SKILL.md` alone is enough
5. write frontmatter with a triggerable description
6. write the workflow and boundaries
7. add extra files only if clearly needed
8. test with 2-3 realistic user phrasings

## Boundary Rule

Include rules such as:
- do not trigger for one-off tasks with no reuse value
- do not create extra files unless execution requires them
- do not duplicate another skill's clear responsibility
- if a safe default exists, use it
- if missing information changes the core output, ask briefly

## Minis Tool Alignment

When relevant:
- use `file_write` to create files
- use `file_edit` to modify existing files
- use `shell_execute` to run commands, not to write file contents
- prefer direct tool use over narrative instructions
- name required files, paths, and scripts explicitly

## Review Checklist

Check:
- easy to trigger
- narrow enough scope
- directly executable workflow
- explicit boundaries
- justified token cost
- extra files truly necessary
- likely to be reused

## Output Style

Return:
1. what should be created or changed
2. the minimal file structure
3. the trigger description
4. the core workflow
5. boundary rules worth adding
6. only the extra files that are truly justified
