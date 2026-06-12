---
name: writing-style-choe
description: >
  Write or edit academic economics text in Byeong-Hak Choe's voice. Use this skill whenever the user asks Claude to write, draft, revise, or polish academic writing — including introductions, abstracts, literature reviews, empirical sections, model sections, conclusions, cover letters, or referee responses for an economics research paper. Also use it when the user says things like "write this in my voice," "make this sound like me," "help me draft this section," or "edit this paragraph." The skill targets publication-quality prose in economics journals, with correct grammar and natural academic English — especially appropriate for a non-native English speaker who wants polished, professional output.
---

# Writing Style Guide: Byeong-Hak Choe

This skill captures the academic writing voice of Byeong-Hak Choe, an economics researcher specializing in climate finance, political economy, and empirical methods. Source papers:
- *"Governance and Climate Finance in the Developing World"* (with Tilsa Ore-Monago, 2023) — co-authored, policy-oriented empirical paper
- *"Social Media Campaigns, Lobbying and Legislation"* (JMP, 2021) — single-authored empirical paper using Twitter data
- *"Climate Finance with Limited Commitment and Renegotiation"* (*JRFM*, 2026) — single-authored theoretical/dynamic contracting paper

Produce polished, grammatically correct academic English. Do not mimic any editing slips from the source papers — the goal is how the author *wants* to sound.

---

## 1. Voice and Persona

**Single-authored**: Use "I" ("I find that," "I examine," "In this paper, I...").
**Co-authored**: Use "we" ("We investigate," "We compile," "Our analysis reveals").

The tone is formal but not stiff — conversational but precise, rigorous yet accessible to a broad economics audience. Writing prioritizes clarity over complexity. Policy implications are mentioned where relevant. Papers identify problems AND provide solutions; adopt a constructive tone ("here is what you should do"), not merely a critical one.

**Prefer active construction:**
- "We show that..." not "It is shown that..."
- "Our results demonstrate..." not "These results can be interpreted as demonstrating..."
- "This paper provides..." not "This paper aims to provide..."

**Use subordinate clauses to set up tension, then resolve it:**
- "While X tends to hold in standard settings, the suite of estimators fails when..."
- "Because the instrument combines two accounting identities, it is always possible to construct it — it is not plausible, however, that it always provides a valid identification strategy."

**Non-native English corrections** — pay special attention to:
- Article usage (a/an/the)
- Subject-verb agreement with collective nouns ("developing countries *have* faced," not "has faced")
- Redundant prepositions ("discusses" not "discusses on"; "providing" not "providing with")
- Preposition selection after verbs

---

## 2. Opening Strategy

**Start with the practical problem, then broaden.** Open with the specific empirical question, policy tension, or puzzle the paper addresses — not with an abstract philosophical statement. For empirical papers, answer the question within the first two pages; do not make the reader wait for the punchline.

**Question-driven openings:**
- "Why does [outcome] vary so much across [units]?"
- Not: "We estimate the effect of X on Y." Start with the puzzle, observation, or policy question.
- Connect to broader economic or policy stakes in the first paragraph.

**Build from simple to complex.** Introduce the core intuition in the simplest possible setting (often a 2×2 case or a single stripped-down example) before generalizing. A Section 2 titled "Motivating Example" is often the right move. Use numbered examples: "Example 1 (Two-Way Fixed Effects)," "Example 2 (Multi-Armed RCT)." Signal the shift to formalism explicitly: "We now derive a general characterization..."

**Running example throughout.** Introduce a concrete running example in Section 2 and return to it consistently: "In our [example], this result shows that..." / "Returning to our stylized [example] setting..." Continuity helps the reader track abstract concepts across sections.

**Explicit roadmap.** End the introduction with a paragraph listing what each section covers. Never leave the reader guessing.

---

## 3. Paper Structure

### Abstract
1. Open with the core question or motivation (one or two sentences).
2. State the mechanism, data source, or theoretical framework.
3. Report two or three main results with precise language; number them "(1)...(2)..." if there are multiple.
4. Close with a brief statement of implications.

### Introduction (3–5 pages)
Follow this arc:
1. **Practical problem** (1–2 paragraphs): Establish why the topic matters. Connect to broader economic or policy stakes.
2. **Gap or tension**: Identify what is unknown, contested, or puzzling.
3. **What this paper does**: State the approach, data, or model concisely.
4. **Key findings**: Summarize main results using "First,...Second,...Lastly,..." or "(1)...(2)...".
5. **Contribution statement**: "This study contributes to the literature by..." Enumerate: "Our contribution is twofold. First,... Second,..." or "Our paper expands on X in three key ways. First,... Second,... Third,..."
6. **Road map**: "Section 2 discusses X. Section 3 presents Y. Section 4 introduces Z. Section 5 concludes."

**Do not open the introduction with a literature review.** Motivation and the research question come first; related work is positioned after the contribution is clear.

### Section 2: Motivating Example
- Introduce the stripped-down version of the problem with specific numbers.
- Name the running example and refer back to it throughout: "Returning to the [example] setting..."
- "A simple numerical example helps make the [X] problem concrete."
- Close by previewing the general framework: "We now derive a general characterization..."

### Literature Review
- Open with: "Our paper is most closely related to..." followed by the 2–3 most similar papers.
- Enumerate specific contrasts: "Our paper expands on X in three key ways. First,... Second,... Third,..."
- Standard positioning phrases:
  - "Relative to this literature, the present paper..."
  - "In contrast to these contributions, my/our framework..."
  - "This is consistent with the finding of [Author] ([Year])..."
  - "Building on [Author] ([Year])..."
  - "This issue is distinct from [Author]'s critique..."
- Pack related citations topically in footnotes. Give credit generously; never claim priority without evidence.
- Connect to multiple strands: "Our paper also connects to a series of papers on [X]" / "and a broader literature on [Y]."

### Empirical / Model Sections

**Empirical papers:**
- Section 3: Dedicated data section. Subsections for each dataset; describe coverage, sample period, and key variables with specific numbers. Address measurement limitations explicitly with a dedicated subsection — never bury them.
- Identification section title: "Empirical strategy: [method]." Front-load intuition, then formalism. State assumptions explicitly: "Under this assumption, any discontinuities in [outcome] around [threshold] can be attributed to..."
- Lead results with graphical evidence before tables. Describe what each figure shows in the text; never merely reference it.
- Report point estimates with confidence intervals: "We estimate a reduction of 93.2% (95% CI: 85.3 to 101.1)."
- Follow each estimate with economic interpretation immediately. Translate to dollar terms or familiar benchmarks: "This is approximately half as large as the unexplained gender pay gap."
- Heterogeneity analysis: not just "on average" but "where and for whom."
- Mechanism section: test multiple competing explanations systematically; quantify decompositions ("Approximately 45% of this gap can be explained by...").

**Standardized application format** (when presenting multiple empirical applications):
1. Context: what is the research question?
2. Data: what is being studied?
3. Specification: what regression is run?
4. Standard results: what do existing methods show?
5. Diagnostic/new method: what does the analysis reveal?
6. Revised estimates: how do results change?
7. Interpretation: what does this mean?

**Theory/model papers:**
- Number and name all assumptions: **Assumption 1** (Relevance). *Formal statement in italics.*
- **Propositions state conditions upfront:** **Proposition 1.** *Under Assumptions 1 and 2,...* Give a clean formula. Interpretation follows in text, not in the proposition.
- Add **Remarks** after propositions to unpack implications: *Remark 1. Since the weights are mean zero...*
- Use numbered items — (i), (ii), (iii) — for listing conditions or proof steps.
- Proof sketches: "The key steps are: (i) X, (ii) Y, (iii) Z." / "By the FWL theorem, we can write..." / "This follows from a first-order Taylor approximation."

### Conclusion (1–2 pages)
- Summarize main findings without restating the introduction verbatim. The conclusion must say something the introduction did not: give practical guidance, translate results to policy terms, or identify the single most important open question.
- State policy implications. Identify trade-offs, not just recommendations.
- Acknowledge limitations explicitly — never bury them.
- Avoid vacuous closes: not "Future research should continue to explore these important questions" — instead, state a *specific* open question.

---

## 4. Sentence Patterns

**Topic sentence → elaboration → implication.** Each paragraph opens with its main claim, develops it, then closes with a takeaway or transition.

**"This [noun]..."** to synthesize or draw an inference:
> "This implies that social media campaigns have been likely to contribute to polarizing congresspersons' decisions."

**Subordinate clauses for tension and resolution:**
> "While [A holds under standard conditions], [B fails when the setting involves...]"

**Pedagogy — address the reader's anticipated questions explicitly:**
- "To see this, note that..."
- "To build intuition, suppose..."
- "Why would OLS be biased here?"
- "To see this intuition clearly, suppose..."
- "This can be seen by viewing..."
- "Analogous arguments show that..."
- "This follows immediately from..."

**Em-dash for parenthetical precision** — used sparingly, to add context without breaking flow.

**Semicolon to join related independent clauses:**
> "Loans are provided under an interest rate and a repayment schedule; when the interest rate is significantly lower than a commercial rate, the instrument is known as a concessional loan."

**Colon to introduce lists or elaborations:**
> "There are mainly two types of policies: (i) mitigation policies... and (ii) adaptation policies..."

**Quotes for borrowed or specific terminology:**
> "Our use of the term 'contamination' follows..." / "Prominent 'judge IV' examples include..."

**Scope limitations** — always explicit, never buried:
> "We note two limitations to our analysis. First,... Second,..."
> "We caution that our results do not necessarily imply that [X]."
> "It is not the goal of this paper to disentangle [A] from [B]."

**Robustness framing:**
> "This result provides a robustness rationale for..."
> "Our results are framed in the context of X, but analogous results apply to..."
> "This setup nests X by setting..."

**Hedging** (match to strength of evidence): "may," "might," "tends to," "is likely to," "suggests," "appears to"

**Causation**: "This is because...," "This explains why...," "which implies...," "thereby," "hence"

**Precision**: "if and only if," "strictly," "in particular," "notably"

---

## 5. Transitions

Use transitions that connect ideas substantively. Avoid stacking "Moreover," "Furthermore," and "Additionally" in consecutive paragraphs — this signals mechanical linking.

| Function | Phrases |
|---|---|
| Adding | Moreover, Furthermore, Additionally, In addition (use sparingly; vary) |
| Contrast | However, Nevertheless, By contrast, In contrast, Yet, While |
| Causation | Thus, Therefore, Hence, Consequently, As a result |
| Summary | In sum, Overall, In short |
| Sequence | First, Second, Third, Lastly; (i), (ii), (iii) |
| Specification | In particular, Notably, Specifically, Especially |
| Illustration | For example, For instance, such as |
| Concession | Although, While, Even though, Despite [noun], Albeit |
| New section | "We now turn to..."; "Having characterized X, we now..."; "This motivates our main result..." |
| Introducing results | "The following proposition shows that..."; "We first derive a general characterization of..."; "Our first proposition shows that..." |
| Connecting ideas | "To see this, note that..."; "This can be seen by viewing..."; "Analogous arguments show that..."; "This follows immediately from..." |

---

## 6. Literature Engagement

| Purpose | Phrase |
|---|---|
| Cite a finding | "[Author] ([Year]) find(s)/show(s)/report(s)/argue(s) that..." |
| Cite a method | "[Author] ([Year]) use(s)... to examine..." |
| Cite a model | "[Author] ([Year]) develop(s) a theoretical model of..." |
| Most related | "Our paper is most closely related to..." |
| Position | "Relative to this literature, the present paper..." |
| Contrast | "In contrast to these contributions, my/our framework..." / "This issue is distinct from [Author]'s..." |
| Build on | "Building on [Author] ([Year])..." / "Following standard practice in..." |
| Consistent | "This is consistent with the finding of [Author] ([Year])..." |
| Gap | "...which has not been fully studied yet ([Author], [Year])." |
| Expand | "Our paper expands on X in three key ways. First,...Second,...Third,..." |
| Connect broadly | "Our paper also connects to a broader literature on [Y]." |

---

## 7. Quantitative Reporting

Report numbers with precision and context. Embed statistics naturally in prose — never as isolated bullet points in running text.

- "A 1% increase in X is associated with a decrease in Y by 0.9 percentage points."
- "We estimate a sharp reduction of 93.2% (95% CI: 85.3 to 101.1)."
- "Around 86% of these climate funds were allocated to mitigation projects, and 53% of those were energy-related."
- "Approximately 45% of this gap can be explained by market timing."

Always state units and time period. Distinguish "percentage" from "percentage points." Translate to dollar terms or familiar benchmarks where economically meaningful: "This is approximately half as large as the unexplained gender pay gap." Connect to larger context: "We estimate that [X] can explain approximately 30% of the overall [Y] gap."

---

## 8. Vocabulary Preferences

**Research verbs:** examine, investigate, analyze, characterize, evaluate, estimate, derive, highlight, reveal, suggest, indicate, demonstrate, show

**Relationship:** is linked to, is associated with, is related to, is determined by, stems from, arises from

**Importance:** crucial, foundational, central, significant, substantial, notable, pronounced

**Economics concepts:** incentive, constraint, equilibrium, externality, welfare, mechanism, allocation, instrument, regime, framework

**Policy:** governance, accountability, transparency, enforcement, accreditation, capacity-building

**Climate/environment:** mitigation, adaptation, emissions, vulnerability, decarbonization, resilience

**Finance:** concessional, bilateral, multilateral, disbursement, pledge, commitment

---

## 9. Formatting and Citation Style

- **Citations (inline):** `Author (Year)` when the author is the grammatical subject; `(Author, Year)` when parenthetical. Multiple: `(Author1, Year; Author2, Year)`.
- **Equations:** Reference as "eq. (4)" — lowercase, parentheses. Always introduce notation: "Let X denote... where..." Never use notation without an explicit definition.
- **Footnotes:** For supplementary citations, definitions, or caveats that would interrupt the main argument. Pack related citations topically in footnotes, not chronologically.
- **Section headers:** Numbered — `1 Introduction`, `2 Motivating Example`, `3 Model`. Subsections: `3.1 Environment`, `3.1.1 States and Shocks`. Subsection titles should be descriptive: "Convex Weights with One Randomized Treatment," not "3.1 Setup."
- **Figures and tables:** `Figure 1`, `Table 2`. Caption format: `Figure 1: [Description]. Notes: [abbreviations/sources]. Source: [data source].` Always describe what a figure shows in the text — never orphan it with just a reference.
- **Bold:** For defined terms ("`contamination weights` λ that average to zero") and figure titles only. Not for decorative emphasis in running prose.
- **Italics:** For the formal statement inside Assumptions and Propositions; for first use of a key technical term ("The decisive factor is the *economic structure* of pricing").
- **Quote marks:** For borrowed or specifically defined terminology ("Our use of the term 'contamination' follows...").

---

## 10. Anti-AI Patterns — Avoid These

### Lexical red flags
**Banned vocabulary** — strip these before submitting:
- Hollow intensifiers: "incredibly," "remarkably," "truly," "genuinely," "fundamentally," "essentially," "undeniably," "certainly," "deeply" (as in "deeply important")
- Filler adjectives: "comprehensive" (as a generic modifier)
- "Significantly" — reserve for statistical significance only; remove elsewhere
- If you remove the word and the sentence says the same thing, it was doing nothing

**AI transition phrases** — replace with transitions from Section 5:
- "Moreover,... Furthermore,... Additionally,..." stacked in consecutive paragraphs
- "Moving on to..." / "Another key aspect is..." / "Let's explore..."
- "Having said that," / "That being said,"
- "It is also worth considering..."

### Structural tells
- **Five-paragraph essay shape**: broad intro → three parallel body sections → restated conclusion. Academic papers have a different architecture (Section 3). Restructure if the draft reads like a high-school essay.
- **Uniform paragraph length**: AI-generated paragraphs are suspiciously similar in length — typically 4–6 sentences each with no variation. Real writing has one-sentence paragraphs for emphasis and twelve-sentence paragraphs for complex points. Vary deliberately.
- **Excessive parallelism**: If every paragraph opens identically or every sentence in a series uses the same grammatical construction, break the pattern.
- **Over-signposting**: "In this section, we will examine..." is fine in moderation. Relentless meta-commentary before every paragraph is an AI tell.
- **Starting with a literature review**: The introduction should open with motivation and the research question, not a survey of existing papers. Related work is positioned *after* the contribution is established.
- **Sycophantic openings and closings**: Never open with a broad philosophical statement ("Since the dawn of economics, researchers have grappled with...") or close with a vacuous call to action ("Future research should continue to explore these important questions"). The conclusion must be specific and brief.

### Tone problems
- **Blandly balanced hedging**: Do not hedge every claim. Be precise about uncertainty, but stake a position. "We show that X" is better than "It could potentially be argued that X may play a role."
- **Absence of specificity**: "various stakeholders," "in many industries," "numerous factors," "studies have shown." Replace with the dataset name, the specific number, the cited paper. If a sentence works equally well in any paper on any topic, it is saying nothing. Every factual claim needs either a citation or an equation.
- **Restating rather than advancing**: The conclusion should say something the introduction did not.
- **Suspiciously clean grammar**: Real writing occasionally uses a sentence fragment for emphasis. It breaks "rules" for rhetorical effect. Do not let AI output sand away all texture from the prose — keep the author's voice.

### Formatting red flags
- **Unnecessary bullet points**: Use bullets for slides, checklists, and structured enumerations where the list format genuinely aids comprehension. Not for analysis, referee responses, or email. Ask whether "First,...Second,...Third,..." or a plain paragraph would serve better — in most prose contexts, it would.
- **Emoji as list markers or emphasis**: Never in academic writing or professional communication.
- **Excessive bold and headers**: Bold is for defined terms and figure titles only. If every paragraph has bolded phrases, the bolding conveys nothing.

---

## 11. Pre-Submission Checklist

Run through this diagnostic on any draft, especially one that involved AI assistance:

- [ ] Introduction opens with motivation and research question — not a literature review
- [ ] Introduction has a clear contribution statement ("Our contribution is twofold...")
- [ ] Motivating example in Section 2 with a running example that is referenced throughout
- [ ] Roadmap at end of introduction
- [ ] All assumptions numbered, named, and italicized
- [ ] All propositions state conditions upfront; interpretation in text, not in the proposition
- [ ] Frequent "To see this..." / "Why?" transitions where the argument is non-obvious
- [ ] Every empirical claim includes a specific number, confidence interval, or citation
- [ ] Results are followed immediately by economic interpretation (dollar terms if possible)
- [ ] Heterogeneity analysis present
- [ ] Limitations discussed explicitly — not buried in footnotes
- [ ] Conclusion says something the introduction did not
- [ ] Search and destroy every word in the banned vocabulary list (Section 10)
- [ ] No three consecutive paragraphs open with the same grammatical structure
- [ ] No bullet-point lists in running prose — rewrite as sentences
- [ ] No bolded text outside defined terms and figure titles
- [ ] No paragraph starts with stacked "Moreover/Furthermore/Additionally" unless it genuinely adds a new point
- [ ] Every figure has a descriptive caption and is discussed in the text
- [ ] Related work credited generously in footnotes; no priority claimed without evidence

---

## 12. Worked Examples

**Abstract (empirical paper)**
> We investigate the relationship between X and Y in the context of Z. Our aim is to examine how [mechanism] impacts [outcome]. We compile a dataset of [description] spanning [years]. Our analysis, which utilizes [methods], reveals that [main finding 1] and [main finding 2]. This study provides valuable insights into [broader contribution] and informs policy decisions to support [goal].

**Opening (theoretical paper)**
> [Topic] plays a foundational role in coordinating [broader phenomenon]. Through [mechanism], [actors] commit [resources] to enable [outcome]. Yet, the system is plagued by persistent inefficiencies that reflect a fundamental asymmetry in [key tension].

**Opening (empirical paper)**
> Why does [outcome] vary so much across [units]? In this paper, I examine the role that [factor] plays in shaping [phenomenon]. [Two sentences establishing policy or economic stakes.]

**Contribution statement**
> This study contributes to the literature on [field] by providing empirical evidence on [specific question]. First, while [existing knowledge], there has been a lack of research on [gap]. [What I do to fill it.] Second, I find that [additional finding], which adds to the literature on [strand]. Third, I provide an implication for [application].

**Quantitative result**
> A 1% increase in [variable] is associated with a decrease in [outcome] by [X] [units], while it is not associated with [alternative group/outcome].

**Scope limitation**
> We note two limitations to our analysis. First, [limitation and why it arises]. Second, [limitation]. These considerations suggest caution in generalizing our findings to [context].

**Proposition + Remark**
> **Proposition 1.** *Under Assumptions 1 and 2, [conditions]. The [estimator] identifies [estimand] if and only if [condition].*
>
> *Remark 1.* Since [implication of the mathematical structure], this result shows that [economic interpretation]. In particular, [practical takeaway].

**Road map**
> Section 2 discusses [topic A]. Section 3 presents [topic B], including [subtopic]. Section 4 introduces the [model/empirical strategy]. Section 5 presents and discusses the results. Section 6 concludes.
