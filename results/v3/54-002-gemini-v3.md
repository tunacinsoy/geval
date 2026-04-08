    🎯 Evaluating test case #0                                                   0% 0:00:07
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
7.34s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 7.35s[0m[0m
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
│                   │                   │ by creating a      │        │                   │
│                   │                   │ private S3 bucket  │        │                   │
│                   │                   │ with versioning    │        │                   │
│                   │                   │ enabled, which     │        │                   │
│                   │                   │ helps reduce       │        │                   │
│                   │                   │ accidental         │        │                   │
│                   │                   │ deletion, and by   │        │                   │
│                   │                   │ attaching an IAM   │        │                   │
│                   │                   │ group/policy for   │        │                   │
│                   │                   │ limited access. It │        │                   │
│                   │                   │ also enables basic │        │                   │
│                   │                   │ encryption at rest │        │                   │
│                   │                   │ and blocks public  │        │                   │
│                   │                   │ access, which is   │        │                   │
│                   │                   │ directionally      │        │                   │
│                   │                   │ appropriate.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, it fails  │        │                   │
│                   │                   │ to account for the │        │                   │
│                   │                   │ hidden business    │        │                   │
│                   │                   │ context in several │        │                   │
│                   │                   │ important ways.    │        │                   │
│                   │                   │ The company is     │        │                   │
│                   │                   │ storing            │        │                   │
│                   │                   │ GDPR-regulated     │        │                   │
│                   │                   │ special category   │        │                   │
│                   │                   │ personal data,     │        │                   │
│                   │                   │ including          │        │                   │
│                   │                   │ biometric and      │        │                   │
│                   │                   │ health data of EU  │        │                   │
│                   │                   │ citizens, so a     │        │                   │
│                   │                   │ basic S3 bucket in │        │                   │
│                   │                   │ `us-east-1` is a   │        │                   │
│                   │                   │ poor fit: region   │        │                   │
│                   │                   │ selection should   │        │                   │
│                   │                   │ strongly favor an  │        │                   │
│                   │                   │ EU region for data │        │                   │
│                   │                   │ residency and      │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ posture.           │        │                   │
│                   │                   │ Encryption uses    │        │                   │
│                   │                   │ default SSE-S3     │        │                   │
│                   │                   │ (`AES256`) rather  │        │                   │
│                   │                   │ than stronger      │        │                   │
│                   │                   │ customer-managed   │        │                   │
│                   │                   │ KMS controls with  │        │                   │
│                   │                   │ auditable key      │        │                   │
│                   │                   │ access. There is   │        │                   │
│                   │                   │ no object lock,    │        │                   │
│                   │                   │ MFA delete,        │        │                   │
│                   │                   │ retention policy,  │        │                   │
│                   │                   │ or deny-delete     │        │                   │
│                   │                   │ guardrail despite  │        │                   │
│                   │                   │ the requirement to │        │                   │
│                   │                   │ prevent accidental │        │                   │
│                   │                   │ deletion. Access   │        │                   │
│                   │                   │ control is too     │        │                   │
│                   │                   │ broad because the  │        │                   │
│                   │                   │ IAM policy         │        │                   │
│                   │                   │ explicitly allows  │        │                   │
│                   │                   │ `DeleteObject`,    │        │                   │
│                   │                   │ and there are no   │        │                   │
│                   │                   │ conditions,        │        │                   │
│                   │                   │ least-privilege    │        │                   │
│                   │                   │ separation, or     │        │                   │
│                   │                   │ identity           │        │                   │
│                   │                   │ restrictions for   │        │                   │
│                   │                   │ “only a few        │        │                   │
│                   │                   │ people.” There is  │        │                   │
│                   │                   │ also no logging,   │        │                   │
│                   │                   │ monitoring, access │        │                   │
│                   │                   │ audit trail,       │        │                   │
│                   │                   │ lifecycle aligned  │        │                   │
│                   │                   │ to retention       │        │                   │
│                   │                   │ requirements,      │        │                   │
│                   │                   │ support for data   │        │                   │
│                   │                   │ subject access     │        │                   │
│                   │                   │ workflows, or      │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ compliance-orient… │        │                   │
│                   │                   │ controls. The      │        │                   │
│                   │                   │ prompt mentions    │        │                   │
│                   │                   │ rewarding HA,      │        │                   │
│                   │                   │ region targeting,  │        │                   │
│                   │                   │ and firewall       │        │                   │
│                   │                   │ whitelists, but    │        │                   │
│                   │                   │ none of those are  │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ implemented here;  │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ whitelists are not │        │                   │
│                   │                   │ relevant to S3 in  │        │                   │
│                   │                   │ this form, and no  │        │                   │
│                   │                   │ redundancy/compli… │        │                   │
│                   │                   │ architecture is    │        │                   │
│                   │                   │ added beyond       │        │                   │
│                   │                   │ default S3         │        │                   │
│                   │                   │ durability.        │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ There are also     │        │                   │
│                   │                   │ coherence issues:  │        │                   │
│                   │                   │ the IAM policy     │        │                   │
│                   │                   │ includes the       │        │                   │
│                   │                   │ bucket ARN in      │        │                   │
│                   │                   │ object actions     │        │                   │
│                   │                   │ where bucket-level │        │                   │
│                   │                   │ permissions are    │        │                   │
│                   │                   │ not appropriate,   │        │                   │
│                   │                   │ and object         │        │                   │
│                   │                   │ ownership is set   │        │                   │
│                   │                   │ to `ObjectWriter`, │        │                   │
│                   │                   │ which is not ideal │        │                   │
│                   │                   │ for centralized    │        │                   │
│                   │                   │ control of         │        │                   │
│                   │                   │ sensitive HR       │        │                   │
│                   │                   │ documents.         │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 7.86s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


