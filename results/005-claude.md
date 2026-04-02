
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.25s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.26s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.2                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform does     │        │                   │
│                   │                   │ address the        │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ performance need   │        │                   │
│                   │                   │ with a CloudFront  │        │                   │
│                   │                   │ CDN, global edge   │        │                   │
│                   │                   │ delivery,          │        │                   │
│                   │                   │ HTTPS-only origin  │        │                   │
│                   │                   │ access,            │        │                   │
│                   │                   │ compression,       │        │                   │
│                   │                   │ caching behaviors, │        │                   │
│                   │                   │ logging, and       │        │                   │
│                   │                   │ monitoring.        │        │                   │
│                   │                   │ However, it fails  │        │                   │
│                   │                   │ the key hidden     │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ requirement from   │        │                   │
│                   │                   │ the context: the   │        │                   │
│                   │                   │ site uses invasive │        │                   │
│                   │                   │ tracking and user  │        │                   │
│                   │                   │ profiling, yet the │        │                   │
│                   │                   │ configuration      │        │                   │
│                   │                   │ explicitly sets    │        │                   │
│                   │                   │ geo_restriction to │        │                   │
│                   │                   │ none and adds an   │        │                   │
│                   │                   │ unrelated          │        │                   │
│                   │                   │ gdpr_tracking_str… │        │                   │
│                   │                   │ that could worsen  │        │                   │
│                   │                   │ cross-border data  │        │                   │
│                   │                   │ handling rather    │        │                   │
│                   │                   │ than mitigate it.  │        │                   │
│                   │                   │ There is no        │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ support for GDPR   │        │                   │
│                   │                   │ controls such as   │        │                   │
│                   │                   │ geo-blocking,      │        │                   │
│                   │                   │ regional           │        │                   │
│                   │                   │ restrictions, or   │        │                   │
│                   │                   │ consent-related    │        │                   │
│                   │                   │ handling, so       │        │                   │
│                   │                   │ despite sound CDN  │        │                   │
│                   │                   │ basics, the        │        │                   │
│                   │                   │ solution is        │        │                   │
│                   │                   │ non-compliant with │        │                   │
│                   │                   │ the context.,      │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.23s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


