*The title is a quote from chapter 69 of the work discussed.*

Commemorative poetry has a long history. Events deemed important are memorialised and made larger than life, often outliving the recollection of their facts. Similarly, poems of dedication are commissioned in the service of the powerful to create their afterlives in verse. Now, we see this too for companies and their products, as David Whyte did for the Boeing 777 at the company's request, published in his [[The House of Belonging by David Whyte|The House of Belonging]].

In [[The Ode Less Travelled by Stephen Fry]], the poem [The Tay Bridge Disaster](https://en.wikipedia.org/wiki/The_Tay_Bridge_Disaster) by William McGonagall is a case study in how poetry fails, and it happens to be of the commemorative type. "A disaster for a disaster" as Fry puts it:

> One might argue that McGonagall has brilliantly memorialised a doomed and structurally flawed bridge in congruently doomed and structurally flawed verse. His poem is a disaster for a disaster: it is the Tay Bridge, crashing hopelessly to its destruction and dragging every innocent word with it. It is not buttressed by metre, rhyme, sense or reason and even as we read it we feel it collapse under the weight of its own absurdity and ineptitude.

A brutal send-down, but he is not alone in his views. It is widely regarded as one of the worst poems in the English language.

In the last few weeks, we have seen a combination of these forms bundled in _[The Way of Code](https://www.thewayofcode.com/): The Timeless Art of Vibe Coding_ by music producer and art guru Rick Rubin. It memorializes one of the leading AI chatbots, Claude by Anthropic. As a reflection on a currently existing product, it is also an advertisement, as I suspect was the double life of Whyte's offering.

First of all, what is [[Coding with AI#Vibe coding]]? The term was coined by Andrej Karpathy, an early staff member at OpenAI and former Director of AI at Tesla (the electric car company). In a February 2025 [Twitter post](https://x.com/karpathy/status/1886192184808149383) he wrote:

> There's a new kind of coding I call "vibe coding", where you fully give in to the vibes, embrace exponentials, and forget that the code even exists. It's possible because the LLMs (e.g. Cursor Composer w Sonnet) are getting too good. ... I ask for the dumbest things like "decrease the padding on the sidebar by half" because I'm too lazy to find it. I "Accept All" always, I don't read the diffs anymore. ... Sometimes the LLMs can't fix a bug so I just work around it or ask for random changes until it goes away. It's not too bad for throwaway weekend projects, but still quite amusing. I'm building a project or webapp, but it's not really coding - I just see stuff, say stuff, run stuff, and copy paste stuff, and it mostly works.

Or, as Rubin puts it, "You don't need to learn to code any more."

This method of software creation is a kind of AI assisted programming process which is distant from the code itself. It has a lot in common with low-code or no-code app builders, except now using _natural language_ rather than a drag-and-drop interface. Code assistant chatbots like Claude, ChatGPT and others accept their instructions in plain English (or your native tongue, if supported).

To demonstrate, here's one I made earlier. Observe what vibe coding with Claude Code looks like:

![[the-way-of-code-1.png]]
_The simulated worker is really gassing me up!_

We need to intervene only once, when the system didn't select the right build command:

```
⏺ Perfect! Now let me test the build to make sure everything works correctly:

⏺ **Bash**(npm run build)
  ⎿  Error: npm error Missing script: "build"
     npm error
     npm error To see a list of scripts, run:
     npm error   npm run
     npm error A complete log of this run can be found in: /Users/simonkenny/.npm/_logs/2025-06-13T18_20_38_788Z-debug-0.log

⏺ **Bash**(npm run)
  ⎿  No (tell Claude what to do differently)

> The command is `npx quartz build`

⏺ **Bash**(npx quartz build)
  ⎿   Quartz v4.5.1

     Cleaned output directory `public` in 17ms
     Found 117 input files from `content` in 7ms
     … +16 lines (ctrl+r to expand)

⏺ Perfect! The build succeeded! Now let me create a commit with the awesome new Serendipity Engine:
```

Although you would be forgiven for thinking that everything was, and would always remain, _perfect!_

![[the-way-of-code-2.png]]

The cost of $1.19 seems small, but it does add up.

The resulting 'Serendipity' widget didn't work quite right, it jostled with the backlinks and table of contents components already on the webpage. In terms of tone and theme, as you can read, it exaggerates my pretentious tendencies to insufferable levels. Sobering.

---

*The Way of Code* joins a cottage industry of products in the form of "The Way of X" or "The Tao of X". [The Tao of Physics](https://openlibrary.org/works/OL3258255W/The_Tao_of_Physics) is a well-known example but there are dozens of them ([see for yourself](https://www.goodreads.com/list/show/123057._The_Tao_of_insert_topic_here_)). It is a remix the infamous *Tao Te Ching* by Lao Tzu (alternatively *Laozi*), which along with *Zhuangzi* is the foundational text of Taoism. An introduction is hardly needed for such a work, I will clip a small portion from Stephen Mitchell's poetic paraphrased edition, the one that Rubin has largely based his on paraphrase on (in fact, sometimes verbatim):

> ...the classic manual on the art of living, written in style of gemlike lucidity, radiant with humor and grace and largeheartedness and deep wisdom: one of the wonders of the world. [Foreword]

*The Way of Code* is a virtual interactive book, a website. It pairs Rubin's words (written, he has stated, without the use of AI) to the accompaniment of various flowing animations with an ink-like monochrome style, clearly inspired by Zen masterwork paintings. This is where the subject meets its object, the animations presumably having been [[Coding with AI#Vibe coding|Vibe Coded]]. In turn, the reader is encouraged to participate in vibe coding of their own (and create a Claude account to become a member, of course) by remixing the code for these artworks themselves.

The artworks have been created using a simplified graphical coding platform called [p5.js]() the ancestor of [Processing.js](https://processing.org/). This freely available platform has been increasingly popular over the last 25 years and is largely responsible for the proliferation of DIY geometric computer art of this kind. It's impact on culture has been a taste for the promiscuous (and often *pointless*) visualization of data, especially of the interactive sort. For example, see like the 'Graph View' widget of this very website! These network diagrams (force-directed graphs) are often more about performing a 'computery', technical aesthetic than of any actual use.

---

I will not be as harsh as Fry was of McGonagall but certainly the shortcomings of *The Way of Code* are felt all the more by comparison to the venerable text on which it is based.

Read, for example, Rubin's rewriting:

> ...  
> Therefore The Vibe Coder builds without laboring  
> and instructs by quiet example.  
> Things arise and he accepts them.  
> Things vanish and he lets them go.
>   
> He holds without claiming possession.  
> Creates without seeking praise.  
> Accomplishes without expectation.  
> The work is done and then forgotten.  
> That is why it lasts forever. [Ch. 2]

Or:

> ...  
> If you don’t trust the team enough,  
> they become untrustworthy.
>   
> The Vibe Coder works in silence.  
> When the work is accomplished,  
> the team says,  
> “Amazing. We did it all ourselves.” [Ch. 17]

Some poems approach a kind of actual [[Techno-Spirituality]]:

> Breakthrough apps, arising from Source,  
> will advance the cybercosm.  
> And even if a hacker goes rogue,  
> Source will not abandon him. [Ch. 62]

It is difficult to read these lines without feeling the sharp pangs of cringe. This is business talk spliced into 'ancient wisdom' as a commodity. It reminds me of [Thich Nhat Hanh speaking at Google](https://www.youtube.com/watch?v=Ijnt-eXukwk) on Zen mindfulness, part of an outreach programme called *Wake Up* — another kind of [[McMindfulness by Ronald Purser|McMindfulness]].

The text of *The Way of Code* seeks to elevate the practice of lazily hacking away at code (refer to Karpathy's original coinage) to a noble embodiment of _wei wu wei_, often translated 'effortless action'. It is a concept of central importance to the *Tao Te Ching* and, so it is said, to Taoism. The _Tao_ is full of apparently contradictory dual statements of which the most fundamental perhaps is _wei / wu wei_.

Ursula Le Guin, in her paraphrase, comments in a footnote to the passage of chapter 3:

> Over and over _Lao Tzu_ says *wei wu wei*. Do not do. Doing not-doing. To act without acting. Action by inaction. You do nothing yet it gets done. [Ch. 3, [[Tao Te Ching by Laozi trans. Ursula Le Guin]]]

In Rubin's paraphrase, however, it seems like some kind of knowing joke, a tongue-in-cheek, having-it-both-ways joke that's not a joke, a [[Post-modernism]] wink. The vibe coder mumbles a lazy order and, "the work is accomplished". Really, the AI is a servant or a junior underling at best. It is not _wu wei_, it is rather *thoughtless-doing*.

In fact, the project *did* start with a joke tweet Rubin wrote on a whim:

> Tools will come and tools will go.  
> Only The Vibe Coder remains.

He discusses this and the project in general on the [a16z](https://player.fm/series/a16z-podcast/rick-rubin-vibe-coding-is-the-punk-rock-of-software) podcast (of venture capitalist Marc Andreessen):

> The idea of using the _Tao_ [_Te Ching_] as the basis for it — the _Tao_ is really serious! ... It started as a joke. When the _Tao_ became the backbone of it, it got profound! And it surprised me! This could actually do something good...

The 'something good' is a kind of moral outreach to coders who are suggested to be the architects of the future — again, precisely as Thich Nhat Hanh thought it worth doing at Google:

> [Host:] The other thing that I thought was great in *The Art of Vibe Coding* is you give a philosophy for what a human is... If we can't write marketing collateral or we can't code, what's our purpose, and you get kind of deep into that. How do you think about that, I guess?  
> [Rubin:] Well I think it's the reason I chose the _Tao Te Ching_ to base it on because _Tao Te Ching_ is 'how to live', so *The Way of Code* is talking about how to *be* in life and — it's a grounding. And I imagine so many of people who are coders probably have never read the _Tao Te Ching_ and the coders will likely be the people who are designing our future, so if this is an opportunity for the people who are designing out future to get in touch with the three thousand year old truth of how to create balance in life and on the planet, that seems like a really good thing.

---

There is a genuine playfulness to the *Tao Te Ching*, the potential for an absurd humour that others too have noted. Le Guin says, "One of the things I love about Lao Tzu is he is so funny. ... He goes about it with this deadpan simplicity, talking about pots." [Ch. 11]

It is not only serious and old, it is also confounding and surprising, admonishing but gentle, an invitation to think (without thinking?). Most of all, it is generative in its intentional paradox. In the final verdict, in my view, Rubin misses the mark significantly with his work.

It joins others who wed art and technology but favour the latter, such as French artist group *Obvious* who sold the first AI-produced artwork in Fine Art auction house Christy's. As [I wrote about elsewhere](https://medium.com/@skenwrites/the-art-of-ai-prompt-engineering-dd4f23138f7a), for *Obvious* the tech goal subordinates all. They state in their manifesto: "Art is a perfect medium that allows [us] to experiment with the possibilities of an AI and better understand how it all works." In Rubin's case, I'd almost go as far as to call it the art-washing of a technology particularly contentious to artists (see [[AI in art]]).

Still, it has captured the imagination of many and become a small phenomenon. What makes the work compelling is not the clumsy poetry but its presentation with the intriguing animation and the invitation to experiment. Nothing I have said here should give you the impression that the AI tools are not impressive — they very much are. And that power, the appearance of it, is the point. The words are ancillary, a framing for elevation.

Despite the word 'humility' appearing frequently in the text, I can only see *The Way of Code* inflating the already considerable self-regard with which many of today's technologists hold themselves, by validating careless auto-fabrication by association to one of the great texts in world culture.