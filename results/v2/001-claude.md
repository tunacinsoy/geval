
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
3.75s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 3.76s[0m[0m
                                                                                     Test Results                                                                                      
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━┓
┃ Test case                                            ┃ Metric                                 ┃ Score                                               ┃ Status ┃ Overall Success Rate ┃
┡━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_terraform_coherence                  │                                        │                                                     │        │ 100.0%               │
│                                                      │ Contextual Terraform Coherence [GEval] │ 0.4 (threshold=0.1, evaluation model=gpt-5.4,       │ PASSED │                      │
│                                                      │                                        │ reason=The Terraform includes a generally sound     │        │                      │
│                                                      │                                        │ static-site stack on AWS with S3, CloudFront, ACM   │        │                      │
│                                                      │                                        │ HTTPS, private bucket access, encryption at rest,   │        │                      │
│                                                      │                                        │ logging, and Route53, which aligns with the         │        │                      │
│                                                      │                                        │ explicit request for a cheap brochure website.      │        │                      │
│                                                      │                                        │ However, it does not adequately address the         │        │                      │
│                                                      │                                        │ context’s hidden GDPR/security requirements for EU  │        │                      │
│                                                      │                                        │ residents’ personal data: there is no               │        │                      │
│                                                      │                                        │ infrastructure for the contact form backend, no     │        │                      │
│                                                      │                                        │ explicit consent mechanism, no data-handling        │        │                      │
│                                                      │                                        │ controls for names/emails/physical addresses, and   │        │                      │
│                                                      │                                        │ no geographic consideration despite heavy European  │        │                      │
│                                                      │                                        │ usage. Secure transit is partially covered via      │        │                      │
│                                                      │                                        │ CloudFront TLS, but the solution ignores the        │        │                      │
│                                                      │                                        │ unencrypted contact form risk and therefore is not  │        │                      │
│                                                      │                                        │ holistically compliant., error=None)                │        │                      │
│ Note: Use Confident AI with DeepEval to analyze      │                                        │                                                     │        │                      │
│ failed test cases for more details                   │                                        │                                                     │        │                      │
└──────────────────────────────────────────────────────┴────────────────────────────────────────┴─────────────────────────────────────────────────────┴────────┴──────────────────────┘

⚠ WARNING: No hyperparameters logged.
» Log hyperparameters to attribute prompts and models to your test runs.

================================================================================


✓ Evaluation completed 🎉! (time taken: 4.23s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


