In recent months, incorporating the latest LLM-based AI tools into the code production pipeline has become truly viable for the first time.

It will almost certainly change the industry though it is impossible to say exactly how. Lots of hay is going to be made of this as it happens in real-time. [Roy Amara](https://en.wikipedia.org/wiki/Roy_Amara) and his 'law' is often invoked at such times (though I'm never sure so to alarm or sooth):

> We tend to overestimate the effect of a technology in the short run and underestimate the effect in the long run.

In a widely read essay [My AI Skeptic Friends Are All Nuts](https://fly.io/blog/youre-all-nuts/), Thomas Ptacek writes well but abrasively about the moment we're in. He's positive about it in a 'get with the times' kind of way:

> All progress on LLMs could halt today, and LLMs would remain the 2nd most important thing to happen over the course of my career.

I'll reference this essay a few times as it covers a lot of the ground I've been thinking about (really, all of us I assume).

# The tech

## Chat with the docs

In the simplest use case, coding with an AI is like using an interactive search of the docs. Even the most highly quantized LLMs you can run locally on a laptop with no GPU can do this (via [Ollama](https://ollama.com/) for example).

## Prompts as code

Are prompts just another form of coding? There are parametrized prompt builders that would make it seem so but I think this is illusory since the underlying effect of prompts is fundamentally non-deterministic and the models are always changing (or the config, such as the system prompts, etc.)

## Vibe coding

A term coined by Andrej Karpathy, early staff at OpenAI and former Director of AI at Tesla (the electric car company) in a February 2025 [Twitter post](https://x.com/karpathy/status/1886192184808149383):

> There's a new kind of coding I call "vibe coding", where you fully give in to the vibes, embrace exponentials, and forget that the code even exists. It's possible because the LLMs (e.g. Cursor Composer w Sonnet) are getting too good. ... I ask for the dumbest things like "decrease the padding on the sidebar by half" because I'm too lazy to find it. I "Accept All" always, I don't read the diffs anymore. ... Sometimes the LLMs can't fix a bug so I just work around it or ask for random changes until it goes away. It's not too bad for throwaway weekend projects, but still quite amusing. I'm building a project or webapp, but it's not really coding - I just see stuff, say stuff, run stuff, and copy paste stuff, and it mostly works.

Simon Willison [pointed out](https://simonwillison.net/2025/Mar/19/vibe-coding) that it has come to be used to mean _all_ AI assisted coding, which he rejects. Unfortunately, terms people like are sticky and often change their meaning beyond the coiner's intent. Expect it to be used to mean hacking at project code without ever reading it (original intent) and heavily assisted coding.

## Agentic coders

Wrappers around reasoning capable LLMs. This facilitate semi-autonomous operations based on a planning phase with automatic feedback ingest, such as test results, stack traces on errors, etc.

Currently the hottest topic in coding with AI.

* [Claude Code](https://www.anthropic.com/claude-code)
* [GitHub Copilot Agent Mode](https://github.blog/news-insights/product-news/github-copilot-the-agent-awakens/), through [VSCode](https://code.visualstudio.com/) first-party integration
* [ChatGPT Codex](https://chatgpt.com/codex)
* Google's [Jules](https://jules.google/)

For complex tasks or those involving vagueness, they can very easily get stuck. There are sticky failure loops that we might call *local minimums* in the solution search space, where some context fails to be taken into account or seen as relevant, or common mistakes not rectified.

## Hallucination and security

Reliably pessimistic outlet _The Register_ leaped on the story of hallucinated dependencies (software libraries) that coding assistants/automatons are prone to with [LLMs can't stop making up software dependencies and sabotaging everything: Hallucinated package names fuel 'slopsquatting'](https://www.theregister.com/2025/04/12/ai_code_suggestions_sabotage_supply_chain/). Similarly to how ne'er-do-wells will register website domain names that copy common typos of well known brands (called [typosquatting](https://capec.mitre.org/data/definitions/630.html)), bad actors register fake libraries filled with malware that LLMs might make up.

# Economic 'forces'

## Developer tax

Developers are under a lot of pressure to use AI coding tools — so as not to fall behind their peers, to be seen to use AI (keeping up to date has always been imperative for devs), as mandated or more subtly expected by superiors, and plain ol' FOMO. Of course, many coders (myself included) are driven by curiosity and the joy of learning, and so are motivated to at least get across a few of the new technologies coming out as they become available.

Where companies and institutions do not invest in team licences for their staff, the cost of using these AI systems becomes an additional cost of employment, externalized to staff themselves. Many devs who think of themselves as keeping up have a subscription to most or all of the main cloud LLM providers: OpenAI's ChatGPT, Anthropic's Claude, GitHub's Copilot and Google's Gemini. Add to this API costs for many of the tools, especially OpenAI and Anthropic (Claude Code isn't included in the first tier subscription).

The first tier of subscription is around $20 per month. Many offer a second power user tier at around $200 per month. These latter subscriptions include some bandwidth on the usually per-by-use metered API services that back the agentic systems, but it is a hefty price.

In the discourse, the narrative is often "$200 pm instead of a junior dev is cheap!" but this ignores that, at least in the immediate term, we are actually talking about motivated devs taking a pay cut to stay competitive. _Cry moar overpaid nerds_, you might say. Ptacek (see top) put it (callously) as, "Does an intern cost $20/month? Because that’s what Cursor.ai costs."

This is such a concern that a recent article [Stop Over-thinking AI Subscriptions](https://steipete.me/posts/2025/stop-overthinking-ai-subscriptions) attempts advise on keeping this cost to _only_ $200! 😵

If you're using AI at work, demand of your employer it is paid for by the company, at the very least.

# Social impact

## How will new engineers get started?

Especially entry level and graduate positions are at risk of replacement. Senior engineers can already use agentic LLMs to match the level of some graduate work, much faster, for much less money. See above the Ptacek realism dunk.

This is something I'm concerned with as someone who often mentors junior devs and wants to see the best for them.

## Artisans become factory workers

It is tempting to see parallels to the industrial revolution which saw skilled craft artisans replaced with unskilled factory labourers (see [[The Technology Trap by Carl Benedikt Frey]]). The generation that came of age with Uncle Bob's *Clean Code* have been encouraged to see computer programming as a skill that demands intelligence and art.

The idea goes further back, at least to Donald Knuth's famous multi-volume *The Art of Computer Programming*, the first volume published in 1962. This is 'art' in the sense of _Zen and the Art of Motorcycle Maintenance_, the technical craft and skill combined with human aesthetic and stylistic choices _within_ a technical field, not conflicting with it. This is the world of the artisan.

Knuth received the Turing Award in 1974, largely due to this work (which was apparently a [solo effort](https://quarter--mile.com/One-Man-Armies), and made it central to his [award speech](https://paulgraham.com/knuth.html), which is worth reading in its entirety. Fifty years on, and his statements on the hypothetical effect of AI on *programming as art* are thought by many to have come to pass, finally:

> Artificial intelligence has been making significant progress, yet there is a huge gap between what computers can do in the foreseeable future and what ordinary people can do. The mysterious insights that people have when speaking, listening, creating, and even when they are programming, are still beyond the reach of science; nearly everything we do is still an art.

It is implied that if a computer system can speak, listen and create, the *art* (or craft) aspect has been automated.

The high/low-skill labour division moat is apparently starting to evaporate within the behemoth of *Amazon*, the thing that has separated the work, pay and enjoyableness of the jobs of software engineers and warehouse workers. See Simon Willison's popular blog discussing this (though he rarely takes the side of worriers or the coal mine canary, this time included): reaction to [At Amazon, Some Coders Say Their Jobs Have Begun to Resemble Warehouse Work](https://simonwillison.net/2025/May/28/amazon-some-coders) in the New York Times. This seems to be another predictable effect of automation, the deskilling of work. See [[The Technology Trap by Carl Benedikt Frey|The Technology Trap]] again on this.

I myself have seen my work as a programmer as _creative_, not necessarily an *art* (and certainly not itself 'Art') but absolutely a craft. I intentionally blurred the lines of this during my degree in Music Technology, where both 'Art' and computer skill were at play. I discussed this in my 2019 [interview for Otia](https://otia.io/2019/12/06/simon-kenny-technical-lead-and-musician/) (forgive the self-quote):

> I absolutely think music has been beneficial to my tech career. Writing and playing music together is about building interlocking abstract structures that only exist in your head, and then using them to guide your body and voice to produce coherent music as a group. ... I think that writing computer code taps into a similar faculty of mind. When you write code, you are keeping a lot of information in your head about all the other code you’re not seeing, about your plans for the future, and the architecture you are adhering to. When writing code, like when writing music, you need to remember and reference lots of other parts. I can see the complex structure of a certain song I wrote years ago with my collaborators, which took months of deliberation and experimentation to write. Likewise, I can visualise the structure of my current work project’s codebase, which has been years in the making, and see what plans we have for it.

Not everyone agrees though. Ptacek, in particular, is scathing:

> Do you like fine Japanese woodworking? All hand tools and sashimono joinery? Me too. Do it on your own time.  
> I have a basic wood shop in my basement. I could get a lot of satisfaction from building a table. And, if that table is a workbench or a grill table, sure, I’ll build it. But if I need, like, a table? For people to sit at? In my office? I buy a fucking table.  
> Professional software developers are in the business of solving practical problems for people with code. We are not, in our day jobs, artisans.

*Youch*. I think this gets to the heart of the disconnect, and it really is people talking past each other on this one, the refined vs the hackers.
