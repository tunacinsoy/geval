
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.67s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.68s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.1                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ a plausible        │        │                   │
│                   │                   │ temporary          │        │                   │
│                   │                   │ playground stack   │        │                   │
│                   │                   │ with VPC, ALB,     │        │                   │
│                   │                   │ ASG, IAM,          │        │                   │
│                   │                   │ monitoring, and    │        │                   │
│                   │                   │ teardown           │        │                   │
│                   │                   │ reminders, so some │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ needs from the     │        │                   │
│                   │                   │ context are        │        │                   │
│                   │                   │ addressed.         │        │                   │
│                   │                   │ However, it        │        │                   │
│                   │                   │ completely misses  │        │                   │
│                   │                   │ the critical GDPR  │        │                   │
│                   │                   │ requirement in the │        │                   │
│                   │                   │ input: the test    │        │                   │
│                   │                   │ environment uses a │        │                   │
│                   │                   │ direct production  │        │                   │
│                   │                   │ snapshot           │        │                   │
│                   │                   │ containing EU      │        │                   │
│                   │                   │ minors' PII and    │        │                   │
│                   │                   │ disability data,   │        │                   │
│                   │                   │ which requires     │        │                   │
│                   │                   │ dynamic data       │        │                   │
│                   │                   │ masking or         │        │                   │
│                   │                   │ synthetic data     │        │                   │
│                   │                   │ generation. There  │        │                   │
│                   │                   │ are no database    │        │                   │
│                   │                   │ resources, no      │        │                   │
│                   │                   │ anonymization      │        │                   │
│                   │                   │ pipeline, no       │        │                   │
│                   │                   │ masking controls,  │        │                   │
│                   │                   │ no geographic      │        │                   │
│                   │                   │ restriction to an  │        │                   │
│                   │                   │ EU region, and no  │        │                   │
│                   │                   │ safeguards         │        │                   │
│                   │                   │ preventing use of  │        │                   │
│                   │                   │ real personal data │        │                   │
│                   │                   │ in non-production. │        │                   │
│                   │                   │ Security is also   │        │                   │
│                   │                   │ incomplete for the │        │                   │
│                   │                   │ sensitive          │        │                   │
│                   │                   │ scenario, with no  │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ encryption at rest │        │                   │
│                   │                   │ for S3, Secrets    │        │                   │
│                   │                   │ Manager, or EBS    │        │                   │
│                   │                   │ and no             │        │                   │
│                   │                   │ compliance-focused │        │                   │
│                   │                   │ transit/data       │        │                   │
│                   │                   │ handling controls, │        │                   │
│                   │                   │ so the output is   │        │                   │
│                   │                   │ largely            │        │                   │
│                   │                   │ non-compliant      │        │                   │
│                   │                   │ despite otherwise  │        │                   │
│                   │                   │ coherent resource  │        │                   │
│                   │                   │ dependencies.,     │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.21s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


