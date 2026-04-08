
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
3.85s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 3.86s[0m[0m
                                                                                     Test Results                                                                                      
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Test case                                            ┃ Metric                                 ┃ Score                                               ┃ Status ┃ Overall Success Rate ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_terraform_coherence                  │                                        │                                                     │        │ 100.0%               │
│                                                      │ Contextual Terraform Coherence [GEval] │ 0.3 (threshold=0.1, evaluation model=gpt-5.4,       │ PASSED │                      │
│                                                      │                                        │ reason=The Terraform creates a private S3 bucket    │        │                      │
│                                                      │                                        │ with versioning, public access blocks, SSE-S3       │        │                      │
│                                                      │                                        │ encryption, and a bucket policy enforcing TLS,      │        │                      │
│                                                      │                                        │ which partially addresses safe storage and          │        │                      │
│                                                      │                                        │ accidental deletion. However, it misses key         │        │                      │
│                                                      │                                        │ GDPR-driven requirements from the context: the      │        │                      │
│                                                      │                                        │ default region is us-east-1 despite EU citizen      │        │                      │
│                                                      │                                        │ special-category data implying geographic           │        │                      │
│                                                      │                                        │ restrictions, access control is weak because an IAM │        │                      │
│                                                      │                                        │ group alone does not ensure only a few office staff │        │                      │
│                                                      │                                        │ can access it, and the policy even allows           │        │                      │
│                                                      │                                        │ s3:DeleteObject, undermining the                    │        │                      │
│                                                      │                                        │ deletion-protection request. It also lacks stronger │        │                      │
│                                                      │                                        │ controls such as KMS-based encryption, object       │        │                      │
│                                                      │                                        │ lock/MFA delete, audit/logging, and any support for │        │                      │
│                                                      │                                        │ data subject access request handling., error=None)  │        │                      │
│ Note: Use Confident AI with DeepEval to analyze      │                                        │                                                     │        │                      │
│ failed test cases for more details                   │                                        │                                                     │        │                      │
└──────────────────────────────────────────────────────┴────────────────────────────────────────┴─────────────────────────────────────────────────────┴────────┴──────────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 4.32s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


