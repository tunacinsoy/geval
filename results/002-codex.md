
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.11s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.11s[0m[0m
                                                                                     Test Results                                                                                      
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Test case                                            ┃ Metric                                 ┃ Score                                               ┃ Status ┃ Overall Success Rate ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_terraform_coherence                  │                                        │                                                     │        │ 100.0%               │
│                                                      │ Contextual Terraform Coherence [GEval] │ 0.3 (threshold=0.1, evaluation model=gpt-5.4,       │ PASSED │                      │
│                                                      │                                        │ reason=The output includes a primary S3 bucket for  │        │                      │
│                                                      │                                        │ HR documents with KMS encryption, versioning,       │        │                      │
│                                                      │                                        │ object lock, private access blocking, internal      │        │                      │
│                                                      │                                        │ ALB/ECS placement, and audit logging, which         │        │                      │
│                                                      │                                        │ partially addresses the request for safe storage    │        │                      │
│                                                      │                                        │ and accidental deletion protection. However, it     │        │                      │
│                                                      │                                        │ misses key context-driven GDPR needs for            │        │                      │
│                                                      │                                        │ special-category EU personal data: there is no      │        │                      │
│                                                      │                                        │ explicit geographic restriction to EU regions,      │        │                      │
│                                                      │                                        │ replication defaults to us-west-2, no bucket policy │        │                      │
│                                                      │                                        │ enforces TLS or tightly limits access to only a few │        │                      │
│                                                      │                                        │ office users, and IAM grants broad ECS access       │        │                      │
│                                                      │                                        │ rather than least privilege for named personnel.    │        │                      │
│                                                      │                                        │ The design also adds unnecessary compute and        │        │                      │
│                                                      │                                        │ networking complexity, contains questionable or     │        │                      │
│                                                      │                                        │ invalid infrastructure choices like a VPC endpoint  │        │                      │
│                                                      │                                        │ service referencing an ALB, and does not address    │        │                      │
│                                                      │                                        │ data subject access request support, so overall     │        │                      │
│                                                      │                                        │ alignment with the explicit request and hidden      │        │                      │
│                                                      │                                        │ compliance constraints is weak., error=None)        │        │                      │
│ Note: Use Confident AI with DeepEval to analyze      │                                        │                                                     │        │                      │
│ failed test cases for more details                   │                                        │                                                     │        │                      │
└──────────────────────────────────────────────────────┴────────────────────────────────────────┴─────────────────────────────────────────────────────┴────────┴──────────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 4.59s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


