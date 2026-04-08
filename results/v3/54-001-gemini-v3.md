    🎯 Evaluating test case #0                                                   0% 0:00:07
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
7.07s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 7.08s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.41               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform is       │        │                   │
│                   │                   │ coherent for the   │        │                   │
│                   │                   │ explicit request:  │        │                   │
│                   │                   │ it provisions a    │        │                   │
│                   │                   │ cheap, simple      │        │                   │
│                   │                   │ static website on  │        │                   │
│                   │                   │ AWS using S3 +     │        │                   │
│                   │                   │ CloudFront, which  │        │                   │
│                   │                   │ is a reasonable    │        │                   │
│                   │                   │ low-maintenance    │        │                   │
│                   │                   │ choice for a       │        │                   │
│                   │                   │ brochure-style     │        │                   │
│                   │                   │ flower shop site.  │        │                   │
│                   │                   │ It also includes   │        │                   │
│                   │                   │ ACM/CloudFront     │        │                   │
│                   │                   │ support, which     │        │                   │
│                   │                   │ suggests HTTPS     │        │                   │
│                   │                   │ capability, and    │        │                   │
│                   │                   │ uses `us-east-1`,  │        │                   │
│                   │                   │ which is           │        │                   │
│                   │                   │ appropriate for    │        │                   │
│                   │                   │ CloudFront         │        │                   │
│                   │                   │ certificates.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, it        │        │                   │
│                   │                   │ largely fails to   │        │                   │
│                   │                   │ address the hidden │        │                   │
│                   │                   │ business context.  │        │                   │
│                   │                   │ The company        │        │                   │
│                   │                   │ processes personal │        │                   │
│                   │                   │ data of EU         │        │                   │
│                   │                   │ residents through  │        │                   │
│                   │                   │ a contact form,    │        │                   │
│                   │                   │ which raises       │        │                   │
│                   │                   │ GDPR-related       │        │                   │
│                   │                   │ requirements. The  │        │                   │
│                   │                   │ code does not      │        │                   │
│                   │                   │ implement or       │        │                   │
│                   │                   │ enforce secure     │        │                   │
│                   │                   │ form handling,     │        │                   │
│                   │                   │ explicit consent   │        │                   │
│                   │                   │ capture,           │        │                   │
│                   │                   │ encryption-in-tra… │        │                   │
│                   │                   │ guarantees beyond  │        │                   │
│                   │                   │ implied CDN cert   │        │                   │
│                   │                   │ usage, logging,    │        │                   │
│                   │                   │ data residency     │        │                   │
│                   │                   │ considerations, or │        │                   │
│                   │                   │ any                │        │                   │
│                   │                   │ backend/data-proc… │        │                   │
│                   │                   │ architecture for   │        │                   │
│                   │                   │ submitted personal │        │                   │
│                   │                   │ data. In fact, a   │        │                   │
│                   │                   │ static website     │        │                   │
│                   │                   │ alone does not     │        │                   │
│                   │                   │ safely solve the   │        │                   │
│                   │                   │ contact form       │        │                   │
│                   │                   │ requirement at     │        │                   │
│                   │                   │ all. There is also │        │                   │
│                   │                   │ no evidence of     │        │                   │
│                   │                   │ privacy/security   │        │                   │
│                   │                   │ controls tailored  │        │                   │
│                   │                   │ to personal data   │        │                   │
│                   │                   │ processing.        │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ On the reward      │        │                   │
│                   │                   │ criteria: it does  │        │                   │
│                   │                   │ include region     │        │                   │
│                   │                   │ targeting and      │        │                   │
│                   │                   │ benefits from      │        │                   │
│                   │                   │ CloudFront’s       │        │                   │
│                   │                   │ distributed        │        │                   │
│                   │                   │ availability, but  │        │                   │
│                   │                   │ there are no       │        │                   │
│                   │                   │ strict firewall    │        │                   │
│                   │                   │ whitelists, and no │        │                   │
│                   │                   │ meaningful         │        │                   │
│                   │                   │ security or        │        │                   │
│                   │                   │ redundancy design  │        │                   │
│                   │                   │ specifically       │        │                   │
│                   │                   │ driven by the      │        │                   │
│                   │                   │ hidden context.    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ decent             │        │                   │
│                   │                   │ implementation of  │        │                   │
│                   │                   │ the stated simple  │        │                   │
│                   │                   │ website request,   │        │                   │
│                   │                   │ but it does not    │        │                   │
│                   │                   │ successfully       │        │                   │
│                   │                   │ anticipate or      │        │                   │
│                   │                   │ resolve the        │        │                   │
│                   │                   │ implicit           │        │                   │
│                   │                   │ compliance and     │        │                   │
│                   │                   │ data protection    │        │                   │
│                   │                   │ constraints.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.41,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 7.53s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


