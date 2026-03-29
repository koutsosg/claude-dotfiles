---
name: developing-with-swift
description: Use this before writing any Swift code, before planning code changes and enhancements - establishes style guidelines, teaches you vital Swift techniques. Source: czottmann/agent-toolbox (rules/swift-styleguide.md + rules/modern-swift.md).
---

# Swift Styleguide
> Applies to all `**/*.swift` files.

## Indentation
Use 2 spaces for indentation; tabs are not permitted.

## Code Comments & Documentation
- Documentation comments must use triple slash (`///`)
- Double slash (`//`) is reserved for Xcode directives ("MARK:", "TODO:") and commented-out code blocks
- Double slash must **never** be used for documentation purposes

## Guard Clauses
Guard statements require multi-line formatting. When multiple conditions exist, each must appear on a separate line. A blank line must follow every guard clause.

```swift
// ❌ Bad
guard somethingCondition else { return }
guard !somethingCondition1, let something else { return }

// ✅ Good
guard somethingCondition else {
  return
}

guard !somethingCondition1,
      let something
else {
  return
}
```

## If Blocks
If statements require multi-line formatting. Multiple conditions should each occupy their own line, with the opening brace positioned on a separate line.

```swift
// ❌ Bad
if !somethingCondition1, let something {
  return
}

// ✅ Good
if !somethingCondition1,
   let something
{
  return
}
```

## switch/case
Every case block must be followed by a blank line.

---

# Modern Swift / SwiftUI Architecture

## Core Philosophy
- SwiftUI is the default UI paradigm — embrace its declarative nature
- Avoid legacy UIKit patterns and unnecessary abstractions
- Focus on simplicity, clarity, and native data flow
- Let SwiftUI handle the complexity — don't fight the framework

## State Management
For straightforward cases, use SwiftUI's native property wrappers:
- `@State` — Local, ephemeral view state
- `@Binding` — Two-way data flow between views
- `@Observable` — Shared state (iOS 17+)
- `@ObservableObject` — Legacy shared state (pre-iOS 17)
- `@Environment` — Dependency injection for app-wide concerns

For complex use cases with lots of logic and interdependent states, use The Composable Architecture (TCA).

## State Ownership
- Views own their local state unless sharing is required
- State flows down, actions flow up
- Keep state as close to where it's used as possible
- Extract shared state only when multiple views need it

## Async Patterns
- Use async/await as the default for asynchronous operations
- Leverage `.task` modifier for lifecycle-aware async work
- Avoid Combine unless absolutely necessary
- Handle errors gracefully with try/catch

## View Composition
- Build UI with small, focused views
- Extract reusable components naturally
- Use view modifiers to encapsulate common styling
- Prefer composition over inheritance

## Code Organization
- Organize by feature, not by type (avoid Views/, Models/, ViewModels/ folders)
- Keep related code together in the same file when appropriate
- Use extensions to organize large files

## Best Practices

**DO:**
- Write self-contained, focused views
- Handle loading and error states explicitly
- Test business logic separately from UI
- Leverage Swift's type system
- Use property wrappers as intended by Apple

**DON'T:**
- Create ViewModels automatically for every view
- Extract state prematurely from views
- Add abstraction layers without clear benefit
- Use Combine for simple async operations
- Fight SwiftUI's update mechanism
- Overcomplicate simple features

## Summary
Write SwiftUI code that looks and feels like SwiftUI. Trust its patterns and tools. Focus on solving user problems over architectural complexity.
