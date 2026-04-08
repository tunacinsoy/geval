
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.02s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.03s[0m[0m
                                                                                     Test Results                                                                                      
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Test case                                            ┃ Metric                                 ┃ Score                                               ┃ Status ┃ Overall Success Rate ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_terraform_coherence                  │                                        │                                                     │        │ 100.0%               │
│                                                      │ Contextual Terraform Coherence [GEval] │ 0.6 (threshold=0.1, evaluation model=gpt-5.4,       │ PASSED │                      │
│                                                      │                                        │ reason=The Terraform covers many explicit needs     │        │                      │
│                                                      │                                        │ from the request: it creates S3 storage for HR      │        │                      │
│                                                      │                                        │ documents, enables versioning and MFA delete for    │        │                      │
│                                                      │                                        │ accidental deletion protection, blocks public       │        │                      │
│                                                      │                                        │ access, uses KMS encryption at rest, enforces TLS   │        │                      │
│                                                      │                                        │ via bucket policy, and adds IAM roles plus audit    │        │                      │
│                                                      │                                        │ logging. It also partially addresses hidden context │        │                      │
│                                                      │                                        │ by restricting regions to EU locations for GDPR and │        │                      │
│                                                      │                                        │ treating the data as confidential. However, for     │        │                      │
│                                                      │                                        │ special-category EU data like passports, health     │        │                      │
│                                                      │                                        │ screenings, and biometrics, the access model is not │        │                      │
│                                                      │                                        │ sufficiently strict: HR manager and staff roles do  │        │                      │
│                                                      │                                        │ not require MFA, bucket access is broad rather than │        │                      │
│                                                      │                                        │ limited to only a few office users, and there is no │        │                      │
│                                                      │                                        │ concrete support for data subject access requests   │        │                      │
│                                                      │                                        │ despite the context calling that out. There are     │        │                      │
│                                                      │                                        │ also correctness issues that weaken alignment, such │        │                      │
│                                                      │                                        │ as references to unsupported or questionable        │        │                      │
│                                                      │                                        │ resources/configurations like                       │        │                      │
│                                                      │                                        │ aws_cloudtrail_data_event_selector and MFA delete   │        │                      │
│                                                      │                                        │ in standard Terraform workflows, plus some          │        │                      │
│                                                      │                                        │ overbuilt components not tied to the user’s simple  │        │                      │
│                                                      │                                        │ request., error=None)                               │        │                      │
│ Note: Use Confident AI with DeepEval to analyze      │                                        │                                                     │        │                      │
│ failed test cases for more details                   │                                        │                                                     │        │                      │
└──────────────────────────────────────────────────────┴────────────────────────────────────────┴─────────────────────────────────────────────────────┴────────┴──────────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 4.57s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


