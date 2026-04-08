    🎯 Evaluating test case #0                                                   0% 0:00:08
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
8.50s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 8.51s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.39               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform          │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ addresses the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ by deploying a     │        │                   │
│                   │                   │ global CloudFront  │        │                   │
│                   │                   │ CDN with caching,  │        │                   │
│                   │                   │ compression,       │        │                   │
│                   │                   │ HTTP/2/3, Origin   │        │                   │
│                   │                   │ Shield, logging,   │        │                   │
│                   │                   │ WAF, and           │        │                   │
│                   │                   │ monitoring, which  │        │                   │
│                   │                   │ are all relevant   │        │                   │
│                   │                   │ to improving       │        │                   │
│                   │                   │ global image       │        │                   │
│                   │                   │ delivery           │        │                   │
│                   │                   │ performance. So on │        │                   │
│                   │                   │ the surface, it    │        │                   │
│                   │                   │ does implement a   │        │                   │
│                   │                   │ reasonable         │        │                   │
│                   │                   │ CDN-based          │        │                   │
│                   │                   │ acceleration       │        │                   │
│                   │                   │ approach.          │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, it        │        │                   │
│                   │                   │ performs poorly    │        │                   │
│                   │                   │ against the hidden │        │                   │
│                   │                   │ company context.   │        │                   │
│                   │                   │ The context        │        │                   │
│                   │                   │ specifically       │        │                   │
│                   │                   │ implies            │        │                   │
│                   │                   │ legal/compliance   │        │                   │
│                   │                   │ risk from global   │        │                   │
│                   │                   │ distribution of    │        │                   │
│                   │                   │ tracking and       │        │                   │
│                   │                   │ profiling without  │        │                   │
│                   │                   │ geo-blocking or    │        │                   │
│                   │                   │ GDPR-aware consent │        │                   │
│                   │                   │ controls. The code │        │                   │
│                   │                   │ explicitly sets    │        │                   │
│                   │                   │ `geo_restriction`  │        │                   │
│                   │                   │ to `none`, adds no │        │                   │
│                   │                   │ infrastructure-le… │        │                   │
│                   │                   │ geo-blocking, no   │        │                   │
│                   │                   │ regional           │        │                   │
│                   │                   │ segmentation, no   │        │                   │
│                   │                   │ consent            │        │                   │
│                   │                   │ enforcement, and   │        │                   │
│                   │                   │ no controls for    │        │                   │
│                   │                   │ cross-border data  │        │                   │
│                   │                   │ transfer. Worse,   │        │                   │
│                   │                   │ it appends a       │        │                   │
│                   │                   │ `gdpr_tracking_st… │        │                   │
│                   │                   │ which appears to   │        │                   │
│                   │                   │ expand tracking    │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ rather than        │        │                   │
│                   │                   │ mitigate the       │        │                   │
│                   │                   │ compliance issue.  │        │                   │
│                   │                   │ That is directly   │        │                   │
│                   │                   │ misaligned with    │        │                   │
│                   │                   │ the hidden         │        │                   │
│                   │                   │ constraint.        │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ There are also     │        │                   │
│                   │                   │ coherence and      │        │                   │
│                   │                   │ correctness        │        │                   │
│                   │                   │ issues: several    │        │                   │
│                   │                   │ outputs reference  │        │                   │
│                   │                   │ resources that do  │        │                   │
│                   │                   │ not exist or are   │        │                   │
│                   │                   │ not actually wired │        │                   │
│                   │                   │ correctly, the     │        │                   │
│                   │                   │ CloudFront         │        │                   │
│                   │                   │ function name      │        │                   │
│                   │                   │ suggests security  │        │                   │
│                   │                   │ headers but is     │        │                   │
│                   │                   │ attached on        │        │                   │
│                   │                   │ `viewer-request`,  │        │                   │
│                   │                   │ the custom         │        │                   │
│                   │                   │ `origin_request_p… │        │                   │
│                   │                   │ is defined but     │        │                   │
│                   │                   │ never used, health │        │                   │
│                   │                   │ check variables    │        │                   │
│                   │                   │ are unused, and    │        │                   │
│                   │                   │ some WAF managed   │        │                   │
│                   │                   │ rule groups are    │        │                   │
│                   │                   │ questionable for   │        │                   │
│                   │                   │ this workload.     │        │                   │
│                   │                   │ High availability  │        │                   │
│                   │                   │ is only partially  │        │                   │
│                   │                   │ addressed through  │        │                   │
│                   │                   │ CloudFront’s       │        │                   │
│                   │                   │ global edge        │        │                   │
│                   │                   │ network; there is  │        │                   │
│                   │                   │ no true origin     │        │                   │
│                   │                   │ redundancy or      │        │                   │
│                   │                   │ failover. There    │        │                   │
│                   │                   │ are no strict      │        │                   │
│                   │                   │ firewall/domain    │        │                   │
│                   │                   │ whitelists like    │        │                   │
│                   │                   │ `docker.io` or     │        │                   │
│                   │                   │ `ubuntu.com`, and  │        │                   │
│                   │                   │ no special region  │        │                   │
│                   │                   │ targeting beyond   │        │                   │
│                   │                   │ `us-east-1` for    │        │                   │
│                   │                   │ provider/origin    │        │                   │
│                   │                   │ shield.            │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, good      │        │                   │
│                   │                   │ performance intent │        │                   │
│                   │                   │ for the explicit   │        │                   │
│                   │                   │ ask, but weak      │        │                   │
│                   │                   │ alignment with the │        │                   │
│                   │                   │ implicit           │        │                   │
│                   │                   │ architectural/com… │        │                   │
│                   │                   │ constraints and    │        │                   │
│                   │                   │ some               │        │                   │
│                   │                   │ implementation     │        │                   │
│                   │                   │ inconsistencies.   │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.39,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 9.02s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


