
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.90s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.91s[0m[0m
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
│                   │                   │ several explicit   │        │                   │
│                   │                   │ requirements: AKS  │        │                   │
│                   │                   │ is private with    │        │                   │
│                   │                   │ public_network_ac… │        │                   │
│                   │                   │ outbound_type is   │        │                   │
│                   │                   │ userDefinedRoutin… │        │                   │
│                   │                   │ a UDR sends        │        │                   │
│                   │                   │ 0.0.0.0/0 from the │        │                   │
│                   │                   │ AKS subnet to      │        │                   │
│                   │                   │ Azure Firewall,    │        │                   │
│                   │                   │ and the node pool  │        │                   │
│                   │                   │ uses 3             │        │                   │
│                   │                   │ Standard_D4s_v5    │        │                   │
│                   │                   │ nodes across zones │        │                   │
│                   │                   │ 1/2/3 on           │        │                   │
│                   │                   │ Kubernetes 1.28.2. │        │                   │
│                   │                   │ It also adds       │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ application rules  │        │                   │
│                   │                   │ for *.docker.io    │        │                   │
│                   │                   │ and *.ubuntu.com.  │        │                   │
│                   │                   │ However, it misses │        │                   │
│                   │                   │ key hidden and     │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ constraints: the   │        │                   │
│                   │                   │ context implies    │        │                   │
│                   │                   │ GDPR-sensitive EU  │        │                   │
│                   │                   │ data handling and  │        │                   │
│                   │                   │ cross-border       │        │                   │
│                   │                   │ restrictions, yet  │        │                   │
│                   │                   │ the default        │        │                   │
│                   │                   │ location is eastus │        │                   │
│                   │                   │ rather than an EU  │        │                   │
│                   │                   │ region, with no    │        │                   │
│                   │                   │ geographic         │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ controls. The      │        │                   │
│                   │                   │ firewall itself    │        │                   │
│                   │                   │ has a public IP    │        │                   │
│                   │                   │ despite the        │        │                   │
│                   │                   │ request that the   │        │                   │
│                   │                   │ cluster must not   │        │                   │
│                   │                   │ have a public IP   │        │                   │
│                   │                   │ and the zero-trust │        │                   │
│                   │                   │ context, and the   │        │                   │
│                   │                   │ NSG outbound rule  │        │                   │
│                   │                   │ broadly allows     │        │                   │
│                   │                   │ Internet egress    │        │                   │
│                   │                   │ before a deny      │        │                   │
│                   │                   │ rule, undermining  │        │                   │
│                   │                   │ strict egress      │        │                   │
│                   │                   │ control. The AKS   │        │                   │
│                   │                   │ network profile    │        │                   │
│                   │                   │ does not clearly   │        │                   │
│                   │                   │ configure Azure    │        │                   │
│                   │                   │ CNI Overlay        │        │                   │
│                   │                   │ specifically, so a │        │                   │
│                   │                   │ core networking    │        │                   │
│                   │                   │ requirement is not │        │                   │
│                   │                   │ fully satisfied.,  │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.91s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


