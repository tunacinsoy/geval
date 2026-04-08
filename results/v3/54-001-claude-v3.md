    🎯 Evaluating test case #0                                                   0% 0:00:08
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
8.80s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 8.81s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.46               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform fits the │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ reasonably well:   │        │                   │
│                   │                   │ it provisions a    │        │                   │
│                   │                   │ low-ops static     │        │                   │
│                   │                   │ website stack on   │        │                   │
│                   │                   │ AWS using S3,      │        │                   │
│                   │                   │ CloudFront,        │        │                   │
│                   │                   │ Route53, and ACM,  │        │                   │
│                   │                   │ which is a         │        │                   │
│                   │                   │ sensible           │        │                   │
│                   │                   │ cheap/simple       │        │                   │
│                   │                   │ architecture for a │        │                   │
│                   │                   │ brochure site. It  │        │                   │
│                   │                   │ also adds some     │        │                   │
│                   │                   │ good baseline      │        │                   │
│                   │                   │ practices like     │        │                   │
│                   │                   │ HTTPS at the CDN,  │        │                   │
│                   │                   │ private S3 origin  │        │                   │
│                   │                   │ access, encryption │        │                   │
│                   │                   │ at rest, logging,  │        │                   │
│                   │                   │ and monitoring.    │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, it does   │        │                   │
│                   │                   │ not successfully   │        │                   │
│                   │                   │ address the hidden │        │                   │
│                   │                   │ business context.  │        │                   │
│                   │                   │ The company        │        │                   │
│                   │                   │ processes personal │        │                   │
│                   │                   │ data of EU         │        │                   │
│                   │                   │ residents through  │        │                   │
│                   │                   │ a contact form,    │        │                   │
│                   │                   │ which raises       │        │                   │
│                   │                   │ GDPR-related       │        │                   │
│                   │                   │ requirements       │        │                   │
│                   │                   │ around secure      │        │                   │
│                   │                   │ transmission,      │        │                   │
│                   │                   │ consent, and       │        │                   │
│                   │                   │ likely             │        │                   │
│                   │                   │ regional/data-han… │        │                   │
│                   │                   │ considerations.    │        │                   │
│                   │                   │ This code only     │        │                   │
│                   │                   │ covers static      │        │                   │
│                   │                   │ hosting and does   │        │                   │
│                   │                   │ not implement the  │        │                   │
│                   │                   │ contact form       │        │                   │
│                   │                   │ backend at all, so │        │                   │
│                   │                   │ it neither secures │        │                   │
│                   │                   │ form submission    │        │                   │
│                   │                   │ end-to-end nor     │        │                   │
│                   │                   │ provides any       │        │                   │
│                   │                   │ consent capture    │        │                   │
│                   │                   │ mechanism. It also │        │                   │
│                   │                   │ defaults to        │        │                   │
│                   │                   │ `us-east-1`, which │        │                   │
│                   │                   │ is not ideal given │        │                   │
│                   │                   │ the EU-heavy       │        │                   │
│                   │                   │ customer base and  │        │                   │
│                   │                   │ potential data     │        │                   │
│                   │                   │ residency          │        │                   │
│                   │                   │ concerns. There is │        │                   │
│                   │                   │ no explicit        │        │                   │
│                   │                   │ handling of        │        │                   │
│                   │                   │ personal data      │        │                   │
│                   │                   │ storage, no WAF,   │        │                   │
│                   │                   │ no form encryption │        │                   │
│                   │                   │ workflow beyond    │        │                   │
│                   │                   │ HTTPS delivery, no │        │                   │
│                   │                   │ consent            │        │                   │
│                   │                   │ banner/mechanism,  │        │                   │
│                   │                   │ and no             │        │                   │
│                   │                   │ privacy/security   │        │                   │
│                   │                   │ controls tailored  │        │                   │
│                   │                   │ to GDPR            │        │                   │
│                   │                   │ obligations.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ There are also     │        │                   │
│                   │                   │ some technical     │        │                   │
│                   │                   │ coherence issues:  │        │                   │
│                   │                   │ ACM for CloudFront │        │                   │
│                   │                   │ must be in         │        │                   │
│                   │                   │ `us-east-1`, but   │        │                   │
│                   │                   │ the provider is    │        │                   │
│                   │                   │ globally           │        │                   │
│                   │                   │ parameterized and  │        │                   │
│                   │                   │ Route53 zone       │        │                   │
│                   │                   │ creation assumes   │        │                   │
│                   │                   │ the apex domain is │        │                   │
│                   │                   │ managed here. Some │        │                   │
│                   │                   │ CloudFront policy  │        │                   │
│                   │                   │ choices are        │        │                   │
│                   │                   │ inconsistent       │        │                   │
│                   │                   │ (`Managed-Caching… │        │                   │
│                   │                   │ labeled as long    │        │                   │
│                   │                   │ TTL), and the      │        │                   │
│                   │                   │ monitoring/alarm   │        │                   │
│                   │                   │ setup is partially │        │                   │
│                   │                   │ duplicative. High  │        │                   │
│                   │                   │ availability is    │        │                   │
│                   │                   │ implicitly decent  │        │                   │
│                   │                   │ via S3 +           │        │                   │
│                   │                   │ CloudFront, but    │        │                   │
│                   │                   │ there are no       │        │                   │
│                   │                   │ strict firewall    │        │                   │
│                   │                   │ whitelists, and    │        │                   │
│                   │                   │ those are not      │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ implemented here.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ decent static-site │        │                   │
│                   │                   │ baseline for the   │        │                   │
│                   │                   │ explicit ask, but  │        │                   │
│                   │                   │ it falls short on  │        │                   │
│                   │                   │ the implicit       │        │                   │
│                   │                   │ compliance and     │        │                   │
│                   │                   │ data-protection    │        │                   │
│                   │                   │ architecture the   │        │                   │
│                   │                   │ hidden context     │        │                   │
│                   │                   │ requires.          │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.46,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 9.26s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


