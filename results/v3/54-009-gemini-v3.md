    🎯 Evaluating test case #0                                                   0% 0:00:07
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
7.78s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 7.79s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.74               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform mostly   │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request:  │        │                   │
│                   │                   │ it creates both    │        │                   │
│                   │                   │ inbound and        │        │                   │
│                   │                   │ outbound Route 53  │        │                   │
│                   │                   │ Resolver           │        │                   │
│                   │                   │ endpoints,         │        │                   │
│                   │                   │ constrains subnets │        │                   │
│                   │                   │ to exactly two for │        │                   │
│                   │                   │ multi-AZ           │        │                   │
│                   │                   │ deployment,        │        │                   │
│                   │                   │ defines a          │        │                   │
│                   │                   │ forwarding rule    │        │                   │
│                   │                   │ for                │        │                   │
│                   │                   │ `corp.internal`,   │        │                   │
│                   │                   │ and restricts      │        │                   │
│                   │                   │ security group     │        │                   │
│                   │                   │ traffic to TCP/UDP │        │                   │
│                   │                   │ 53 from the VPC    │        │                   │
│                   │                   │ CIDR and an        │        │                   │
│                   │                   │ on-prem CIDR. It   │        │                   │
│                   │                   │ also targets a     │        │                   │
│                   │                   │ specific AWS       │        │                   │
│                   │                   │ region and adds    │        │                   │
│                   │                   │ resolver query     │        │                   │
│                   │                   │ logging, which is  │        │                   │
│                   │                   │ a useful           │        │                   │
│                   │                   │ security/operatio… │        │                   │
│                   │                   │ enhancement.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, there are │        │                   │
│                   │                   │ several gaps and   │        │                   │
│                   │                   │ coherence issues.  │        │                   │
│                   │                   │ The request        │        │                   │
│                   │                   │ mentions           │        │                   │
│                   │                   │ forwarding via an  │        │                   │
│                   │                   │ existing Transit   │        │                   │
│                   │                   │ Gateway            │        │                   │
│                   │                   │ attachment, but    │        │                   │
│                   │                   │ the code does not  │        │                   │
│                   │                   │ model or validate  │        │                   │
│                   │                   │ any TGW route      │        │                   │
│                   │                   │ propagation/attac… │        │                   │
│                   │                   │ dependencies, so   │        │                   │
│                   │                   │ connectivity to    │        │                   │
│                   │                   │ the on-prem DNS    │        │                   │
│                   │                   │ servers is assumed │        │                   │
│                   │                   │ rather than        │        │                   │
│                   │                   │ ensured. The       │        │                   │
│                   │                   │ default            │        │                   │
│                   │                   │ `on_prem_cidr` of  │        │                   │
│                   │                   │ `10.0.0.0/16` is   │        │                   │
│                   │                   │ inconsistent with  │        │                   │
│                   │                   │ the provided DNS   │        │                   │
│                   │                   │ server IPs         │        │                   │
│                   │                   │ `192.168.10.5/6`,  │        │                   │
│                   │                   │ which weakens the  │        │                   │
│                   │                   │ firewall intent    │        │                   │
│                   │                   │ and likely breaks  │        │                   │
│                   │                   │ the stated         │        │                   │
│                   │                   │ requirement. The   │        │                   │
│                   │                   │ security group     │        │                   │
│                   │                   │ egress is tightly  │        │                   │
│                   │                   │ scoped to the DNS  │        │                   │
│                   │                   │ server IPs, which  │        │                   │
│                   │                   │ is good, but       │        │                   │
│                   │                   │ ingress is broader │        │                   │
│                   │                   │ than necessary if  │        │                   │
│                   │                   │ the actual on-prem │        │                   │
│                   │                   │ range is           │        │                   │
│                   │                   │ different. The     │        │                   │
│                   │                   │ hidden context     │        │                   │
│                   │                   │ emphasizes strict  │        │                   │
│                   │                   │ isolation for      │        │                   │
│                   │                   │ sensitive EU       │        │                   │
│                   │                   │ clinical-trial     │        │                   │
│                   │                   │ data; while the    │        │                   │
│                   │                   │ code avoids public │        │                   │
│                   │                   │ exposure and adds  │        │                   │
│                   │                   │ logging, it does   │        │                   │
│                   │                   │ not introduce      │        │                   │
│                   │                   │ stronger           │        │                   │
│                   │                   │ architectural      │        │                   │
│                   │                   │ controls tied to   │        │                   │
│                   │                   │ that context, such │        │                   │
│                   │                   │ as explicit        │        │                   │
│                   │                   │ private-only       │        │                   │
│                   │                   │ assumptions, route │        │                   │
│                   │                   │ validation,        │        │                   │
│                   │                   │ endpoint-specific  │        │                   │
│                   │                   │ subnet hardening,  │        │                   │
│                   │                   │ KMS encryption for │        │                   │
│                   │                   │ logs, or policy    │        │                   │
│                   │                   │ guardrails. The    │        │                   │
│                   │                   │ mention of         │        │                   │
│                   │                   │ rewarding firewall │        │                   │
│                   │                   │ whitelists like    │        │                   │
│                   │                   │ `docker.io` and    │        │                   │
│                   │                   │ `ubuntu.com` is    │        │                   │
│                   │                   │ not applicable to  │        │                   │
│                   │                   │ this DNS resolver  │        │                   │
│                   │                   │ task, and none are │        │                   │
│                   │                   │ present.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ solid              │        │                   │
│                   │                   │ implementation of  │        │                   │
│                   │                   │ the explicit DNS   │        │                   │
│                   │                   │ resolver setup,    │        │                   │
│                   │                   │ with decent HA and │        │                   │
│                   │                   │ least-privilege SG │        │                   │
│                   │                   │ intent, but it     │        │                   │
│                   │                   │ only partially     │        │                   │
│                   │                   │ addresses the      │        │                   │
│                   │                   │ deeper             │        │                   │
│                   │                   │ hybrid-network and │        │                   │
│                   │                   │ compliance-sensit… │        │                   │
│                   │                   │ architectural      │        │                   │
│                   │                   │ constraints.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.74,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 8.31s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


