
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.62s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.63s[0m[0m
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
│                   │                   │ reason=The output  │        │                   │
│                   │                   │ matches some       │        │                   │
│                   │                   │ explicit inputs:   │        │                   │
│                   │                   │ it defines VPCs in │        │                   │
│                   │                   │ eu-central-1 and   │        │                   │
│                   │                   │ eu-west-1,         │        │                   │
│                   │                   │ private/public     │        │                   │
│                   │                   │ subnets, an ALB,   │        │                   │
│                   │                   │ and attempts       │        │                   │
│                   │                   │ Aurora global      │        │                   │
│                   │                   │ database resources │        │                   │
│                   │                   │ with encryption    │        │                   │
│                   │                   │ enabled. However,  │        │                   │
│                   │                   │ it fails major     │        │                   │
│                   │                   │ infrastructure and │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ requirements. VPC  │        │                   │
│                   │                   │ peering is invalid │        │                   │
│                   │                   │ with identical     │        │                   │
│                   │                   │ 10.10.0.0/16       │        │                   │
│                   │                   │ CIDRs, so the      │        │                   │
│                   │                   │ requested peering  │        │                   │
│                   │                   │ cannot work. The   │        │                   │
│                   │                   │ app tier and ALB   │        │                   │
│                   │                   │ are only           │        │                   │
│                   │                   │ implemented in the │        │                   │
│                   │                   │ primary region,    │        │                   │
│                   │                   │ not both regions   │        │                   │
│                   │                   │ as required.       │        │                   │
│                   │                   │ Terraform state    │        │                   │
│                   │                   │ storage is only a  │        │                   │
│                   │                   │ backend block;     │        │                   │
│                   │                   │ there is no S3     │        │                   │
│                   │                   │ bucket, no         │        │                   │
│                   │                   │ replication        │        │                   │
│                   │                   │ configuration, and │        │                   │
│                   │                   │ no cross-region    │        │                   │
│                   │                   │ replication        │        │                   │
│                   │                   │ resources. The     │        │                   │
│                   │                   │ Aurora global      │        │                   │
│                   │                   │ setup is           │        │                   │
│                   │                   │ incomplete/miscon… │        │                   │
│                   │                   │ the primary        │        │                   │
│                   │                   │ cluster is not     │        │                   │
│                   │                   │ attached to the    │        │                   │
│                   │                   │ global cluster,    │        │                   │
│                   │                   │ the DR cluster     │        │                   │
│                   │                   │ reuses the primary │        │                   │
│                   │                   │ subnet group       │        │                   │
│                   │                   │ without DR         │        │                   │
│                   │                   │ provider           │        │                   │
│                   │                   │ resources, and     │        │                   │
│                   │                   │ secret handling    │        │                   │
│                   │                   │ for                │        │                   │
│                   │                   │ master_password is │        │                   │
│                   │                   │ incorrect. From    │        │                   │
│                   │                   │ the GDPR/Article   │        │                   │
│                   │                   │ 32 context, there  │        │                   │
│                   │                   │ is some at-rest    │        │                   │
│                   │                   │ encryption and     │        │                   │
│                   │                   │ HTTPS on the ALB,  │        │                   │
│                   │                   │ but no holistic    │        │                   │
│                   │                   │ compliance posture │        │                   │
│                   │                   │ for resilient,     │        │                   │
│                   │                   │ regionally correct │        │                   │
│                   │                   │ DR                 │        │                   │
│                   │                   │ infrastructure.,   │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.5s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


