
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.20s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.21s[0m[0m
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
│                   │                   │ by creating a      │        │                   │
│                   │                   │ CloudFront         │        │                   │
│                   │                   │ distribution in    │        │                   │
│                   │                   │ front of an S3     │        │                   │
│                   │                   │ origin, with HTTPS │        │                   │
│                   │                   │ redirection, an    │        │                   │
│                   │                   │ ACM certificate,   │        │                   │
│                   │                   │ and an origin      │        │                   │
│                   │                   │ access identity    │        │                   │
│                   │                   │ plus bucket        │        │                   │
│                   │                   │ policy. However,   │        │                   │
│                   │                   │ it misses the key  │        │                   │
│                   │                   │ hidden compliance  │        │                   │
│                   │                   │ constraints from   │        │                   │
│                   │                   │ the context: the   │        │                   │
│                   │                   │ site uses invasive │        │                   │
│                   │                   │ tracking and       │        │                   │
│                   │                   │ targeted ads, yet  │        │                   │
│                   │                   │ the configuration  │        │                   │
│                   │                   │ sets CloudFront    │        │                   │
│                   │                   │ geo_restriction to │        │                   │
│                   │                   │ none and provides  │        │                   │
│                   │                   │ no infrastructure  │        │                   │
│                   │                   │ support for        │        │                   │
│                   │                   │ GDPR-related       │        │                   │
│                   │                   │ geographic         │        │                   │
│                   │                   │ restrictions or    │        │                   │
│                   │                   │ consent handling.  │        │                   │
│                   │                   │ Security is only   │        │                   │
│                   │                   │ partially covered  │        │                   │
│                   │                   │ with WAF and       │        │                   │
│                   │                   │ encrypted backend  │        │                   │
│                   │                   │ state, while       │        │                   │
│                   │                   │ origin bucket      │        │                   │
│                   │                   │ protections like   │        │                   │
│                   │                   │ explicit public    │        │                   │
│                   │                   │ access blocking or │        │                   │
│                   │                   │ bucket-side        │        │                   │
│                   │                   │ encryption are     │        │                   │
│                   │                   │ absent. Overall,   │        │                   │
│                   │                   │ the infrastructure │        │                   │
│                   │                   │ logic is mostly    │        │                   │
│                   │                   │ coherent for CDN   │        │                   │
│                   │                   │ delivery, but it   │        │                   │
│                   │                   │ blindly enables    │        │                   │
│                   │                   │ global             │        │                   │
│                   │                   │ distribution in a  │        │                   │
│                   │                   │ potentially        │        │                   │
│                   │                   │ non-compliant      │        │                   │
│                   │                   │ state.,            │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 4.75s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


