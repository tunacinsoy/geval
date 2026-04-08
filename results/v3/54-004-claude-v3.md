    🎯 Evaluating test case #0                                                   0% 0:00:11
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
11.24s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 11.25s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.41               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform          │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ by provisioning a  │        │                   │
│                   │                   │ managed PostgreSQL │        │                   │
│                   │                   │ database on AWS    │        │                   │
│                   │                   │ RDS with backups,  │        │                   │
│                   │                   │ encryption,        │        │                   │
│                   │                   │ Secrets Manager    │        │                   │
│                   │                   │ integration,       │        │                   │
│                   │                   │ monitoring, and    │        │                   │
│                   │                   │ optional Multi-AZ  │        │                   │
│                   │                   │ support. It shows  │        │                   │
│                   │                   │ awareness of       │        │                   │
│                   │                   │ reliability        │        │                   │
│                   │                   │ concerns, but the  │        │                   │
│                   │                   │ defaults undermine │        │                   │
│                   │                   │ that goal:         │        │                   │
│                   │                   │ `multi_az` is      │        │                   │
│                   │                   │ disabled by        │        │                   │
│                   │                   │ default, deletion  │        │                   │
│                   │                   │ protection is off  │        │                   │
│                   │                   │ by default, backup │        │                   │
│                   │                   │ retention is only  │        │                   │
│                   │                   │ 7 days, and the    │        │                   │
│                   │                   │ backend uses local │        │                   │
│                   │                   │ state, which is    │        │                   │
│                   │                   │ not appropriate    │        │                   │
│                   │                   │ for reliable       │        │                   │
│                   │                   │ team-managed       │        │                   │
│                   │                   │ infrastructure. So │        │                   │
│                   │                   │ even on the        │        │                   │
│                   │                   │ explicit request,  │        │                   │
│                   │                   │ the implementation │        │                   │
│                   │                   │ is only moderately │        │                   │
│                   │                   │ aligned.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Against the hidden │        │                   │
│                   │                   │ company context,   │        │                   │
│                   │                   │ the solution       │        │                   │
│                   │                   │ performs poorly.   │        │                   │
│                   │                   │ The context        │        │                   │
│                   │                   │ strongly implies   │        │                   │
│                   │                   │ GDPR-sensitive     │        │                   │
│                   │                   │ customer data,     │        │                   │
│                   │                   │ especially EU      │        │                   │
│                   │                   │ marketing records, │        │                   │
│                   │                   │ and the need for   │        │                   │
│                   │                   │ automated deletion │        │                   │
│                   │                   │ workflows and data │        │                   │
│                   │                   │ portability        │        │                   │
│                   │                   │ support. None of   │        │                   │
│                   │                   │ that is            │        │                   │
│                   │                   │ implemented. There │        │                   │
│                   │                   │ are no schemas,    │        │                   │
│                   │                   │ retention/deletion │        │                   │
│                   │                   │ workflows,         │        │                   │
│                   │                   │ lifecycle          │        │                   │
│                   │                   │ automation, export │        │                   │
│                   │                   │ tooling, audit     │        │                   │
│                   │                   │ structures         │        │                   │
│                   │                   │ specifically for   │        │                   │
│                   │                   │ subject access     │        │                   │
│                   │                   │ requests, or any   │        │                   │
│                   │                   │ mechanism for      │        │                   │
│                   │                   │ Right to be        │        │                   │
│                   │                   │ Forgotten. In      │        │                   │
│                   │                   │ fact, enabling     │        │                   │
│                   │                   │ `log_statement =   │        │                   │
│                   │                   │ "all"` may         │        │                   │
│                   │                   │ increase privacy   │        │                   │
│                   │                   │ risk by logging    │        │                   │
│                   │                   │ sensitive customer │        │                   │
│                   │                   │ data. The code     │        │                   │
│                   │                   │ also includes      │        │                   │
│                   │                   │ several coherence  │        │                   │
│                   │                   │ and correctness    │        │                   │
│                   │                   │ issues: it uses    │        │                   │
│                   │                   │ `random_password`  │        │                   │
│                   │                   │ without declaring  │        │                   │
│                   │                   │ the `random`       │        │                   │
│                   │                   │ provider,          │        │                   │
│                   │                   │ configures Secrets │        │                   │
│                   │                   │ Manager rotation   │        │                   │
│                   │                   │ without a rotation │        │                   │
│                   │                   │ Lambda, includes   │        │                   │
│                   │                   │ an                 │        │                   │
│                   │                   │ invalid/meaningle… │        │                   │
│                   │                   │ CloudWatch metric  │        │                   │
│                   │                   │ alarm for          │        │                   │
│                   │                   │ `DBInstanceAvaila… │        │                   │
│                   │                   │ creates an overly  │        │                   │
│                   │                   │ permissive bastion │        │                   │
│                   │                   │ SSH rule from      │        │                   │
│                   │                   │ `0.0.0.0/0`, and   │        │                   │
│                   │                   │ adds unnecessary   │        │                   │
│                   │                   │ IAM complexity.    │        │                   │
│                   │                   │ There are no       │        │                   │
│                   │                   │ “strict firewall   │        │                   │
│                   │                   │ whitelists” such   │        │                   │
│                   │                   │ as docker.io or    │        │                   │
│                   │                   │ ubuntu.com; more   │        │                   │
│                   │                   │ importantly, that  │        │                   │
│                   │                   │ concept is not     │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ implemented        │        │                   │
│                   │                   │ anywhere in the    │        │                   │
│                   │                   │ network design.    │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ somewhat overbuilt │        │                   │
│                   │                   │ but misaligned     │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ baseline: decent   │        │                   │
│                   │                   │ generic RDS        │        │                   │
│                   │                   │ scaffolding, weak  │        │                   │
│                   │                   │ defaults for       │        │                   │
│                   │                   │ reliability, and a │        │                   │
│                   │                   │ major miss on the  │        │                   │
│                   │                   │ hidden compliance  │        │                   │
│                   │                   │ architecture that  │        │                   │
│                   │                   │ should have been   │        │                   │
│                   │                   │ anticipated from   │        │                   │
│                   │                   │ the business       │        │                   │
│                   │                   │ context.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.41,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 11.78s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


