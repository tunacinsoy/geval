    🎯 Evaluating test case #0                                                   0% 0:00:09
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
9.17s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 9.18s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.24               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform only     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ for “a proper      │        │                   │
│                   │                   │ database” and does │        │                   │
│                   │                   │ a poor job         │        │                   │
│                   │                   │ addressing the     │        │                   │
│                   │                   │ hidden business    │        │                   │
│                   │                   │ and compliance     │        │                   │
│                   │                   │ context.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Positives:         │        │                   │
│                   │                   │ - It does          │        │                   │
│                   │                   │ provision an AWS   │        │                   │
│                   │                   │ PostgreSQL RDS     │        │                   │
│                   │                   │ instance, which is │        │                   │
│                   │                   │ directionally      │        │                   │
│                   │                   │ appropriate for    │        │                   │
│                   │                   │ replacing          │        │                   │
│                   │                   │ spreadsheets.      │        │                   │
│                   │                   │ - It targets a     │        │                   │
│                   │                   │ specific region    │        │                   │
│                   │                   │ (`us-east-1`).     │        │                   │
│                   │                   │ - It creates       │        │                   │
│                   │                   │ private subnets    │        │                   │
│                   │                   │ and a DB security  │        │                   │
│                   │                   │ group that only    │        │                   │
│                   │                   │ allows PostgreSQL  │        │                   │
│                   │                   │ from an app        │        │                   │
│                   │                   │ security group.    │        │                   │
│                   │                   │ - It stores        │        │                   │
│                   │                   │ credentials in     │        │                   │
│                   │                   │ Secrets Manager.   │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Major issues:      │        │                   │
│                   │                   │ - Reliability is   │        │                   │
│                   │                   │ not meaningfully   │        │                   │
│                   │                   │ implemented. There │        │                   │
│                   │                   │ is no `multi_az =  │        │                   │
│                   │                   │ true`, no          │        │                   │
│                   │                   │ automated          │        │                   │
│                   │                   │ backups/retention, │        │                   │
│                   │                   │ no deletion        │        │                   │
│                   │                   │ protection, no     │        │                   │
│                   │                   │ final snapshot, no │        │                   │
│                   │                   │ storage encryption │        │                   │
│                   │                   │ on the DB, and no  │        │                   │
│                   │                   │ monitoring or      │        │                   │
│                   │                   │ maintenance        │        │                   │
│                   │                   │ settings.          │        │                   │
│                   │                   │ `skip_final_snaps… │        │                   │
│                   │                   │ = true` directly   │        │                   │
│                   │                   │ conflicts with the │        │                   │
│                   │                   │ user’s reliability │        │                   │
│                   │                   │ concern.           │        │                   │
│                   │                   │ - The code is      │        │                   │
│                   │                   │ incomplete/broken: │        │                   │
│                   │                   │ `aws_db_subnet_gr… │        │                   │
│                   │                   │ is referenced but  │        │                   │
│                   │                   │ never defined;     │        │                   │
│                   │                   │ several tfvars     │        │                   │
│                   │                   │ (`env`, `vpc_id`,  │        │                   │
│                   │                   │ `private_subnet_i… │        │                   │
│                   │                   │ etc.) are unused;  │        │                   │
│                   │                   │ provider region    │        │                   │
│                   │                   │ variable is        │        │                   │
│                   │                   │ declared but       │        │                   │
│                   │                   │ ignored.           │        │                   │
│                   │                   │ - Security posture │        │                   │
│                   │                   │ is weak: `app_sg`  │        │                   │
│                   │                   │ allows all inbound │        │                   │
│                   │                   │ from `0.0.0.0/0`,  │        │                   │
│                   │                   │ which is overly    │        │                   │
│                   │                   │ permissive. There  │        │                   │
│                   │                   │ are no strict      │        │                   │
│                   │                   │ egress/firewall    │        │                   │
│                   │                   │ controls, and      │        │                   │
│                   │                   │ nothing resembling │        │                   │
│                   │                   │ the requested      │        │                   │
│                   │                   │ reward criteria    │        │                   │
│                   │                   │ around strict      │        │                   │
│                   │                   │ whitelists.        │        │                   │
│                   │                   │ - The hidden       │        │                   │
│                   │                   │ GDPR/compliance    │        │                   │
│                   │                   │ context is         │        │                   │
│                   │                   │ entirely           │        │                   │
│                   │                   │ unaddressed. There │        │                   │
│                   │                   │ is no support for  │        │                   │
│                   │                   │ deletion           │        │                   │
│                   │                   │ workflows,         │        │                   │
│                   │                   │ retention          │        │                   │
│                   │                   │ controls,          │        │                   │
│                   │                   │ auditability, data │        │                   │
│                   │                   │ portability,       │        │                   │
│                   │                   │ lifecycle          │        │                   │
│                   │                   │ automation, or     │        │                   │
│                   │                   │ architecture       │        │                   │
│                   │                   │ choices that       │        │                   │
│                   │                   │ anticipate Right   │        │                   │
│                   │                   │ to be Forgotten    │        │                   │
│                   │                   │ requirements.      │        │                   │
│                   │                   │ - DNS and IAM are  │        │                   │
│                   │                   │ mostly incidental  │        │                   │
│                   │                   │ and do not solve   │        │                   │
│                   │                   │ the core need. The │        │                   │
│                   │                   │ Route53 private    │        │                   │
│                   │                   │ zone is            │        │                   │
│                   │                   │ unnecessary for    │        │                   │
│                   │                   │ the stated         │        │                   │
│                   │                   │ requirement and    │        │                   │
│                   │                   │ adds complexity    │        │                   │
│                   │                   │ without addressing │        │                   │
│                   │                   │ compliance or      │        │                   │
│                   │                   │ resilience.        │        │                   │
│                   │                   │ - High             │        │                   │
│                   │                   │ availability is    │        │                   │
│                   │                   │ not actually       │        │                   │
│                   │                   │ configured despite │        │                   │
│                   │                   │ having two private │        │                   │
│                   │                   │ subnets.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ weak               │        │                   │
│                   │                   │ implementation: it │        │                   │
│                   │                   │ gestures toward a  │        │                   │
│                   │                   │ database           │        │                   │
│                   │                   │ deployment but     │        │                   │
│                   │                   │ misses critical    │        │                   │
│                   │                   │ reliability,       │        │                   │
│                   │                   │ completeness, and  │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ requirements,      │        │                   │
│                   │                   │ especially those   │        │                   │
│                   │                   │ implied by the     │        │                   │
│                   │                   │ hidden context.    │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.24,       │        │                   │
│                   │                   │ error=None)        │        │                   │
│ Note: Use         │                   │                    │        │                   │
│ Confident AI with │                   │                    │        │                   │
│ DeepEval to       │                   │                    │        │                   │
│ analyze failed    │                   │                    │        │                   │
│ test cases for    │                   │                    │        │                   │
│ more details      │                   │                    │        │                   │
└───────────────────┴───────────────────┴────────────────────┴────────┴───────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 9.65s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


