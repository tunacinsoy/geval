
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.09s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.10s[0m[0m
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
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform does     │        │                   │
│                   │                   │ provision a        │        │                   │
│                   │                   │ reliable database  │        │                   │
│                   │                   │ stack with RDS     │        │                   │
│                   │                   │ PostgreSQL,        │        │                   │
│                   │                   │ Multi-AZ, backups, │        │                   │
│                   │                   │ private            │        │                   │
│                   │                   │ networking,        │        │                   │
│                   │                   │ Secrets Manager,   │        │                   │
│                   │                   │ and S3 encryption, │        │                   │
│                   │                   │ which aligns with  │        │                   │
│                   │                   │ the explicit need  │        │                   │
│                   │                   │ for a proper       │        │                   │
│                   │                   │ database that the  │        │                   │
│                   │                   │ website can use    │        │                   │
│                   │                   │ without losing     │        │                   │
│                   │                   │ orders. However,   │        │                   │
│                   │                   │ it misses the key  │        │                   │
│                   │                   │ hidden context:    │        │                   │
│                   │                   │ European customer  │        │                   │
│                   │                   │ data and GDPR      │        │                   │
│                   │                   │ obligations. There │        │                   │
│                   │                   │ is no automated    │        │                   │
│                   │                   │ deletion workflow, │        │                   │
│                   │                   │ no data            │        │                   │
│                   │                   │ portability/export │        │                   │
│                   │                   │ mechanism tied to  │        │                   │
│                   │                   │ customer requests, │        │                   │
│                   │                   │ no retention       │        │                   │
│                   │                   │ controls for       │        │                   │
│                   │                   │ customer records   │        │                   │
│                   │                   │ in the database,   │        │                   │
│                   │                   │ and no             │        │                   │
│                   │                   │ compliance-aware   │        │                   │
│                   │                   │ design for Right   │        │                   │
│                   │                   │ to be Forgotten.   │        │                   │
│                   │                   │ Security is only   │        │                   │
│                   │                   │ partial:           │        │                   │
│                   │                   │ encryption at rest │        │                   │
│                   │                   │ is present for RDS │        │                   │
│                   │                   │ and S3, but there  │        │                   │
│                   │                   │ is no clear        │        │                   │
│                   │                   │ enforcement of     │        │                   │
│                   │                   │ secure transit to  │        │                   │
│                   │                   │ the database, IAM  │        │                   │
│                   │                   │ is overly broad in │        │                   │
│                   │                   │ places, and the    │        │                   │
│                   │                   │ solution adds      │        │                   │
│                   │                   │ unrelated          │        │                   │
│                   │                   │ ECS/Lambda         │        │                   │
│                   │                   │ components without │        │                   │
│                   │                   │ addressing the     │        │                   │
│                   │                   │ main compliance    │        │                   │
│                   │                   │ risk., error=None) │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 4.65s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


