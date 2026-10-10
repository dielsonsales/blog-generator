---
name: create-spec
description: Create a focused spec-driven development spec for a new project capability
argument-hint: Describe the capability, problem, or question to investigate
agent: agent
---

Create a focused spec-driven development document in the `docs/specs` folder for
this project based on the requested capability or problem.

Identify the smallest experiment that can validate the idea before proposing
broader abstractions. Follow the project's conventions and boundaries.

If the request is ambiguous, ask targeted clarification questions before
drafting the spec. Do not implement code or make any changes right away.

Produce the spec using this structure:

# [Capability or Experiment Name]

---
**Status:** Draft
**Created:** YYYY-MM-DD
**Updated:** YYYY-MM-DD
---

## Outcome
Describe the concrete outcome that should be expected.

## Problem
Explain the current limitation, uncertainty, or user need.

## Hypothesis
State a falsifiable hypothesis about what should work and why.

## Scope
List what this experiment includes.

## Out of Scope
List related work that must not be included in this experiment.

## Constraints
Include relevant technical, architectural, platform, performance, privacy, and
product constraints.

## Proposed Change
Describe the smallest implementation or investigation that can validate the
hypothesis, always respecting the project's rules.

Include:
- Relevant existing files, symbols, or documentation
- Expected data flow
- Required UI or user interaction
- Error and cancellation behavior
- Any manual device checks needed

## Acceptance Criteria
Write observable, testable criteria using this format:

- [ ] Given ..., when ..., then ...
- [ ] Given ..., when ..., then ...

Include success, failure, cancellation, empty-state, and permission-related
behavior where relevant.

## Validation Plan
Define the unit test, UI test, integration test, or manual device check required
before the task can be considered done.

## Risks and Open Questions
List unresolved questions, assumptions, and risks that could invalidate the
hypothesis.

Keep the spec concise, specific, and implementation-oriented. Avoid too many
bullet points, vague requirements, premature abstractions, and unrelated roadmap
work.
