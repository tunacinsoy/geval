
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.21s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.22s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.8                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform covers   │        │                   │
│                   │                   │ the main requested │        │                   │
│                   │                   │ infrastructure:    │        │                   │
│                   │                   │ inbound and        │        │                   │
│                   │                   │ outbound Route 53  │        │                   │
│                   │                   │ Resolver           │        │                   │
│                   │                   │ endpoints, a       │        │                   │
│                   │                   │ forward rule for   │        │                   │
│                   │                   │ corp.internal, two │        │                   │
│                   │                   │ target IPs, VPC    │        │                   │
│                   │                   │ association, and   │        │                   │
│                   │                   │ security groups    │        │                   │
│                   │                   │ restricted to      │        │                   │
│                   │                   │ TCP/UDP 53 for VPC │        │                   │
│                   │                   │ and on-prem        │        │                   │
│                   │                   │ sources. It also   │        │                   │
│                   │                   │ enforces two       │        │                   │
│                   │                   │ subnets for HA     │        │                   │
│                   │                   │ across AZs and     │        │                   │
│                   │                   │ limits egress to   │        │                   │
│                   │                   │ the on-prem DNS    │        │                   │
│                   │                   │ IPs. However, it   │        │                   │
│                   │                   │ does not           │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ address the stated │        │                   │
│                   │                   │ Transit Gateway    │        │                   │
│                   │                   │ attachment         │        │                   │
│                   │                   │ requirement, since │        │                   │
│                   │                   │ no TGW-related     │        │                   │
│                   │                   │ routing or         │        │                   │
│                   │                   │ dependency is      │        │                   │
│                   │                   │ configured, and    │        │                   │
│                   │                   │ the default        │        │                   │
│                   │                   │ on_prem_cidr is    │        │                   │
│                   │                   │ inconsistent with  │        │                   │
│                   │                   │ the provided DNS   │        │                   │
│                   │                   │ IP range. From the │        │                   │
│                   │                   │ GDPR-sensitive     │        │                   │
│                   │                   │ context, the       │        │                   │
│                   │                   │ solution is        │        │                   │
│                   │                   │ reasonably         │        │                   │
│                   │                   │ security-conscious │        │                   │
│                   │                   │ with no public     │        │                   │
│                   │                   │ exposure and       │        │                   │
│                   │                   │ encrypted S3       │        │                   │
│                   │                   │ backend state, but │        │                   │
│                   │                   │ it lacks stronger  │        │                   │
│                   │                   │ compliance-orient… │        │                   │
│                   │                   │ controls such as   │        │                   │
│                   │                   │ explicit log       │        │                   │
│                   │                   │ encryption/KMS or  │        │                   │
│                   │                   │ clearer private    │        │                   │
│                   │                   │ connectivity       │        │                   │
│                   │                   │ assurances.,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.17s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


