
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
│                   │ Contextual        │ 0.3                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ core resources for │        │                   │
│                   │                   │ a private AKS      │        │                   │
│                   │                   │ cluster, VNet,     │        │                   │
│                   │                   │ Azure Firewall,    │        │                   │
│                   │                   │ and a UDR on the   │        │                   │
│                   │                   │ AKS subnet, and it │        │                   │
│                   │                   │ restricts firewall │        │                   │
│                   │                   │ application rules  │        │                   │
│                   │                   │ to *.docker.io and │        │                   │
│                   │                   │ *.ubuntu.com.      │        │                   │
│                   │                   │ However, it misses │        │                   │
│                   │                   │ several explicit   │        │                   │
│                   │                   │ requirements: AKS  │        │                   │
│                   │                   │ version is not     │        │                   │
│                   │                   │ pinned to v1.28+,  │        │                   │
│                   │                   │ Azure CNI Overlay  │        │                   │
│                   │                   │ is not configured, │        │                   │
│                   │                   │ the node pool is   │        │                   │
│                   │                   │ not distributed    │        │                   │
│                   │                   │ across             │        │                   │
│                   │                   │ availability zones │        │                   │
│                   │                   │ 1/2/3, and         │        │                   │
│                   │                   │ autoscaling        │        │                   │
│                   │                   │ changes the fixed  │        │                   │
│                   │                   │ 3-node             │        │                   │
│                   │                   │ requirement. It    │        │                   │
│                   │                   │ also has likely    │        │                   │
│                   │                   │ invalid or         │        │                   │
│                   │                   │ incomplete         │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ integration        │        │                   │
│                   │                   │ because the        │        │                   │
│                   │                   │ firewall policy is │        │                   │
│                   │                   │ created separately │        │                   │
│                   │                   │ and attached via a │        │                   │
│                   │                   │ nonstandard        │        │                   │
│                   │                   │ attachment         │        │                   │
│                   │                   │ resource instead   │        │                   │
│                   │                   │ of associating the │        │                   │
│                   │                   │ policy on the      │        │                   │
│                   │                   │ firewall, and the  │        │                   │
│                   │                   │ route depends on   │        │                   │
│                   │                   │ the firewall       │        │                   │
│                   │                   │ private IP in a    │        │                   │
│                   │                   │ fragile way. From  │        │                   │
│                   │                   │ the context, the   │        │                   │
│                   │                   │ solution does not  │        │                   │
│                   │                   │ address            │        │                   │
│                   │                   │ GDPR-oriented      │        │                   │
│                   │                   │ geographic         │        │                   │
│                   │                   │ restrictions or    │        │                   │
│                   │                   │ stronger           │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ controls beyond    │        │                   │
│                   │                   │ private access and │        │                   │
│                   │                   │ egress filtering,  │        │                   │
│                   │                   │ so the zero-trust  │        │                   │
│                   │                   │ and cross-border   │        │                   │
│                   │                   │ protection intent  │        │                   │
│                   │                   │ is only partially  │        │                   │
│                   │                   │ met., error=None)  │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.78s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


