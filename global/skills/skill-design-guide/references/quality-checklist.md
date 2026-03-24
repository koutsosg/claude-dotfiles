# Skill Quality Checklist

Use this checklist to validate your skill before and after upload.

## Before You Start

- [ ] Identified 2-3 concrete use cases
- [ ] Tools identified (built-in or MCP)
- [ ] Reviewed example skills for reference
- [ ] Planned folder structure

## During Development

- [ ] Folder named in kebab-case
- [ ] SKILL.md file exists (exact spelling, exact casing)
- [ ] YAML frontmatter has `---` delimiters
- [ ] `name` field: kebab-case, no spaces, no capitals
- [ ] `description` includes WHAT it does and WHEN to use it
- [ ] No XML angle brackets anywhere in frontmatter
- [ ] Instructions are clear and actionable
- [ ] Error handling included
- [ ] Examples provided
- [ ] References clearly linked (if using reference files)
- [ ] No README.md inside the skill folder

## Before Upload

- [ ] Tested triggering on obvious tasks
- [ ] Tested triggering on paraphrased requests
- [ ] Verified doesn't trigger on unrelated topics
- [ ] Functional tests pass
- [ ] Tool/MCP integration works (if applicable)
- [ ] Compressed as .zip file (for Claude.ai upload)

## After Upload

- [ ] Tested in real conversations
- [ ] Monitored for under/over-triggering
- [ ] Collected user feedback
- [ ] Iterated on description and instructions
- [ ] Updated version in metadata
