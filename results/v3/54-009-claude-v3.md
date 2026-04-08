    🎯 Evaluating test case #0                                                   0% 0:00:10
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
10.20s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 10.21s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.43               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform only     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ request and has    │        │                   │
│                   │                   │ several            │        │                   │
│                   │                   │ correctness        │        │                   │
│                   │                   │ issues.            │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ It does implement  │        │                   │
│                   │                   │ core Route 53      │        │                   │
│                   │                   │ Resolver           │        │                   │
│                   │                   │ components:        │        │                   │
│                   │                   │ inbound and        │        │                   │
│                   │                   │ outbound           │        │                   │
│                   │                   │ endpoints, a       │        │                   │
│                   │                   │ forwarding rule    │        │                   │
│                   │                   │ for                │        │                   │
│                   │                   │ `corp.internal`,   │        │                   │
│                   │                   │ two target on-prem │        │                   │
│                   │                   │ DNS IPs, and       │        │                   │
│                   │                   │ security groups    │        │                   │
│                   │                   │ that mostly        │        │                   │
│                   │                   │ restrict DNS to    │        │                   │
│                   │                   │ port 53 from the   │        │                   │
│                   │                   │ VPC and on-prem    │        │                   │
│                   │                   │ CIDRs. It also     │        │                   │
│                   │                   │ attempts HA by     │        │                   │
│                   │                   │ placing endpoint   │        │                   │
│                   │                   │ IPs in two         │        │                   │
│                   │                   │ subnets/AZs.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, there are │        │                   │
│                   │                   │ major flaws:       │        │                   │
│                   │                   │ - It creates only  │        │                   │
│                   │                   │ two subnets total  │        │                   │
│                   │                   │ and reuses them    │        │                   │
│                   │                   │ across both        │        │                   │
│                   │                   │ inbound and        │        │                   │
│                   │                   │ outbound endpoints │        │                   │
│                   │                   │ rather than        │        │                   │
│                   │                   │ clearly modeling   │        │                   │
│                   │                   │ endpoint placement │        │                   │
│                   │                   │ across two AZs per │        │                   │
│                   │                   │ endpoint.          │        │                   │
│                   │                   │ - The Transit      │        │                   │
│                   │                   │ Gateway routing is │        │                   │
│                   │                   │ incorrect:         │        │                   │
│                   │                   │ `aws_route` should │        │                   │
│                   │                   │ use                │        │                   │
│                   │                   │ `transit_gateway_… │        │                   │
│                   │                   │ not                │        │                   │
│                   │                   │ `transit_gateway_… │        │                   │
│                   │                   │ Also, Route 53     │        │                   │
│                   │                   │ Resolver           │        │                   │
│                   │                   │ forwarding does    │        │                   │
│                   │                   │ not directly “use” │        │                   │
│                   │                   │ a TGW attachment   │        │                   │
│                   │                   │ resource in the    │        │                   │
│                   │                   │ way implied here;  │        │                   │
│                   │                   │ routing must       │        │                   │
│                   │                   │ simply exist from  │        │                   │
│                   │                   │ endpoint subnets.  │        │                   │
│                   │                   │ - The query        │        │                   │
│                   │                   │ logging resource   │        │                   │
│                   │                   │ is wrong:          │        │                   │
│                   │                   │ `aws_route53_reso… │        │                   │
│                   │                   │ does not take      │        │                   │
│                   │                   │ `resource_id`;     │        │                   │
│                   │                   │ association        │        │                   │
│                   │                   │ requires a         │        │                   │
│                   │                   │ separate           │        │                   │
│                   │                   │ `aws_route53_reso… │        │                   │
│                   │                   │ - The IAM roles    │        │                   │
│                   │                   │ are unnecessary    │        │                   │
│                   │                   │ for this task and  │        │                   │
│                   │                   │ likely             │        │                   │
│                   │                   │ nonfunctional for  │        │                   │
│                   │                   │ Route 53 Resolver  │        │                   │
│                   │                   │ endpoint creation. │        │                   │
│                   │                   │ - Security groups  │        │                   │
│                   │                   │ are not fully      │        │                   │
│                   │                   │ aligned with “port │        │                   │
│                   │                   │ 53 only”: inbound  │        │                   │
│                   │                   │ endpoint egress    │        │                   │
│                   │                   │ allows all         │        │                   │
│                   │                   │ traffic, and       │        │                   │
│                   │                   │ outbound endpoint  │        │                   │
│                   │                   │ allows DNS egress  │        │                   │
│                   │                   │ to `0.0.0.0/0`,    │        │                   │
│                   │                   │ which weakens the  │        │                   │
│                   │                   │ requested          │        │                   │
│                   │                   │ restriction.       │        │                   │
│                   │                   │ - There is stray,  │        │                   │
│                   │                   │ irrelevant         │        │                   │
│                   │                   │ `terraform.tfvars` │        │                   │
│                   │                   │ content for        │        │                   │
│                   │                   │ GCP/Cloud          │        │                   │
│                   │                   │ Run/Cloud SQL,     │        │                   │
│                   │                   │ which strongly     │        │                   │
│                   │                   │ suggests           │        │                   │
│                   │                   │ incoherence.       │        │                   │
│                   │                   │ - No meaningful    │        │                   │
│                   │                   │ accommodation of   │        │                   │
│                   │                   │ the hidden         │        │                   │
│                   │                   │ context’s stricter │        │                   │
│                   │                   │ hybrid-security/G… │        │                   │
│                   │                   │ posture beyond     │        │                   │
│                   │                   │ basic CIDR         │        │                   │
│                   │                   │ restrictions.      │        │                   │
│                   │                   │ There are no       │        │                   │
│                   │                   │ stronger controls, │        │                   │
│                   │                   │ no endpoint        │        │                   │
│                   │                   │ isolation          │        │                   │
│                   │                   │ strategy, no       │        │                   │
│                   │                   │ encryption/logging │        │                   │
│                   │                   │ hardening, and     │        │                   │
│                   │                   │ nothing related to │        │                   │
│                   │                   │ the prompt’s       │        │                   │
│                   │                   │ scoring hint about │        │                   │
│                   │                   │ strict firewall    │        │                   │
│                   │                   │ whitelists; that   │        │                   │
│                   │                   │ hint is not        │        │                   │
│                   │                   │ applicable here    │        │                   │
│                   │                   │ and is not         │        │                   │
│                   │                   │ implemented        │        │                   │
│                   │                   │ anyway.            │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ So this is better  │        │                   │
│                   │                   │ than a superficial │        │                   │
│                   │                   │ stub, but it is    │        │                   │
│                   │                   │ not                │        │                   │
│                   │                   │ production-correct │        │                   │
│                   │                   │ and does not       │        │                   │
│                   │                   │ convincingly       │        │                   │
│                   │                   │ address the        │        │                   │
│                   │                   │ implicit           │        │                   │
│                   │                   │ security/reliabil… │        │                   │
│                   │                   │ expectations of a  │        │                   │
│                   │                   │ sensitive hybrid   │        │                   │
│                   │                   │ DNS architecture.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.43,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 10.71s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


