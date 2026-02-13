````prompt
# RPI Research Prompt

**Input:** Natural-language project request (scope, goals, constraints, target repo/project name)

Phase: research
Role: Researcher

Instructions:
- Perform read-only discovery and collect verifiable facts.
- Do not propose solutions; only report evidence-backed findings.
- Start from `.github/skills/rpi-workflow/resources/research-template.md`.
- Preserve the exact template section headings, including `## 2) Code Archaeology / Blast Radius`.
- Cite every claim using repository paths and/or external URLs.

Required output:
- `.rpi/projects/yyyymmdd-<project-slug>/research.md` following the research template and FAR validation.

Process:
1. Use the user-provided request as the authoritative objective.
2. Determine the target project ID/path in `yyyymmdd-<project-slug>` format.
	- If the project directory does not exist yet, direct the operator to run the scaffolder script to create it.
3. Produce `.rpi/projects/<project-id>/research.md` from the template with cited findings.
4. If project ID/path is missing, ask one clarifying question and stop.

Do NOT start Plan or Implementation work in this phase.
````
