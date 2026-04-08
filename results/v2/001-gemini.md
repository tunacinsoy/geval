
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
3.96s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 3.97s[0m[0m
                                                                                     Test Results                                                                                      
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Test case                                            ┃ Metric                                 ┃ Score                                               ┃ Status ┃ Overall Success Rate ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_terraform_coherence                  │                                        │                                                     │        │ 100.0%               │
│                                                      │ Contextual Terraform Coherence [GEval] │ 0.2 (threshold=0.1, evaluation model=gpt-5.4,       │ PASSED │                      │
│                                                      │                                        │ reason=The Terraform does provision a plausible     │        │                      │
│                                                      │                                        │ low-cost static site on AWS using S3 and            │        │                      │
│                                                      │                                        │ CloudFront, with sensible basic structure and       │        │                      │
│                                                      │                                        │ dependencies through a reusable module. However, it │        │                      │
│                                                      │                                        │ fails the key hidden context requirements: the      │        │                      │
│                                                      │                                        │ business processes EU residents' personal data, yet │        │                      │
│                                                      │                                        │ the output does not explicitly ensure GDPR-aligned  │        │                      │
│                                                      │                                        │ handling such as secure contact-form submission,    │        │                      │
│                                                      │                                        │ consent mechanisms, data-location considerations,   │        │                      │
│                                                      │                                        │ or encryption controls for any collected data. It   │        │                      │
│                                                      │                                        │ also hardcodes us-east-1 without addressing         │        │                      │
│                                                      │                                        │ geographic or compliance implications, and relies   │        │                      │
│                                                      │                                        │ on an opaque module without demonstrating HTTPS     │        │                      │
│                                                      │                                        │ enforcement or other required security measures, so │        │                      │
│                                                      │                                        │ it largely ignores the critical compliance          │        │                      │
│                                                      │                                        │ constraints in the test case., error=None)          │        │                      │
│ Note: Use Confident AI with DeepEval to analyze      │                                        │                                                     │        │                      │
│ failed test cases for more details                   │                                        │                                                     │        │                      │
└──────────────────────────────────────────────────────┴────────────────────────────────────────┴─────────────────────────────────────────────────────┴────────┴──────────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 4.44s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


