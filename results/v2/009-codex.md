
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.86s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.87s[0m[0m
                                       Test Results
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.7                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform covers   │        │                   │
│                   │                   │ the main requested │        │                   │
│                   │                   │ infrastructure:    │        │                   │
│                   │                   │ separate inbound   │        │                   │
│                   │                   │ and outbound Route │        │                   │
│                   │                   │ 53 Resolver        │        │                   │
│                   │                   │ endpoints, use of  │        │                   │
│                   │                   │ two subnets/AZs    │        │                   │
│                   │                   │ for high           │        │                   │
│                   │                   │ availability, a    │        │                   │
│                   │                   │ forwarding rule    │        │                   │
│                   │                   │ for corp.internal  │        │                   │
│                   │                   │ to 192.168.10.5    │        │                   │
│                   │                   │ and 192.168.10.6,  │        │                   │
│                   │                   │ and security       │        │                   │
│                   │                   │ groups limited to  │        │                   │
│                   │                   │ TCP/UDP 53 for the │        │                   │
│                   │                   │ VPC CIDR and       │        │                   │
│                   │                   │ on-prem CIDR. It   │        │                   │
│                   │                   │ also includes      │        │                   │
│                   │                   │ TGW-related        │        │                   │
│                   │                   │ routing and some   │        │                   │
│                   │                   │ security-conscious │        │                   │
│                   │                   │ elements like      │        │                   │
│                   │                   │ encrypted logging  │        │                   │
│                   │                   │ and state          │        │                   │
│                   │                   │ encryption, which  │        │                   │
│                   │                   │ aligns with the    │        │                   │
│                   │                   │ sensitive EU       │        │                   │
│                   │                   │ clinical-trial     │        │                   │
│                   │                   │ context. However,  │        │                   │
│                   │                   │ there are notable  │        │                   │
│                   │                   │ shortcomings: the  │        │                   │
│                   │                   │ Transit Gateway    │        │                   │
│                   │                   │ attachment is      │        │                   │
│                   │                   │ miswired by        │        │                   │
│                   │                   │ passing            │        │                   │
│                   │                   │ var.transit_gatew… │        │                   │
│                   │                   │ into               │        │                   │
│                   │                   │ transit_gateway_a… │        │                   │
│                   │                   │ the code does not  │        │                   │
│                   │                   │ clearly ensure the │        │                   │
│                   │                   │ existing           │        │                   │
│                   │                   │ attachment is      │        │                   │
│                   │                   │ actually used      │        │                   │
│                   │                   │ correctly, and     │        │                   │
│                   │                   │ there is no        │        │                   │
│                   │                   │ explicit resolver  │        │                   │
│                   │                   │ query logging      │        │                   │
│                   │                   │ configuration      │        │                   │
│                   │                   │ despite creating   │        │                   │
│                   │                   │ log destinations.  │        │                   │
│                   │                   │ The NACL only      │        │                   │
│                   │                   │ allows ingress     │        │                   │
│                   │                   │ from on-prem on    │        │                   │
│                   │                   │ port 53 and does   │        │                   │
│                   │                   │ not reflect the    │        │                   │
│                   │                   │ full VPC/on-prem   │        │                   │
│                   │                   │ requirement, and   │        │                   │
│                   │                   │ the solution does  │        │                   │
│                   │                   │ not explicitly     │        │                   │
│                   │                   │ address hidden     │        │                   │
│                   │                   │ GDPR/geographic    │        │                   │
│                   │                   │ restrictions       │        │                   │
│                   │                   │ beyond generally   │        │                   │
│                   │                   │ private            │        │                   │
│                   │                   │ networking.,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.53s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


