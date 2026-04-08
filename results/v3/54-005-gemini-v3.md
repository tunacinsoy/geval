    🎯 Evaluating test case #0                                                   0% 0:00:06
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
6.76s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 6.77s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.34               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform          │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ addresses the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ by putting         │        │                   │
│                   │                   │ CloudFront in      │        │                   │
│                   │                   │ front of an S3     │        │                   │
│                   │                   │ origin, which is a │        │                   │
│                   │                   │ reasonable way to  │        │                   │
│                   │                   │ improve global     │        │                   │
│                   │                   │ image delivery. It │        │                   │
│                   │                   │ also adds a WAF    │        │                   │
│                   │                   │ and uses ACM in    │        │                   │
│                   │                   │ us-east-1, which   │        │                   │
│                   │                   │ is appropriate for │        │                   │
│                   │                   │ CloudFront.        │        │                   │
│                   │                   │ However, the       │        │                   │
│                   │                   │ implementation is  │        │                   │
│                   │                   │ incomplete and     │        │                   │
│                   │                   │ somewhat           │        │                   │
│                   │                   │ inconsistent: the  │        │                   │
│                   │                   │ ACM certificate is │        │                   │
│                   │                   │ not validated, the │        │                   │
│                   │                   │ CloudFront         │        │                   │
│                   │                   │ distribution lacks │        │                   │
│                   │                   │ aliases for the    │        │                   │
│                   │                   │ custom domain, the │        │                   │
│                   │                   │ backend block uses │        │                   │
│                   │                   │ `lock_table`       │        │                   │
│                   │                   │ instead of the     │        │                   │
│                   │                   │ correct DynamoDB   │        │                   │
│                   │                   │ locking argument,  │        │                   │
│                   │                   │ and the required   │        │                   │
│                   │                   │ Terraform version  │        │                   │
│                   │                   │ `>= 1.14.7` is     │        │                   │
│                   │                   │ unrealistic. It    │        │                   │
│                   │                   │ also uses legacy   │        │                   │
│                   │                   │ CloudFront         │        │                   │
│                   │                   │ constructs         │        │                   │
│                   │                   │ (`forwarded_value… │        │                   │
│                   │                   │ OAI) rather than   │        │                   │
│                   │                   │ newer best         │        │                   │
│                   │                   │ practices.         │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ More importantly,  │        │                   │
│                   │                   │ it does not        │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ address the hidden │        │                   │
│                   │                   │ architectural/com… │        │                   │
│                   │                   │ constraints. The   │        │                   │
│                   │                   │ context implies a  │        │                   │
│                   │                   │ need for geo-aware │        │                   │
│                   │                   │ controls,          │        │                   │
│                   │                   │ GDPR-sensitive     │        │                   │
│                   │                   │ handling, and      │        │                   │
│                   │                   │ possibly           │        │                   │
│                   │                   │ geo-blocking or    │        │                   │
│                   │                   │ localized consent  │        │                   │
│                   │                   │ support before     │        │                   │
│                   │                   │ globally           │        │                   │
│                   │                   │ distributing       │        │                   │
│                   │                   │ content that       │        │                   │
│                   │                   │ includes invasive  │        │                   │
│                   │                   │ tracking. The code │        │                   │
│                   │                   │ explicitly sets    │        │                   │
│                   │                   │ `geo_restriction`  │        │                   │
│                   │                   │ to `none`, adds no │        │                   │
│                   │                   │ country            │        │                   │
│                   │                   │ restrictions, no   │        │                   │
│                   │                   │ regional routing   │        │                   │
│                   │                   │ logic, no          │        │                   │
│                   │                   │ consent-related    │        │                   │
│                   │                   │ edge behavior, and │        │                   │
│                   │                   │ no safeguards      │        │                   │
│                   │                   │ around             │        │                   │
│                   │                   │ cross-border data  │        │                   │
│                   │                   │ exposure. The WAF  │        │                   │
│                   │                   │ only enables a     │        │                   │
│                   │                   │ generic managed    │        │                   │
│                   │                   │ rule set and does  │        │                   │
│                   │                   │ not implement any  │        │                   │
│                   │                   │ strict allowlists  │        │                   │
│                   │                   │ or targeted        │        │                   │
│                   │                   │ firewall controls. │        │                   │
│                   │                   │ There is also no   │        │                   │
│                   │                   │ real               │        │                   │
│                   │                   │ high-availability  │        │                   │
│                   │                   │ or redundancy      │        │                   │
│                   │                   │ design beyond      │        │                   │
│                   │                   │ using CloudFront   │        │                   │
│                   │                   │ itself, and no     │        │                   │
│                   │                   │ special region     │        │                   │
│                   │                   │ targeting beyond   │        │                   │
│                   │                   │ the provider being │        │                   │
│                   │                   │ set to us-east-1.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ decent start for   │        │                   │
│                   │                   │ CDN acceleration,  │        │                   │
│                   │                   │ but it mostly      │        │                   │
│                   │                   │ satisfies only the │        │                   │
│                   │                   │ surface-level      │        │                   │
│                   │                   │ performance        │        │                   │
│                   │                   │ request and misses │        │                   │
│                   │                   │ the deeper         │        │                   │
│                   │                   │ compliance and     │        │                   │
│                   │                   │ architectural      │        │                   │
│                   │                   │ implications in    │        │                   │
│                   │                   │ the hidden         │        │                   │
│                   │                   │ context.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.34,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 7.3s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


