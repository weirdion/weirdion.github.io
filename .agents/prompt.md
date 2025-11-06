# Writing Style Guide for Blog Posts

This document captures the writing style and approach for blog posts on this site. Use this as a reference when drafting, editing, or completing blog content.

## Author Profile

Senior cloud engineer writing practical, self-documenting examples of problems solved. Not optimizing for clicks or monetization, but does consider SEO and agentic searchability to help others find solutions to similar problems.

## Core Philosophy

- **Show working code, not theory** - Complete, runnable examples over pseudo-code
- **Document problems as you solve them** - Real-world context with honest problem discovery
- **Be honest about limitations and trade-offs** - Admit when solutions aren't perfect
- **Make it useful for future self (and others)** - Self-documentation ethos
- **Balance personality with professionalism** - Conversational but technically credible

## Tone and Voice

### Technical Depth
- **Level 200-300**: Assumes baseline familiarity with tools (CDK, Git, AWS services, etc.)
- Explicitly state audience level when appropriate: "This is not meant to be start from basics tutorial... Consider this Level 200 in AWS guidance terms"
- Deep technical specifics without over-explaining basics
- Don't dumb down but also don't gatekeep

### Formality
- **Conversational yet professional** - Strike balance between casual blog and technical documentation
- Use first-person extensively: "I've been...", "My partner and I...", "I discovered..."
- Incorporate personality and humor without sacrificing credibility
- Use emoji sparingly for section headers (🤔, 🏗, ⏩, 🧪, 🛑) but rarely in body text

### Personal Voice
- Strong personal narrative: share real problems encountered
- Be honest about frustrations and challenges
- Self-documenting approach: "I'm trying to get better about writing about things I do"
- Admit limitations: "I don't have a perfect answer"
- Use personal context: homelab projects, work scenarios, real needs
- Include collaborative context: "My partner and I", "one morning we came across a fun problem"

## Content Structure

### Standard Post Pattern

1. **Hook/Context Setting** (1-3 paragraphs)
   - Personal anecdote or problem statement
   - Why this matters
   - What prompted the solution
   - Example: "My partner and I use Google Drive" or "one morning we came across a fun problem"

2. **Disclaimers/Scope Setting** (when relevant)
   - Level-setting (Level 200, etc.)
   - Conflict-of-interest disclosures in italics/bold
   - What's NOT covered
   - Work context: "I work at AWS, but this is a personal project"

3. **Overview/Architecture**
   - Visual diagram (architecture.png, featured.jpg)
   - "Project Overview" or "Architecture at a glance" section
   - High-level component summary

4. **Problem Breakdown** ("The Why 🤔")
   - Clear articulation of the problem
   - Real-world context and pain points
   - Each facet gets its own subsection if complex

5. **Solution Implementation** ("The How 🏗")
   - Numbered or clearly sectioned steps
   - Progressive complexity building
   - Code blocks with context (before/after comparisons)
   - Inline explanations of what/why/how
   - "Talk is cheap, show me the code!" transitions

6. **Testing/Validation** ("Let's test it out!" or "🧪 Testing")
   - Command examples with expected output
   - "This works!" confirmations
   - Show what success looks like

7. **Troubleshooting** (when applicable)
   - Common errors and solutions
   - "These caught me during iteration"
   - Actual error messages with fixes

8. **Production Considerations**
   - Cost breakdowns with pricing links
   - Security implications explicitly called out
   - "For PoC" vs "for prod" distinctions
   - Performance and scalability notes

9. **Closing**
   - "Future Improvements" or "Final Thoughts" section
   - Acknowledge limitations
   - Link to full code repository: "Full code is available on my Github repository"
   - Call to action for feedback
   - Humble sign-off: "Let me know if you found this useful 🙂"

## Code and Technical Details

### Code Presentation
- Use **inline code** for commands, parameters, and short snippets
- Use **multi-line blocks** for complete examples with syntax highlighting
- Show file paths and structure before code
- Include comments in code for clarity
- Show both success AND failure examples
- Include command output to show what success looks like

### Level of Detail
- Complete, working examples (not pseudo-code)
- Actual configuration files with real values
- Specific version numbers and tool names
- Links to full working repositories (GitHub/GitLab)
- Cost considerations with pricing page links
- Security best practices even in demos

### Technical Specificity
- Use real examples: ARNs, specific AWS regions, exact image URIs
- Resource naming conventions
- Progressive enhancement: basic → advanced
- Show evolution of solution through iterations

## SEO and Searchability

### Frontmatter Structure (Hugo TOML)
```toml
title = "Specific Technical Problem + Tools Used"
description = "Step-by-step guide to [outcome] using [tools], with detailed explanation"
summary = "Learn how to [benefit] with [approach]"
date = YYYY-MM-DDTHH:MM:SS-HH:00
categories = ["Broad", "Topics"]
tags = ["specific-tools", "techniques", "keywords", "hyphenated-lowercase"]
```

### Title Patterns
- Problem-focused with tools: "Deploying AWS CDK Lambda with Docker & GitLab CI"
- Question format: "When CORS Requests Turn Into Unexpected API Gateway Costs"
- Pain point focused: "Why Infrastructure as Code Feels Broken in 2025"

### Content SEO
- Headers (H2, H3) with keywords naturally included
- Lists and bullet points for scannability
- FAQ sections when appropriate
- Internal linking between related posts
- "Related [Topic] Guides" sections

## Language and Style

### Writing Patterns
- **Em-dashes and parentheticals** for asides and context
- **Bold for emphasis** on key concepts or warnings
- **Code inline** for commands, technical terms, and file names
- **Block quotes** for important questions or principles
- **Lists** (numbered for procedures, bulleted for features)
- **Tables** rarely used - prefer prose or lists

### Emoji Usage
Section headers only:
- The Why / Problem identification 🤔
- The How / Implementation 🏗
- Testing / Validation 🧪
- Troubleshooting / Gotchas 🛑
- Cost considerations 💰
- Security considerations 🔐

### Phrases and Patterns
**Opening patterns:**
- "My partner and I..."
- "One morning we came across a fun problem..."
- "I've been [doing X] for a while now..."
- "So what happened?"

**Transition phrases:**
- "Talk is cheap, show me the code!"
- "Let's test it out!"
- "This works!"
- "Here's the thing though..."
- "So where do we go from here?"

**Empathy statements:**
- "If you've been there too — I see you"
- "specially when your family relies on the running services"
- "These caught me during iteration; here's how to avoid them"

**Closing patterns:**
- "I'm trying to get better about writing about things I do"
- "Let me know if you found this useful 🙂"
- "Feel free to reach out on LinkedIn or open a GitHub issue"

## Content Types

### Tutorial/How-To Posts (60% of content)
- Clear step-by-step progression
- Before/After code comparisons
- Incremental complexity building
- Complete working examples with validation
- Repository links to full code

### Problem Analysis Posts (25% of content)
- Problem identification with multiple facets
- Each pain point gets its own section
- "So Where Do We Go From Here?" future-looking conclusions
- Empathy for reader's similar experiences
- Honest about lack of perfect solutions

### Best Practices/Awareness Posts (15% of content)
- Broader topics (security, mental health, configuration)
- List-based structure (numbered tips/mistakes)
- Personal experience grounding each point
- Practical actionable takeaways

## What NOT to Do

- ❌ Don't use emojis excessively in body text
- ❌ Don't create fluffy or clickbait content
- ❌ Don't skip cost, security, or production considerations
- ❌ Don't provide partial or pseudo-code examples
- ❌ Don't ignore limitations or pretend solutions are perfect
- ❌ Don't over-explain basics or assume zero knowledge
- ❌ Don't write without personal context or real problem framing
- ❌ Don't forget to link to working code repositories
- ❌ Don't skip the humble closing and feedback invitation

## Quality Checklist

Before publishing, ensure:
- [ ] Personal hook/context establishes why this matters
- [ ] Architecture diagram or featured image included
- [ ] Code examples are complete and tested
- [ ] Commands show expected output
- [ ] Cost considerations addressed for infrastructure
- [ ] Security implications called out explicitly
- [ ] Link to full working code repository included
- [ ] Troubleshooting section for common issues
- [ ] Future improvements acknowledged
- [ ] Frontmatter complete (title, description, summary, tags, categories)
- [ ] Headers are scannable with keywords
- [ ] Humble closing with feedback invitation

## File References and Paths

When referencing code locations, use the pattern: `file_path:line_number`

Example: "Clients are marked as failed in the `connectToServer` function in src/services/process.ts:712"

---

**Meta**: This prompt was created 2025-11-06 to capture the established writing style based on analysis of 12+ blog posts from 2024-2025.
