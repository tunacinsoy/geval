
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
6.03s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 6.04s[0m[0m
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
│                   │                   │ ASG, private       │        │                   │
│                   │                   │ subnets, teardown  │        │                   │
│                   │                   │ reminders, and     │        │                   │
│                   │                   │ some               │        │                   │
│                   │                   │ HTTPS/encryption   │        │                   │
│                   │                   │ elements, so the   │        │                   │
│                   │                   │ basic              │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ logic is partially │        │                   │
│                   │                   │ sound. However, it │        │                   │
│                   │                   │ completely misses  │        │                   │
│                   │                   │ the critical       │        │                   │
│                   │                   │ hidden GDPR        │        │                   │
│                   │                   │ requirement from   │        │                   │
│                   │                   │ the input: the     │        │                   │
│                   │                   │ test environment   │        │                   │
│                   │                   │ is based on a      │        │                   │
│                   │                   │ production         │        │                   │
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
│                   │                   │ masking pipeline,  │        │                   │
│                   │                   │ no anonymization   │        │                   │
│                   │                   │ controls, and the  │        │                   │
│                   │                   │ default region is  │        │                   │
│                   │                   │ us-east-1 rather   │        │                   │
│                   │                   │ than an EU         │        │                   │
│                   │                   │ location,          │        │                   │
│                   │                   │ violating          │        │                   │
│                   │                   │ geographic/compli… │        │                   │
│                   │                   │ expectations. It   │        │                   │
│                   │                   │ also lacks clear   │        │                   │
│                   │                   │ encryption-at-rest │        │                   │
│                   │                   │ settings for S3,   │        │                   │
│                   │                   │ Secrets Manager    │        │                   │
│                   │                   │ KMS configuration, │        │                   │
│                   │                   │ and other          │        │                   │
│                   │                   │ safeguards needed  │        │                   │
│                   │                   │ for sensitive data │        │                   │
│                   │                   │ handling, so it    │        │                   │
│                   │                   │ follows the vague  │        │                   │
│                   │                   │ playground request │        │                   │
│                   │                   │ into a             │        │                   │
│                   │                   │ non-compliant      │        │                   │
│                   │                   │ state.,            │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.51s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


