---
name: warn-no-typescript-any
enabled: true
event: file
conditions:
  - field: file_path
    operator: regex_match
    pattern: \.(ts|tsx)$
  - field: new_text
    operator: regex_match
    pattern: :\s*any\b|as\s+any\b|<any>
---

**TypeScript `any` detected!**

This project uses strict TypeScript — `any` is not allowed.

**Common alternatives:**
- `unknown` — for truly unknown types (requires type narrowing)
- `Record<string, unknown>` — for dynamic objects
- A proper interface/type definition
- Generics: `<T>` instead of `any`

**Quick fixes:**
```ts
// Instead of:
const data: any = response.data

// Use:
const data: unknown = response.data
// or define the type:
const data: StrapiResponse<Lesson> = response.data
```

Do not use `any` unless absolutely unavoidable and with an explicit comment explaining why.
