
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.77s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.78s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.4                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ the core requested │        │                   │
│                   │                   │ resources: Route   │        │                   │
│                   │                   │ 53 Resolver        │        │                   │
│                   │                   │ inbound and        │        │                   │
│                   │                   │ outbound           │        │                   │
│                   │                   │ endpoints, a       │        │                   │
│                   │                   │ FORWARD rule for   │        │                   │
│                   │                   │ corp.internal to   │        │                   │
│                   │                   │ 192.168.10.5 and   │        │                   │
│                   │                   │ 192.168.10.6, VPC  │        │                   │
│                   │                   │ association, and   │        │                   │
│                   │                   │ Transit Gateway    │        │                   │
│                   │                   │ routing intent. It │        │                   │
│                   │                   │ also places        │        │                   │
│                   │                   │ endpoint IPs       │        │                   │
│                   │                   │ across two AZs by  │        │                   │
│                   │                   │ using two subnets. │        │                   │
│                   │                   │ However, it only   │        │                   │
│                   │                   │ creates two        │        │                   │
│                   │                   │ subnets total and  │        │                   │
│                   │                   │ reuses the same    │        │                   │
│                   │                   │ pair for both      │        │                   │
│                   │                   │ endpoints rather   │        │                   │
│                   │                   │ than clearly       │        │                   │
│                   │                   │ distributing each  │        │                   │
│                   │                   │ endpoint across    │        │                   │
│                   │                   │ dedicated AZ       │        │                   │
│                   │                   │ subnets, and the   │        │                   │
│                   │                   │ query log config   │        │                   │
│                   │                   │ is incorrectly     │        │                   │
│                   │                   │ modeled with a     │        │                   │
│                   │                   │ resource_id field  │        │                   │
│                   │                   │ instead of a       │        │                   │
│                   │                   │ separate           │        │                   │
│                   │                   │ association        │        │                   │
│                   │                   │ resource. Security │        │                   │
│                   │                   │ groups do not      │        │                   │
│                   │                   │ fully meet the     │        │                   │
│                   │                   │ requirement to     │        │                   │
│                   │                   │ allow only port 53 │        │                   │
│                   │                   │ from the VPC CIDR  │        │                   │
│                   │                   │ and on-prem range: │        │                   │
│                   │                   │ inbound endpoint   │        │                   │
│                   │                   │ egress is open to  │        │                   │
│                   │                   │ 0.0.0.0/0,         │        │                   │
│                   │                   │ outbound endpoint  │        │                   │
│                   │                   │ allows egress to   │        │                   │
│                   │                   │ 0.0.0.0/0 for AWS  │        │                   │
│                   │                   │ DNS, and outbound  │        │                   │
│                   │                   │ ingress omits the  │        │                   │
│                   │                   │ on-premises range  │        │                   │
│                   │                   │ mentioned in the   │        │                   │
│                   │                   │ prompt. Given the  │        │                   │
│                   │                   │ healthcare/GDPR    │        │                   │
│                   │                   │ context about      │        │                   │
│                   │                   │ sensitive EU       │        │                   │
│                   │                   │ clinical-trial     │        │                   │
│                   │                   │ data and avoiding  │        │                   │
│                   │                   │ public internet    │        │                   │
│                   │                   │ exposure, those    │        │                   │
│                   │                   │ broad rules and    │        │                   │
│                   │                   │ lack of            │        │                   │
│                   │                   │ geographic/compli… │        │                   │
│                   │                   │ safeguards reduce  │        │                   │
│                   │                   │ alignment.,        │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.24s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


