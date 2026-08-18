# AI writing patterns: what to look for and remove

A reference for sweeping academic prose (or any writing) for the tells that mark a passage as LLM-generated or LLM-smoothed. The organizing idea throughout: **the tell is a shape, not a specific word.** Swapping "artifact" for "byproduct" doesn't fix a sentence built on the artifact-tell's rhetorical skeleton. Every fix below should change the sentence's structure, not just its vocabulary.

Two ways to use this document:
1. **Targeted read** — read the passage once per category below, looking only for that pattern.
2. **Grep pass** — for the vocabulary list, literally search the document for each term. Structural patterns don't grep well; they need a read-through.

Run both. Vocabulary greps catch what a read-through misses when you're tired; the read-through catches structural patterns no search string can find.

---

## Part 1: Rhetorical constructions

Each entry: what it looks like, why models default to it, a real example, and the fix.

### 1. The contrast-reveal ("X is not Y. It is Z.")

**Shape:** A sentence (or two) that first states a plausible-but-wrong framing, then corrects it. The correction is the payload; the setup exists only to be knocked down.

**Why models do this:** It's a cheap way to manufacture the feeling of insight. Stating the correct fact directly can read as flat; staging it as a reveal borrows the rhythm of a magic trick. It's the single most recognizable model tell because it's rhythmically identical every time, regardless of subject matter.

**Examples:**
- "This is not a bug. It is a feature of the design."
- "The result isn't noise — it's signal the model was trained to ignore."
- Compressed form: "The problem isn't the data, but the pipeline."

**Also watch for it in thesis/topic sentences**, where it's easy to miss because it looks like a legitimate framing device:
- "The paper's contribution is not a new estimator, but a diagnosis of why the old one fails."

**Fix:** State the true claim directly. Delete the strawman half entirely — if the wrong framing was never a real possibility a reader would hold, the reveal has no rhetorical work to do anyway.
- Before: "This isn't evidence of trade diversion — it's an arithmetic identity."
- After: "This is an arithmetic identity, not evidence of trade diversion." (Still a contrast, but stated once, not staged as a reveal-after-setup.)
- Better, if the contrast isn't load-bearing: "The negative coefficient is an arithmetic identity."

### 2. Fronted negation ("What X does not do is...")

**Shape:** A sentence structured around what something *isn't* or *doesn't do*, before saying what it does.

**Example:** "What this specification does not do is separate creation from diversion."

**Fix:** Say what it does or doesn't do plainly, in whichever order the logic actually needs.
- After: "This specification cannot separate trade creation from trade diversion."

### 3. Count-announcement openers

**Shape:** "Three reasons explain this. First, ... Second, ... Third, ..." or "Two checks address this concern." The count is announced before any content, then the list mechanically fulfills the promised count.

**Why models do this:** It's an easy way to signal structure without doing the harder work of transitions that carry logical weight. It also lets the model commit to a number before knowing exactly what goes in each slot.

**Example:** "Two complementary checks address this. First, the fixed-share construction removes the mechanical channel. Second, the direct component regression avoids the ratio form entirely."

**Fix:** Delete the announcement. Let the first substantive point open the paragraph, and let transitions ("A second, independent check...") carry structure without pre-declaring a total count.
- After: "The fixed-share construction removes the mechanical channel; a direct regression on the components avoids the ratio form entirely."

**Watch especially for this recurring in later drafts** even after you've removed it once — it's one of the stickiest patterns, because it regenerates naturally whenever new list-like content gets added in revision.

### 4. Em dashes as parenthetical asides

**Shape:** "The result — surprising given the literature — held up under every specification."

**Why it's a tell:** Models overuse the em dash as an all-purpose parenthetical/pivot marker far more than human academic writing does. It's not wrong grammar; it's a frequency tell. A paragraph with three or four em-dash asides reads differently than one with zero, even if each individual sentence is fine.

**Fix:** Use a comma, parentheses, a full stop, or restructure. Table footnotes and citation strings are the one place em dashes are fine to leave (they're doing genuine list-separator work there, not rhetorical-pivot work).
- Before: "The coefficient — precisely estimated and unmoved by robustness checks — is nonetheless an artifact of the ratio."
- After: "The coefficient is precisely estimated and unmoved by robustness checks, but it is nonetheless an artifact of the ratio."

### 5. Semicolons stitching narrative clauses

**Shape:** Two (or three) independent clauses joined by a semicolon in ordinary narrative prose, where a period would do.

**Why it's a tell:** Semicolons read as more "considered" or "literary" to a model's training distribution than plain declarative sentences, so they get overused as connective tissue even when the two clauses don't have a tight enough logical relationship to justify staying in one sentence.

**Example:** "The fixed effects absorb the importer-side resistance term; the exporter-side term is not separately controlled."

**Fix:** Split into two sentences unless the clauses are genuinely one thought that a period would awkwardly sever (rare in practice).
- After: "The fixed effects absorb the importer-side resistance term. The exporter-side term is not separately controlled."

**Exempt:** table footnotes, citation strings ("Gaulier and Zignago, 2010; HS92 V202601"), and genuinely tight two-part statements where the second clause is a direct consequence of the first stated so compactly that a period would read as choppy, not clearer.

### 6. Standalone "punch paragraphs"

**Shape:** A single, short, rhetorically loaded sentence set off as its own paragraph for emphasis.

**Example:**
> The identity, not the economics, produced the negative coefficient.

...sitting alone between two normal paragraphs, doing no argumentative work beyond sounding conclusive.

**Fix:** Fold it into the paragraph before or after it. If it can't be folded in without becoming redundant, it usually wasn't earning its keep as a standalone in the first place.

### 7. Colon-reveal constructions

**Shape:** "X raises a question: Y." The colon functions the same way the contrast-reveal does — setup, then payload.

**Example:** "This creates a puzzle: why does the coefficient reverse sign only in the last subperiod?"

**Fix:** State the question or point directly without the colon-staged buildup.
- After: "Why does the coefficient reverse sign only in the last subperiod?"

### 8. Colon + meta-commentary

**Shape:** A short sentence that comments on its own claim via a colon, rather than just making the claim. Distinct from #7 in that the thing after the colon isn't a question — it's a terse, almost aphoristic tag.

**Example:** "The test is cheap to run: a single regression."

**Fix:** Merge into one plain sentence.
- After: "The test requires only a single regression."

**Note:** this recurs even after #7 gets caught and fixed elsewhere in the same document — it's a slightly different shape and slips past a reader primed only to look for question-colons.

### 9. Standalone topic-label announcements

**Shape:** A one-sentence paragraph opener that names the paragraph's topic before any content — functionally a mini heading disguised as a sentence.

**Example:** "Sample sensitivity is the next concern. Restricting the start year to 2007 weakens the estimate to −1.751..."

**Fix:** Delete the announcement sentence; let the first substantive sentence open the paragraph.
- After: "Restricting the start year to 2007 weakens the estimate to −1.751..."

### 10. Symmetrical balanced-pair framing

**Shape:** "X and Y agree on A but disagree on B" / "The two converge on one point and diverge on another." The tell is the *symmetry itself* — a rhetorical shape that imposes a tidy two-part structure on a comparison that may not actually be that clean.

**Example:** "The overlapping and disjoint pairings agree that the restriction fails, but disagree on how cleanly the coefficient can be interpreted."

**Fix:** State what's actually true about each side without forcing a matched agree/disagree, converge/diverge frame. Often the real relationship is asymmetric (one point applies to both, a second point applies to only one), and the tidy pairing is itself the distortion.

### 11. Summary-transition openers

**Shape:** A sentence that announces a structural shift ("Having established X, we now turn to Y") rather than stating a finding.

**Fix:** State the finding directly; let the reader infer the structural transition from content, not narration of it.
- Before: "Having shown the pooled estimate is unstable, the paper now turns to its component parts."
- After: "The component regressions isolate why the pooled estimate moves."

### 12. Verbatim or near-verbatim boilerplate repetition

**Shape:** The same explanatory sentence (or a lightly reworded copy of it) reused two or three times across a document — often because a number or definition gets re-introduced fresh each time it's mentioned, rather than referenced back to where it was first explained.

**Fix:** State it in full once. On later mentions, either cross-reference the first instance ("as in the Introduction...") or vary the phrasing enough that it doesn't read as copy-pasted.

### 13. Referent ambiguity from inserted material

**Shape:** Not a tell on its own, but a side effect of editing: when new sentences get inserted near existing pronoun-heavy text, "it," "this," or "that" can end up ambiguous between the old referent and the new one.

**Fix:** After any insertion near pronoun-heavy prose, re-read the surrounding two sentences and make referents explicit if there's any chance of ambiguity — don't rely on the reader picking the right antecedent.

### 14. Content gaps hiding behind smooth prose

**Shape:** Not a stylistic tell but a real risk of style-editing: a paragraph reads fluently and confidently, but a substantive question it's supposed to answer has quietly gone missing during the rewrite. Smoothness is not the same as completeness — in fact, a very smooth sentence is *easier* to skim past without noticing it never actually answered the question.

**Fix:** After any AI-pattern cleanup pass, re-read each edited paragraph and ask: does it still answer everything it did before, or did the content thin out while the prose got smoother?

---

## Part 2: Vocabulary flags

These words aren't wrong in isolation — they're flagged because they recur suspiciously often in model output relative to how often careful human writers reach for them, and because they tend to travel with the rhetorical shapes above. Treat each as a signal to look at the sentence, not an automatic delete.

| Word/phrase | Why it's flagged | Suggested replacement |
|---|---|---|
| **artifact** | Overused as a catch-all for "spurious result caused by X." Vague — doesn't say *which* mechanism produced the spurious result. | Name the mechanism directly, or say "does not depend on [X]." |
| **adjudicate** | Needlessly formal/legalistic for what's usually a simple comparison. | "settle which — is correct," "determine," "test." |
| **deliberate / deliberately** | Often inserted to imply intentionality that isn't actually being argued for. No instance should be assumed "safe" just because it's been used before — check every one. | State what was done; drop the intentionality framing unless it's actually the point. |
| **genuine / genuinely** | Vague intensifier. "Genuine residual relationship," "genuinely broken" — sounds precise but adds no information. Especially watch for the same exact collocation recurring more than once. | Cut, or replace with the specific quality being claimed ("a relationship that survives the [specific] check"). |
| **precisely** | Overused as a generic intensifier for "estimated" or "identified," implying rigor without adding content. | Cut, or state the actual precision (SE, CI) if that's the point. |
| **governs / governed** | Flagged only in abstract/metaphorical usage ("the mechanism that governs the result"). Ordinary historical/institutional narrative ("the treaty governed relations until 2000") is fine — that's literal, not metaphorical. | For metaphorical uses: "determines," "produces," or name the actual causal relationship. |
| **contaminated** | Loaded, implies a moral/hygiene framing for what's usually a straightforward statistical dependency. | "entangled with," "is not independent of," or name the mechanism. |
| **predates** | Often used vaguely to gesture at chronology without being specific about *why* the chronology matters. | State the actual date/event relationship if it matters; cut if it's decorative. |
| **candidate explanation** | A hedge phrase that sounds rigorous but usually just means "a possible explanation" without committing to how likely it is. | "one possible explanation," or state your actual confidence level. |
| **points the same direction** | A vague connective phrase used to link two pieces of evidence without specifying the actual relationship. | State what specifically the two pieces of evidence show, and how they relate. |
| **real questions** | Vague hedge ("this raises real questions about..."). Doesn't say what the questions are or why they're "real" as opposed to any other kind. | "raises doubts about [specific thing]," or name the actual open question. |
| **patched in** | Casual/informal phrase for what's usually a specific data-construction decision. | "supplemented from [source]," or describe the actual construction. |

**Procedural rule:** if you find yourself fixing a flagged word by swapping in a synonym that preserves the exact same sentence shape, you haven't fixed anything — you've hidden the tell from a keyword search while leaving the underlying rhetorical structure (usually one of the Part 1 patterns) fully intact. Always ask whether the *sentence*, not just the *word*, needs to change.

---

## Part 3: How to run the sweep

1. **Vocabulary grep first.** Search the document for every term in the Part 2 table (case-insensitive, whole-word). This is fast and catches easy wins.
2. **Structural read second, by pattern.** Don't try to catch all fourteen Part 1 patterns in one read. Do a pass per pattern (or per small cluster of related patterns — e.g., #1, #2, #7, #8 are all "reveal" variants and can be read together) if the document is long enough that fatigue is a real risk.
3. **Re-sweep after every edit pass, not just once.** Patterns regenerate in newly written material even after being fully removed elsewhere. A document that was clean in section 3 last week can have a fresh count-opener in section 3's *replacement* paragraph this week.
4. **Check completeness, not just style, after cleanup.** Once a paragraph has been rewritten to remove a pattern, re-read it against what it originally needed to say. Smooth prose can silently drop content (Part 1, #14).
5. **Prefer whole-sentence rewrites over word-swaps** when a flagged pattern is structural (most of Part 1). A synonym swap is only sufficient for genuinely single-word issues (most of Part 2), and even then, check that the surrounding sentence isn't also carrying one of the Part 1 shapes.

---

## Part 4: A worked example

**Before:**
> The result is not simply noise. It reflects a genuine underlying pattern — one that three separate checks confirm. First, the fixed-share specification; second, the direct component regression; third, the parallel-partner check. What none of these checks does is fully rule out an alternative explanation: omitted variable bias.

Every single pattern in Part 1 is present in this short passage: contrast-reveal (#1), em dash aside (#4), count-announcement (#3), fronted negation (#2), colon-reveal (#7), plus the vocabulary flag "genuine" (Part 2).

**After:**
> The fixed-share specification, the direct component regression, and the parallel-partner check all point to the same pattern rather than to noise. None of the three checks rules out omitted variable bias.

Two sentences, same information, no staged reveals, no inflated intensifiers, no announced-then-fulfilled list structure.
