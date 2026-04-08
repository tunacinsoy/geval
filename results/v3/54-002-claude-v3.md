    🎯 Evaluating test case #0                                                   0% 0:00:10
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
10.73s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 10.74s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.78               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform goes     │        │                   │
│                   │                   │ well beyond the    │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ of “safe HR        │        │                   │
│                   │                   │ document storage   │        │                   │
│                   │                   │ with limited       │        │                   │
│                   │                   │ access and         │        │                   │
│                   │                   │ accidental         │        │                   │
│                   │                   │ deletion           │        │                   │
│                   │                   │ protection.” It    │        │                   │
│                   │                   │ provisions private │        │                   │
│                   │                   │ S3 storage,        │        │                   │
│                   │                   │ versioning, MFA    │        │                   │
│                   │                   │ delete intent, KMS │        │                   │
│                   │                   │ encryption, audit  │        │                   │
│                   │                   │ logging,           │        │                   │
│                   │                   │ monitoring, and    │        │                   │
│                   │                   │ cross-region       │        │                   │
│                   │                   │ replication in EU  │        │                   │
│                   │                   │ regions, which     │        │                   │
│                   │                   │ shows strong       │        │                   │
│                   │                   │ anticipation of    │        │                   │
│                   │                   │ the hidden         │        │                   │
│                   │                   │ GDPR-sensitive     │        │                   │
│                   │                   │ context. It also   │        │                   │
│                   │                   │ targets EU regions │        │                   │
│                   │                   │ only, which is a   │        │                   │
│                   │                   │ meaningful         │        │                   │
│                   │                   │ compliance-aware   │        │                   │
│                   │                   │ design choice, and │        │                   │
│                   │                   │ includes           │        │                   │
│                   │                   │ role-based access  │        │                   │
│                   │                   │ plus CloudTrail    │        │                   │
│                   │                   │ for auditability.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, the       │        │                   │
│                   │                   │ implementation is  │        │                   │
│                   │                   │ only partially     │        │                   │
│                   │                   │ coherent and has   │        │                   │
│                   │                   │ several            │        │                   │
│                   │                   │ correctness and    │        │                   │
│                   │                   │ compliance gaps.   │        │                   │
│                   │                   │ There is no real   │        │                   │
│                   │                   │ support for data   │        │                   │
│                   │                   │ subject access     │        │                   │
│                   │                   │ workflows, no      │        │                   │
│                   │                   │ object-level       │        │                   │
│                   │                   │ segregation tied   │        │                   │
│                   │                   │ to “only a few     │        │                   │
│                   │                   │ people” beyond     │        │                   │
│                   │                   │ broad HR roles,    │        │                   │
│                   │                   │ and no explicit    │        │                   │
│                   │                   │ deny controls to   │        │                   │
│                   │                   │ tightly restrict   │        │                   │
│                   │                   │ access paths. Some │        │                   │
│                   │                   │ security choices   │        │                   │
│                   │                   │ are weaker than    │        │                   │
│                   │                   │ expected for       │        │                   │
│                   │                   │ special-category   │        │                   │
│                   │                   │ biometric and      │        │                   │
│                   │                   │ health data: logs  │        │                   │
│                   │                   │ use AES256 instead │        │                   │
│                   │                   │ of CMK-backed KMS, │        │                   │
│                   │                   │ MFA is not         │        │                   │
│                   │                   │ required for       │        │                   │
│                   │                   │ manager/staff      │        │                   │
│                   │                   │ roles, and KMS/key │        │                   │
│                   │                   │ policies are       │        │                   │
│                   │                   │ broad. There are   │        │                   │
│                   │                   │ also               │        │                   │
│                   │                   │ Terraform/resource │        │                   │
│                   │                   │ issues that reduce │        │                   │
│                   │                   │ deployability and  │        │                   │
│                   │                   │ confidence:        │        │                   │
│                   │                   │ duplicated         │        │                   │
│                   │                   │ terraform/provider │        │                   │
│                   │                   │ blocks, likely     │        │                   │
│                   │                   │ invalid CloudTrail │        │                   │
│                   │                   │ resources          │        │                   │
│                   │                   │ (`aws_cloudtrail_… │        │                   │
│                   │                   │ is not a standard  │        │                   │
│                   │                   │ AWS provider       │        │                   │
│                   │                   │ resource), outputs │        │                   │
│                   │                   │ referencing        │        │                   │
│                   │                   │ resources that may │        │                   │
│                   │                   │ not exist safely   │        │                   │
│                   │                   │ under `count`, and │        │                   │
│                   │                   │ MFA delete is not  │        │                   │
│                   │                   │ straightforwardly  │        │                   │
│                   │                   │ manageable in      │        │                   │
│                   │                   │ Terraform. The     │        │                   │
│                   │                   │ request mentions   │        │                   │
│                   │                   │ rewarding strict   │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ whitelists like    │        │                   │
│                   │                   │ docker.io and      │        │                   │
│                   │                   │ ubuntu.com, but    │        │                   │
│                   │                   │ this stack is      │        │                   │
│                   │                   │ S3/IAM-focused and │        │                   │
│                   │                   │ contains no        │        │                   │
│                   │                   │ network            │        │                   │
│                   │                   │ egress/firewall    │        │                   │
│                   │                   │ controls at all.   │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, it        │        │                   │
│                   │                   │ strongly addresses │        │                   │
│                   │                   │ security,          │        │                   │
│                   │                   │ redundancy, and    │        │                   │
│                   │                   │ regional placement │        │                   │
│                   │                   │ better than a      │        │                   │
│                   │                   │ basic storage      │        │                   │
│                   │                   │ setup, but the     │        │                   │
│                   │                   │ implementation is  │        │                   │
│                   │                   │ not fully accurate │        │                   │
│                   │                   │ or                 │        │                   │
│                   │                   │ production-cohere… │        │                   │
│                   │                   │ for the hidden     │        │                   │
│                   │                   │ medical-recruitme… │        │                   │
│                   │                   │ GDPR context.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.78,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 11.18s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


