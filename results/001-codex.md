
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
2.95s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 2.95s[0m[0m
                                                                                     Test Results                                                                                      
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Test case                                            ┃ Metric                                 ┃ Score                                               ┃ Status ┃ Overall Success Rate ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_terraform_coherence                  │                                        │                                                     │        │ 100.0%               │
│                                                      │ Contextual Terraform Coherence [GEval] │ 0.4 (threshold=0.1, evaluation model=gpt-5.4,       │ PASSED │                      │
│                                                      │                                        │ reason=The Terraform includes a reasonable low-cost │        │                      │
│                                                      │                                        │ static site design for the explicit request, with   │        │                      │
│                                                      │                                        │ S3, CloudFront, Route53, ACM, HTTPS redirection,    │        │                      │
│                                                      │                                        │ private bucket access, and S3 encryption at rest.   │        │                      │
│                                                      │                                        │ However, it does not address the key hidden GDPR    │        │                      │
│                                                      │                                        │ requirements from the context: there is no          │        │                      │
│                                                      │                                        │ infrastructure for the contact form handling names, │        │                      │
│                                                      │                                        │ emails, and physical addresses, no explicit consent │        │                      │
│                                                      │                                        │ mechanism, no data residency or geographic          │        │                      │
│                                                      │                                        │ restriction strategy for EU personal data, and no   │        │                      │
│                                                      │                                        │ clear protection for personal data processing       │        │                      │
│                                                      │                                        │ beyond transport encryption. It also has            │        │                      │
│                                                      │                                        │ implementation issues such as duplicate             │        │                      │
│                                                      │                                        │ aws_caller_identity data blocks and questionable    │        │                      │
│                                                      │                                        │ CloudFront OAC bucket policy usage, which weakens   │        │                      │
│                                                      │                                        │ correctness and compliance alignment., error=None)  │        │                      │
│ Note: Use Confident AI with DeepEval to analyze      │                                        │                                                     │        │                      │
│ failed test cases for more details                   │                                        │                                                     │        │                      │
└──────────────────────────────────────────────────────┴────────────────────────────────────────┴─────────────────────────────────────────────────────┴────────┴──────────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 3.42s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


