
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.25s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.25s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.2                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The output  │        │                   │
│                   │                   │ does provision a   │        │                   │
│                   │                   │ basic PostgreSQL   │        │                   │
│                   │                   │ RDS instance with  │        │                   │
│                   │                   │ subnet/security    │        │                   │
│                   │                   │ group references   │        │                   │
│                   │                   │ and some           │        │                   │
│                   │                   │ reliability-relat… │        │                   │
│                   │                   │ pieces like        │        │                   │
│                   │                   │ private DNS and    │        │                   │
│                   │                   │ remote state       │        │                   │
│                   │                   │ locking, which     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ addresses the      │        │                   │
│                   │                   │ request for a      │        │                   │
│                   │                   │ proper database.   │        │                   │
│                   │                   │ However, it misses │        │                   │
│                   │                   │ major requirements │        │                   │
│                   │                   │ and hidden         │        │                   │
│                   │                   │ constraints from   │        │                   │
│                   │                   │ the context: there │        │                   │
│                   │                   │ is nothing for     │        │                   │
│                   │                   │ GDPR Right to be   │        │                   │
│                   │                   │ Forgotten or data  │        │                   │
│                   │                   │ portability        │        │                   │
│                   │                   │ workflows despite  │        │                   │
│                   │                   │ EU customer data   │        │                   │
│                   │                   │ being explicitly   │        │                   │
│                   │                   │ noted, no          │        │                   │
│                   │                   │ encryption at rest │        │                   │
│                   │                   │ is configured on   │        │                   │
│                   │                   │ the DB, no clear   │        │                   │
│                   │                   │ enforcement of     │        │                   │
│                   │                   │ secure transit,    │        │                   │
│                   │                   │ and the region is  │        │                   │
│                   │                   │ fixed to us-east-1 │        │                   │
│                   │                   │ with no            │        │                   │
│                   │                   │ consideration of   │        │                   │
│                   │                   │ geographic/compli… │        │                   │
│                   │                   │ implications.      │        │                   │
│                   │                   │ Reliability is     │        │                   │
│                   │                   │ also weak because  │        │                   │
│                   │                   │ the DB lacks       │        │                   │
│                   │                   │ Multi-AZ or        │        │                   │
│                   │                   │ backups and even   │        │                   │
│                   │                   │ sets               │        │                   │
│                   │                   │ skip_final_snapsh… │        │                   │
│                   │                   │ = true. The        │        │                   │
│                   │                   │ Terraform is       │        │                   │
│                   │                   │ additionally       │        │                   │
│                   │                   │ incomplete or      │        │                   │
│                   │                   │ inconsistent,      │        │                   │
│                   │                   │ referencing        │        │                   │
│                   │                   │ aws_db_subnet_gro… │        │                   │
│                   │                   │ without defining   │        │                   │
│                   │                   │ it and including   │        │                   │
│                   │                   │ unrelated tfvars   │        │                   │
│                   │                   │ entries.,          │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 4.81s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


