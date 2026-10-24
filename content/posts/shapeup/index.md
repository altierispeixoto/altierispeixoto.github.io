---
title: Shape Up for Data Science and ML Projects
date: 2026-10-24
description: A recipe for betting on ML work, shipping it and avoiding rabbit holes.
tags:
  - Machine Learning
  - Data Science
  - Shape Up
  - Project Management
  - Linear
categories:
  - Leadership
draft: false
cover:
  image: cover.jpeg
  relative: true
---

_A recipe for betting on ML work, shipping it, and not disappearing into a rabbit hole. Adapted from Ryan Singer’s Shape Up and wired into Linear._

A stakeholder came to my team with a very interesting problem. At the time it was urgent for them. We analyzed it, found it appealing and went all in for weeks: data collection, data analysis, modeling, architecture decisions, and so many rounds of back and forth that I lost track of the original question. Then we found out the project was interesting to them, but not a real priority. All that time went into the promise of delivering something cool: useful in people’s hands, good for my team’s morale, visible to senior leadership. And it was gone.

Part of that was on us. Our idea was cool, and the stakeholder agreed, but being cool didn’t mean anyone would put resources behind it. We had no periodic checkpoints, so nobody asked early enough whether anyone would back it. We didn’t create a baseline to prove the value before investing in heavier infrastructure, and we never really challenged our approach or looked at different ones.

I told myself that failure is part of being a data scientist (Coldplay’s "The Scientist" comes to mind), and that not all ideas survive the light of day. That’s part of the game, so we tried again, and again, and again, until we had a graveyard of dead cool ideas in a monorepo called `exploratory-data-analysis`. Surely this repo could be renamed to `another-one-bytes-the-dust`.

After enough dead ends, I started asking myself a question. If this happens often, something is broken. What if it’s the process itself?

Looking back, the process had more than one gap. After burying that many projects, what I wish I’d had was a way to decide, before touching any code, how much a problem is worth, whether anyone will back it, and when to stop. This post is my attempt to adapt Shape Up, a method built around exactly that, to data science and ML, including what to do when priorities compete across teams.

> I haven’t run this end-to-end yet. This is the process I’m proposing to my team, built from Shape Up and tested only on paper so far. I’ll update this post after the first cycle.

---

## 1) The methodology

Shape Up[^1] is a way of running product work, written up by Ryan Singer in a free book from Basecamp. The pitch is simple. Shape the work before anyone commits to it, bet on a few well-shaped options for a fixed six-week cycle, and let a small team own the result from start to finish. No open-ended sprints, no ever-growing backlog.

The core idea is fixed time, variable scope. You decide the time first and let the scope bend to fit, instead of letting the schedule stretch to fit the scope. It was written for software product teams. But uncertainty, scope creep and work with no finish line are familiar topics in data science projects.

It comes down to five ideas.

1. **Appetite, not estimates.** An estimate starts with a design and ends with a number. An appetite starts with a number and ends with a design. You decide how much time the problem deserves, then shape a solution that fits.
2. **Cycles and cooldown.** A cycle is six weeks: long enough to finish something real, short enough to see the end from the beginning. Cooldown is the two weeks after it, with no scheduled work. It's for bugs, technical debt and exploring what comes next.
3. **Shaped pitches, no backlog.** Before each cycle, a few well-shaped options compete. There's no grooming and no giant list of old ideas, and you only bet one cycle ahead.
4. **A bet is a commitment.** A small team gets six weeks without interruptions, and the most you can lose is the appetite you bet. The betting table is the short meeting in cooldown where the people who decide choose the bets.
5. **The circuit breaker.** If it doesn't ship inside the time you bet, it isn't extended by default. It gets reshaped or dropped.

> One cycle: six weeks of building, two weeks of cooldown. The betting table meets during cooldown, and the circuit breaker sits at the end of week six.

```goat
                                       Circuit breaker      Betting table
                                                      v                 v
+--------+--------+--------+--------+--------+--------+-----------------+
| Week 1 | Week 2 | Week 3 | Week 4 | Week 5 | Week 6 |    Cooldown     |
+--------+--------+--------+--------+--------+--------+-----------------+
         ^                 ^                 ^                 ^
  Scary unknowns   Validate on data    Hammer scope    Cleanup and drift
  go uphill first   midpoint check    finish and ship  shape new pitches
```

---

## 2) Shaping the work

Shaping happens before the bet, on its own track, done by the people who understand both the problem and the technical risk. The output is a pitch: a bounded piece of work with an appetite, a baseline and a stop rule, not a task list or a spec. The project I opened this post with never had one.

> We had an interesting problem and the stakeholder who wanted it yesterday. Nobody had written down what it was worth, what we'd compare the result to, or what the stakeholder was committing to. We went from an exciting conversation straight to modeling.

The book's pitch has five ingredients:

- **Problem.** Which decision or process changes if this works. For ML, I also name the business metric: which number moves.
- **Appetite.** Small batch (one to two weeks) or big batch (six weeks), for a small team.
- **Solution at fat-marker level.** A pipeline sketch with the elements and how they connect: data sources, features, model family, evaluation, serving. Rough, solved and bounded. Not a design doc.
- **Rabbit holes.** Known risks and how the pitch defuses them, for example "labels are noisy, so relabeling is capped at 500 samples".
- **No-gos.** What is explicitly out: new data sources, real-time serving, a second model family.

For ML, I add four more. They are the ones that keep you out of trouble:

- **Baseline to beat.** The current reality: the rule, the heuristic, the manual process or the previous model. The book tells teams to compare to baseline instead of an ideal. For ML this is the first thing to write down, because it defines "good enough".
- **Data assumptions.** What data must exist, at what quality, with what access. Most ML rabbit holes start here.
- **Success and stop rule.** The metric threshold that counts as done, and the result that means stop.
- **Stakeholder commitment.** Who backs the bet and what they give: time, data access, and a promise to use the result.

**A sample pitch.** Here is how those ingredients look on a small, invented project. The numbers are illustrative, not from a real team.

```markdown
Pitch: Weekly demand forecast for the top 500 SKUs

Problem
Planners reorder from a spreadsheet and gut feel. Promoted items stock out.

Business metric
Stockout rate on promoted items. Measure today's rate in week 1.
Target: 20 percent lower.

Model metric (the proxy)
WMAPE of the weekly forecast. Used to compare models quickly, because
stockouts take weeks to observe.

Link between the two
Backtest: replay the holdout weeks' orders with the forecast and count the
stockouts it would have prevented. Agree the method with the planners first.

Stakeholder commitment
The head of planning backs the bet. Two planners give two hours a week
to review forecasts and sign off the backtest method. If it ships,
planners use it for promoted items next cycle.

Appetite
Big batch. Six weeks, one data scientist and one ML engineer.

Baseline to beat
Last four-week average, as planners use it today. In week 1, measure its
WMAPE and its simulated stockout rate on the holdout.

Solution (fat marker)
Sales history and promo calendar, then one gradient-boosted model per
category, then a weekly forecast table, then a planner view.

Data assumptions
Two years of weekly sales and daily stock levels per SKU exist.
The promo calendar covers the last 12 months.

Rabbit holes
Gaps in the promo calendar: flag them, do not rebuild the calendar.
New SKUs with no history: fall back to the category average.
Backtest realism: one simple reorder rule with a fixed lead time.
Do not build an inventory simulator.

No-gos
No new data sources. No deep learning. No store level forecasts.
No real-time serving.

Success and stop rule
Done: WMAPE at least 10 percent lower than the baseline on an 8-week
holdout, the backtest shows 20 percent fewer stockouts on promoted items,
and it runs as a scheduled job.
Stop: if promo features show no lift by week 3, cut them, ship the model
that beats the baseline without them, and pitch promo as its own R&D bet.
```

The pitch has two metrics. The business metric is why the stakeholder backs the bet. The model metric lets the team move fast. The link between them stops you from winning on one and failing on the other.

Just as important is what is not there: no model architecture, no tuning plan, no task list. The team works those out once the bet is made. That is on purpose.

Notice the stop rule too. It doesn't reshape the pitch in the middle of the cycle. It cuts scope, and the open question (does promo data help at all?) becomes its own R&D bet.

The baseline in the pitch is not a machine learning model at all. It's the last four-week average. Google's Martin Zinkevich opens his Rules of Machine Learning[^2] with "Don't be afraid to launch a product without machine learning". He then says to design metrics first and keep the first model simple while you get the infrastructure right. Eugene Yan makes the same point[^4] about his own first iterations. The non-ML solution is the bar every model has to clear. If your fancy model can't beat a dumb rule, you've learned something valuable, and cheaply.

---

## 3) Making bets

A pitch that gets chosen at the betting table becomes a bet. A bet is a commitment: a small team gets a full cycle on one shaped pitch, nobody pulls them onto something else, and the most you can lose is the time you bet. That is why the book says "bet" and not "plan". A plan promises an outcome. A bet only caps the downside.

But not every bet is the same kind of bet. The book describes three modes for building a new product: R&D, production and cleanup. They map surprisingly well to ML. The mapping below is an adaptation, not something the book says about data science.

**R&D bet.** You cannot shape what you do not yet know, so this bet buys learning, not a launch. The aim is to spike, not to ship, and senior people should do it, because you cannot delegate what you do not understand yourself. In ML that means a data audit, a baseline, feasibility checks and error analysis. The output is a decision (go, reshape or stop) plus code worth keeping. A model in production is not the success criterion. And you commit one cycle at a time, then decide whether to keep going.

Karpathy has a recipe for the first weeks of this bet. In A Recipe for Training Neural Networks[^3], step one is to touch no model code at all and look at the data instead: duplicates, imbalances and outliers that give away quality bugs. Step two is an end-to-end training and evaluation skeleton with dumb baselines, before any fancy architecture. He also warns that training fails silently, and that a "fast and furious" approach only leads to suffering. Turn those into the first scopes of the bet and it takes shape: data audit, baseline, then a decision.

**Production bet.** Once R&D has de-risked the idea, shaping becomes deliberate again and the pitch describes what exists at the end of the cycle. Done means deployed: pipeline, serving, tests, monitoring and rollback. This is also where more people, or parallel teams, can join, because the R&D work has laid the foundation. Zinkevich's advice applies here too: detect problems before exporting models, and watch for silent failures. Put both in the pitch as scopes, not afterthoughts.

**Cleanup.** After a Production bet ships, leftovers go in two places. Routine items (drift review, monitoring fixes, data contract updates) wait for cooldown, as in section 9. Anything bigger becomes a small batch inside the next cycle. In the book, cleanup has no shaping and ships in small bites.

> The practical rule: never start a Production bet from an R&D hunch. If an idea will not fit in six weeks even after narrowing it, split it into an R&D bet and a Production bet.

```goat
+-----------+     +-----------+        +----------------+     +-----------+
| R&D bet   |---->| Go or no  |--go--->| Production bet |---->| Cleanup   |
| learn in  |     | go?       |        | shipped and    |     | last gaps |
| one cycle |     +-----+-----+        | monitored      |     | closed    |
+-----------+           |              +----------------+     +-----------+
      ^                 | no go
      |                 v
      |           +-----------+
      +-----------| Reshape   |
                  | or stop   |
                  +-----------+
```

R&D to production, with one gate in between. A no-go is a good outcome: the cost was one cycle, and the next pitch starts from what the team learned.

---

## 4) Size every bet to the cycle

Not every bet needs six weeks. The book standardizes two sizes, and you pick one when you shape the pitch.

**Big batch.** One small team, one project, the full six weeks. Examples: a new model family, a new data source, a serving architecture change, an end-to-end production feature.

**Small batch.** Projects of one to two weeks, bundled inside the cycle. The team juggles them so everything ships before the cycle ends. Examples: feature experiments, threshold tuning, targeted error analysis, data quality fixes, retraining, dashboards.

If the work is too big for six weeks, hammer down the problem definition first. If it still does not fit, break off a meaningful part that does. Every cycle must end with something fully working, never “phase one of the model” with no real end state.

---

## 5) Work in scopes, not task lists

A scope is a meaningful part of the problem that you can finish independently of the other parts, in a few days or less. It's bigger than a task and much smaller than the project. In ML, it's a piece you can finish and show: a number, a table or a chart. Scopes are discovered, not planned. The dependencies between the parts only show up once you've done some real work.

Most ML projects are icebergs: a lot of data and model work hiding under a thin output, like a score or a table. The book's advice for icebergs is to split the heavy part into stages you can finish and integrate one at a time. That's why "data cleaning" and "modeling" make poor scopes. They're layers, and you can never say when they're done.

| Weak name               | Why it fails                         | Better                                      |
| ----------------------- | ------------------------------------ | ------------------------------------------- |
| Data cleaning           | A layer. You can never say it's done | Label audit                                 |
| Modeling                | A layer, and a rabbit hole           | Baseline scored, Promo features             |
| MLOps                   | Same problem                         | Scheduled job, Drift monitoring             |
| Experiments, bugs, misc | Grab bags                            | File the work under the scope it belongs to |

Here is a good set for the demand forecast in the sample pitch.

| Scope              | Done when                                                           |
| ------------------ | ------------------------------------------------------------------- |
| Label audit        | Error rate measured on a sample, and a decision made on what to fix |
| Baseline scored    | The last four-week average is scored on the holdout                 |
| Promo features     | Promo effect measured against the baseline, per category            |
| Evaluation harness | A nightly run produces the comparison table                         |
| Scheduled job      | The forecast table lands in the planner's view automatically        |

The scopes are right when you can see the whole project and nothing worrying hides in the details, when the names give the team a common language, and when you know where a new task goes.

Edge cases, cleanups and extra segments will keep turning up. Put them inside the scope with a `~` in front. Must-haves decide when a scope is done, and the tilde items are the first to go when time runs out.

> Scopes can play the role of epics. In Linear, use project milestones for scopes if your company doesn't already use milestones for review dates. If it does, use parent issues for scopes and sub-issues for tasks.

---

## 6) Progress is a hill, not a percentage

Every piece of work has two phases. Uphill is figuring it out. Downhill is making it happen.

- **Uphill:** data access, exploratory analysis, metric definition, baseline, first feature ideas.
- **Downhill:** training pipeline, evaluation harness, integration, deployment, monitoring.

The book splits the climb into thirds: you have thought about it, you have validated the approach, and you have built far enough to believe no unknowns remain. The ML lesson is to climb with your hands, not your head. "We'll just use that feature store" is a theory until you've run it on real data. Then it's a fact, or a surprise.

Sequence matters too. Push the scariest unknowns uphill first: label quality, feature availability at serving time, whether the signal exists at all. Leave the routine work, such as the dashboard, for last.

```goat
            Top of the hill: no unknowns left
                        .--------.
                       /    :     \
                      /     :      \
                     /      :       \
                    /       :        \
   Promo features  *        :         o   Evaluation harness
                  /         :          \
                 /          :           \
                /           :            o   Label audit
  ----o------------------------------------------------->
  Scheduled job

Uphill: figuring it out           Downhill: making it happen
data, metric, baseline            pipeline, eval, deploy, monitor
```

Hill chart with four example scopes from the sample pitch at week 3. The filled dot, promo features, is the one to watch, because it is still uphill at the midpoint.

> Many ML scopes depend on each other: the label definition comes before the baseline, and the baseline before the features. Start with the scariest unknown. Section 12 shows how to report each scope's position on the hill in Linear.

---

## 7) Cut scope, not the deadline

When the deadline is fixed, scope has to move. The book calls this hammering, and it means it. Ask of every new idea: is it a must-have? Could we ship without it? What happens if we do not do it? Anything that fails those questions gets the tilde from section 5. Most tilde items are never built, and marking them is the hammering. In ML the nice-to-haves are extra segments, a second metric, one more ablation, a fancier architecture. (Yes, the fancier architecture.)

The circuit breaker is the policy that makes the deadline real. No extension by default. The book allows an extension only in rare cases and only if two conditions hold: **the remaining tasks are true must-haves that survived every attempt to hammer them, and the remaining work is all downhill**. Unsolved problems at the deadline mean the shaping had a hole. The project goes back to shaping, and a new pitch earns a new bet. If a team keeps spilling into cooldown, the book says the cause is either the shaping or team performance.

---

## 8) Name the rabbit holes before you enter them

| Rabbit hole                                      | Guardrail                                                                          | Line to write in the pitch                   |
| ------------------------------------------------ | ---------------------------------------------------------------------------------- | -------------------------------------------- |
| Chasing state of the art                         | Beat the baseline first                                                            | No new model families                        |
| Endless hyperparameter tuning                    | Timebox it, and define the gain not worth chasing                                  | Tuning capped at three days                  |
| Perfecting features before validating the metric | Agree the metric and the offline-to-online link first                              | Metric signed off in week 1                  |
| Cleaning data forever                            | Set a quality threshold and stop when you reach it                                 | Stop cleaning at the agreed threshold        |
| Over-engineering MLOps before proving value      | The R&D bet ships a decision, not a platform                                       | No new serving infrastructure                |
| Moving the goalposts                             | Success and stop rules live in the pitch and change only at the next betting table | Success rule frozen for the cycle            |
| Mid-cycle scope creep                            | New requests are raw ideas: “interesting, maybe some day”                          | New requests go to the shaping list          |
| Labeling with no stop rule                       | Cap the label budget in the appetite                                               | At most N labels, then work with what exists |

---

## 9) Use cooldown to keep models healthy

Cooldown is where ML systems get healthy again.

Typical uses: retire dead experiments, turn notebooks into pipelines, review drift, fix monitoring, update data contracts, document decisions, and shape the next pitches. None of it is glamorous. All of it is the difference between a model and a system.

The book’s stance on bugs fits model incidents well. A bug is not automatically more important than a bet. A real crisis, such as data loss or a model producing wrong outputs at scale, justifies stopping everything. Everything else waits for cooldown, or becomes a pitch and competes at the betting table. Feedback after a launch is the same: say a soft no, stay debt-free, and shape the idea before betting on it.

---

## 10) When priorities compete across teams

Everything so far assumes one team and one list of ideas. Real life has a product team that wants a ranking model, a risk team that wants a new fraud signal, and an executive who needs “just one dashboard” by the end of the quarter. Each of them has a roadmap, and every roadmap quietly assumes your capacity is theirs.

Shape Up was written for one product company, so this section is part book and part adaptation. The principle is the same either way: do not negotiate priorities in hallways and slide decks. Make them compete in one place, in one currency, against a fixed capacity.

**1. Fix the capacity first.** The book standardizes cycle length and team size, so capacity is a known number. Do the same. If the data group has three squads, it has three slots per cycle, big batch or small batch. Say the number out loud. Every yes now has a visible cost: bet on this, and that waits six weeks.

**2. One betting table, not one per team.** In the book, the betting table is a short meeting during cooldown with the few people who can actually decide. There is no second approval step, and nobody interferes with the plan afterwards. Done that way, it is a place to steer direction rather than a battle for resources. For cross-team ML work, seat the head of data or AI, the product owners of the teams asking, an engineering lead, and one person who breaks ties. Agree the tie-break criteria before the first meeting: business metric, appetite, risk, and what the team would learn.

**3. Every request arrives as a pitch.** “We need a churn model for Q2” is a raw idea. The book’s default answer is “Interesting. Maybe some day.” To reach the table it needs a problem, an appetite, a baseline, data assumptions, no-gos and a stakeholder commitment. Pitches are posted ahead of time and read on people’s own time. Comments are welcome, but the decision happens at the table. This turns “it is critical” into a comparable claim: “it is worth six weeks because…”.

**4. Compare in one currency.** Put every pitch on the same sheet. Here is an illustrative example.

| Pitch           | Asked by | Appetite | Metric against baseline    | Biggest unknown     | Needs from other teams              |
| --------------- | -------- | -------- | -------------------------- | ------------------- | ----------------------------------- |
| Demand forecast | Planning | 6 weeks  | WMAPE vs four-week average | Promo calendar gaps | Promo data owner confirms access    |
| Fraud signal    | Risk     | 6 weeks  | Recall at fixed precision  | Label quality       | Risk analysts label 500 cases       |
| Exec dashboard  | Finance  | 2 weeks  | Manual hours saved         | None                | Finance confirms metric definitions |

**5. Dependencies are shaping work, not mid-cycle surprises.** If a bet needs another team’s data, API or review, it goes into the data assumptions, and that team confirms before the bet is made. No confirmation, no bet. Or bet a small batch whose only job is to unblock it. Keep one lead per project and let the betting team own the whole result. The book assigns projects, not tasks, for good reason. If a project truly needs two teams, one owns it, and the other’s contribution becomes a shaped, timeboxed piece scheduled in an earlier cycle.

**6. Roadmaps become direction plus the next bet.** A roadmap promises scope and dates months ahead. Shape Up promises time, one cycle at a time. What stakeholders get instead is a short list of goals for the half year, what is in the current cycle, the shaped pitches waiting for the next table, and cooldown. No dates beyond the cycle. ML needs one extra rule: a date does not exist before the R&D bet ends. Tell stakeholders that an R&D bet starts in cycle X, the go/no-go decision comes at its end, and only then can anyone promise a delivery date.

**7. Defend the cycle from mid-cycle escalations.** Keep one definition of a real crisis, such as data loss or wrong outputs at scale. Everything else gets a soft no and goes on the requester’s own list. They can lobby for it at the next table. The book calls these decentralized lists and expects them. Escalations from executives go to whoever owns the betting table, not to the team.

**8. Say the no in the open.** Publish the outcome of every table: bet or not now. With no central backlog, there is no guilt pile, and each team keeps its own list and pitches again in six weeks.

---

## 11) Where Shape Up breaks for ML

Shape Up was written for product teams, and some of its assumptions do not hold in ML. Plan for these.

- **Lead times you do not control.** Labeling vendors, data access approvals and platform teams do not run on six-week cycles. Put the dependency in the pitch as a rabbit hole, or make unblocking it a small bet of its own.
- **Run work is not project work.** Retraining, monitoring and incident response continue after launch. Reserve cooldown and a small-batch slot for them, and treat anything bigger as a new pitch.
- **The team shape is different.** The book’s standard team is a designer and one or two programmers. For ML, a data scientist and an ML engineer, sometimes with a data engineer, is the closest equivalent. Keep it small.
- **Someone has to shape, and someone has to bet.** Shaping needs both the business problem and the technical risk in view, so a workable split is a lead data scientist with a product owner. In the book, shaping runs in parallel with the cycle, done by senior people who are not building. On a small team there is no separate shaping group. My plan is to shape alongside the product owner during the cycle and have the senior data scientists review technical risk in cooldown, before the betting table. The betting table needs people with the authority to commit a team for six weeks, such as the head of data or AI, an engineering lead and the product owner.
- **Some work does not fit.** Platform migrations and multi-quarter data programmes may exceed six weeks even after narrowing. Slice them into bets that each end with something working, or accept that the method is not a fit for them.

---

## 12) Run it in Linear

Linear has no hill chart and no betting table, but its building blocks[^7] are close enough to run the method with a few conventions. Check which features your plan includes.

**How the concepts map**

| Shape Up                    | Linear                          | Note                                                                                      |
| --------------------------- | ------------------------------- | ----------------------------------------------------------------------------------------- |
| Six-week cycle and cooldown | Cycles                          | Duration and cooldown are set in team settings                                            |
| Pitch and bet               | Project                         | The pitch lives in the description or a project document. Starting the project is the bet |
| Appetite                    | Project target date             | End of the cycle for a big batch                                                          |
| Bet type and batch size     | Project labels                  | R&D, Production, Cleanup, Small batch, Big batch                                          |
| Scopes                      | Project milestones              | Issues are grouped under each milestone                                                   |
| Nice-to-haves               | Issue label or `~` title prefix | For example a `nice-to-have` label                                                        |
| Hill chart and status       | Project updates with health     | On track, at risk, off track                                                              |
| Unshaped ideas              | Team backlog or Triage          | Never the cycle                                                                           |

**Setup, step by step**

1. **Configure the team.** Set the cycle to six weeks with a two-week cooldown[^5]. Linear moves unfinished issues into the next cycle automatically, so review and clear leftovers at the betting table instead of letting them carry over.
2. **Create a pitch template.** One project template with the headings: problem and metric, appetite, baseline, fat-marker solution, data assumptions, rabbit holes, no-gos, success and stop rule, stakeholder commitment.
3. **Run the betting table in cooldown.** Filter projects with a planned status. Bet only on the next cycle. A bet means the project starts, the target date is set to the cycle end, and the team is protected from interruptions.
4. **Map scopes to milestones.** Each milestone is a piece of the solution that can be finished independently, such as “label audit” or “evaluation harness”. Issues sit under milestones. Name milestones after the structure of the problem, not after people. Create them after week one, not at kickoff. Until then, keep the imagined tasks as plain issues.
5. **Run the hill by convention.** In every weekly project update[^6], add one line per milestone with its position, for example “Label audit: uphill, validated on a 10 percent sample”. Use health honestly: at risk when a critical scope is still uphill past the midpoint, off track when you are heading for the circuit breaker.
6. **Hammer scope visibly.** Tag nice-to-haves as they are discovered. Edge case findings from review start as nice-to-haves, and the team promotes the few that truly block a scope. Watch the project graph for scope that keeps growing.
7. **Enforce the circuit breaker.** At the deadline the project is completed, canceled, or sent back to backlog with a short update explaining the hole in the shaping. Any extension must meet the two conditions above and be logged in an update. Never move the target date quietly.
8. **Keep evidence close.** Link experiment tracker runs, notebooks and dashboards in project resources so the decision at the end of an R&D bet is traceable.

**A sample weekly update.** Post one like this on the project every week. The hill positions are the real status report. The content is illustrative.

```markdown
Health: At risk. Week 3 of 6.

Label audit: downhill. Done on the full sample, error rate 4 percent.
Promo features: uphill. Validated on one category, not yet on all.
Evaluation harness: downhill. Running nightly.
Scheduled job: not started, low risk.

Nice-to-have added: store level view. Marked ~, will be cut.
Risk: promo calendar gaps in two categories. Decision needed by Friday:
flag and continue, or cut promo features for those two categories.
```

**A cycle rhythm that works**

- Week 1: attack the riskiest unknowns. Get the first scopes uphill on real data.
- Weeks 2 and 3: validate approaches, move scopes over the top, post weekly updates.
- End of week 3: midpoint check. Anything still uphill triggers a conversation about what to hammer.
- Weeks 4 and 5: hammer scope, finish downhill work, deploy.
- Week 6: ship, document the decision, close the project.
- Cooldown: cleanup, drift review, shape the next pitches, hold the betting table.

---

## 13) Start with one cycle, then follow the recipe

You don't need to adopt everything at once.

Pick one problem. Write a one-page pitch with a baseline, an appetite and three no-gos. Decide whether it is an R&D bet or a Production bet. Create the project in Linear, set the target date, and post a weekly update with a hill position for each scope.

At the end of six weeks, ask two questions:

1. Did we ship something useful or make a decision supported by evidence?
2. Where did the rabbit hole open, and what should we change in the next pitch?

### The recipe, in one place

1. Decide how much time the problem is worth before you start.
2. Write down the baseline. If a simple rule meets the business need, you may not need ML.
3. Shape a pitch: problem, appetite, solution sketch, data assumptions, rabbit holes, no-gos, a stop rule and a stakeholder commitment.
4. Run an R&D bet when feasibility is unknown: inspect the data, build the evaluation skeleton, establish a baseline and make a decision.
5. Bet on a production cycle only after a go decision and a sufficiently shaped solution.
6. Push the scariest unknown uphill first, and validate assumptions with real data.
7. Hammer scope every week. Mark nice-to-haves and let most of them die.
8. Let the circuit breaker trip. Reshape or drop; never drift by default.
9. Use cooldown for cleanup, model health and the next pitches.
10. Make the work visible in Linear through cycles, projects, milestones and honest weekly updates.

The goal isn't a prettier process. It's a team that knows what it's betting on, how much it will pay, and when to stop.

The most valuable result isn't always a model in production. Sometimes it's discovering, early and cheaply, that the model shouldn't exist.

I'll be back after the first cycle with what actually happened. If you've already tried Shape Up on a data or ML team, I'd like to hear where it broke for you.

---

## Sources

[^1]: Ryan Singer, _Shape Up: Stop Running in Circles and Ship Work that Matters_, Basecamp, 2019. Free at [basecamp.com/shapeup](https://basecamp.com/shapeup).

[^2]: Martin Zinkevich, [Rules of Machine Learning](https://developers.google.com/machine-learning/guides/rules-of-ml/), Google.

[^3]: Andrej Karpathy, [A Recipe for Training Neural Networks](http://karpathy.github.io/2019/04/25/recipe/), April 2019.

[^4]: Eugene Yan, [The first rule of machine learning: start without machine learning](https://eugeneyan.com/writing/first-rule-of-ml/).

[^5]: Linear docs, [Use cycles](https://linear.app/docs/use-cycles) and the [cycle cooldown changelog](https://linear.app/changelog/2019-09-09-cycle-cooldown).

[^6]: Linear docs, [Project updates](https://linear.app/docs/project-updates).

[^7]: Linear, [Coordinating work](https://linear.app/enablement/guide/coordinating).
