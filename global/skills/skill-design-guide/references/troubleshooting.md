# Troubleshooting

## Upload Errors

### "Could not find SKILL.md in uploaded folder"

**Cause:** File not named exactly `SKILL.md` (case-sensitive).

**Solution:**
- Rename to `SKILL.md` exactly
- Verify with: `ls -la` should show `SKILL.md`
- Common mistakes: `SKILL.MD`, `skill.md`, `Skill.md`

### "Invalid frontmatter"

**Cause:** YAML formatting issue.

**Common mistakes:**
```yaml
# Wrong — missing delimiters
name: my-skill
description: Does things

# Wrong — unclosed quotes
name: my-skill
description: "Does things

# Correct
---
name: my-skill
description: Does things
---
```

### "Invalid skill name"

**Cause:** Name has spaces, capitals, or reserved words.

```yaml
# Wrong
name: My Cool Skill

# Correct
name: my-cool-skill
```

---

## Triggering Issues

### Skill doesn't trigger (under-triggering)

**Symptom:** Skill never loads automatically.

**Quick checklist:**
- Is the description too generic? ("Helps with projects" won't trigger reliably)
- Does it include trigger phrases users would actually say?
- Does it mention relevant file types if applicable?

**Fix:** Revise the description field. Add more trigger phrases, keywords,
and specific task descriptions.

**Debugging approach:** Ask Claude "When would you use the [skill name] skill?"
Claude will quote the description back. Adjust based on what's missing.

### Skill triggers too often (over-triggering)

**Symptom:** Skill loads for unrelated queries.

**Solutions:**

1. Add negative triggers:
```yaml
description: Advanced data analysis for CSV files. Use for statistical
  modeling, regression, clustering. Do NOT use for simple data exploration
  (use data-viz skill instead).
```

2. Be more specific:
```yaml
# Too broad
description: Processes documents

# Better
description: Processes PDF legal documents for contract review
```

3. Clarify scope:
```yaml
description: PayFlow payment processing for e-commerce. Use specifically
  for online payment workflows, not for general financial queries.
```

---

## MCP Connection Issues

**Symptom:** Skill loads but MCP calls fail.

**Checklist:**

1. **Verify MCP server is connected**
   - Claude.ai: Settings > Extensions > [Your Service] — should show "Connected"
   - Claude Code: check MCP configuration

2. **Check authentication**
   - API keys valid and not expired
   - Proper permissions/scopes granted
   - OAuth tokens refreshed

3. **Test MCP independently**
   - Ask Claude to call MCP directly without the skill
   - "Use [Service] MCP to fetch my projects"
   - If this fails, the issue is MCP configuration, not the skill

4. **Verify tool names**
   - Skill references correct MCP tool names
   - Tool names are case-sensitive
   - Check MCP server documentation for exact names

---

## Instructions Not Followed

**Symptom:** Skill loads but Claude doesn't follow instructions.

### Cause 1: Instructions too verbose
- Keep instructions concise
- Use bullet points and numbered lists
- Move detailed reference to separate files in `references/`

### Cause 2: Instructions buried
- Put critical instructions at the top
- Use clear headers like `## Important` or `## Critical`
- Repeat key points if needed

### Cause 3: Ambiguous language
```markdown
# Bad
Make sure to validate things properly

# Good
CRITICAL: Before calling create_project, verify:
- Project name is non-empty
- At least one team member assigned
- Start date is not in the past
```

### Cause 4: Model laziness
Add explicit encouragement (more effective in user prompts than in SKILL.md):
```markdown
## Performance Notes
- Take your time to do this thoroughly
- Quality is more important than speed
- Do not skip validation steps
```

### Advanced technique
For critical validations, bundle a script that performs checks
programmatically rather than relying on language instructions. Code is
deterministic; language interpretation is not.

---

## Large Context Issues

**Symptom:** Skill seems slow or responses are degraded.

**Causes:**
- Skill content too large
- Too many skills enabled simultaneously
- All content loaded instead of using progressive disclosure

**Solutions:**

1. **Optimize SKILL.md size**
   - Move detailed docs to `references/`
   - Link to references instead of inlining
   - Keep SKILL.md under 5,000 words

2. **Reduce enabled skills**
   - Evaluate if you have more than 20-50 skills enabled simultaneously
   - Consider selective enablement
   - Group related capabilities into skill "packs"
