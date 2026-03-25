
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.82s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.82s[0m[0m
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
│                   │                   │ address the        │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ performance need   │        │                   │
│                   │                   │ with CloudFront,   │        │                   │
│                   │                   │ S3 origins,        │        │                   │
│                   │                   │ compression, TLS   │        │                   │
│                   │                   │ 1.2, OAI,          │        │                   │
│                   │                   │ KMS-encrypted      │        │                   │
│                   │                   │ buckets, logging,  │        │                   │
│                   │                   │ and WAF, so core   │        │                   │
│                   │                   │ CDN infrastructure │        │                   │
│                   │                   │ is present.        │        │                   │
│                   │                   │ However, it fails  │        │                   │
│                   │                   │ the key hidden     │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ requirement from   │        │                   │
│                   │                   │ the context: the   │        │                   │
│                   │                   │ site uses invasive │        │                   │
│                   │                   │ tracking and needs │        │                   │
│                   │                   │ infrastructure-le… │        │                   │
│                   │                   │ geo-blocking or    │        │                   │
│                   │                   │ localized          │        │                   │
│                   │                   │ GDPR-compliant     │        │                   │
│                   │                   │ consent handling.  │        │                   │
│                   │                   │ Although a geo     │        │                   │
│                   │                   │ restriction        │        │                   │
│                   │                   │ exists, it is a    │        │                   │
│                   │                   │ broad whitelist of │        │                   │
│                   │                   │ US, CA, GB, AU,    │        │                   │
│                   │                   │ and SG rather than │        │                   │
│                   │                   │ a                  │        │                   │
│                   │                   │ compliance-driven  │        │                   │
│                   │                   │ strategy for       │        │                   │
│                   │                   │ EU/EEA data        │        │                   │
│                   │                   │ transfer risk, and │        │                   │
│                   │                   │ there is no cookie │        │                   │
│                   │                   │ consent,           │        │                   │
│                   │                   │ localization, or   │        │                   │
│                   │                   │ ad/tracking        │        │                   │
│                   │                   │ control. The       │        │                   │
│                   │                   │ solution also      │        │                   │
│                   │                   │ forwards viewer    │        │                   │
│                   │                   │ country headers    │        │                   │
│                   │                   │ and enables global │        │                   │
│                   │                   │ delivery without   │        │                   │
│                   │                   │ holistically       │        │                   │
│                   │                   │ addressing GDPR or │        │                   │
│                   │                   │ cross-border       │        │                   │
│                   │                   │ transfer concerns, │        │                   │
│                   │                   │ so                 │        │                   │
│                   │                   │ security/complian… │        │                   │
│                   │                   │ alignment is weak  │        │                   │
│                   │                   │ despite otherwise  │        │                   │
│                   │                   │ solid resource     │        │                   │
│                   │                   │ coverage.,         │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.29s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


