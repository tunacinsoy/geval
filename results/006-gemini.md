
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.22s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.23s[0m[0m
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
│                   │                   │ reason=The output  │        │                   │
│                   │                   │ includes core      │        │                   │
│                   │                   │ requested          │        │                   │
│                   │                   │ components such as │        │                   │
│                   │                   │ VPCs in            │        │                   │
│                   │                   │ eu-central-1 and   │        │                   │
│                   │                   │ eu-west-1,         │        │                   │
│                   │                   │ private/public     │        │                   │
│                   │                   │ subnets, ALBs, and │        │                   │
│                   │                   │ an Aurora global   │        │                   │
│                   │                   │ cluster concept,   │        │                   │
│                   │                   │ but it misses or   │        │                   │
│                   │                   │ misconfigures      │        │                   │
│                   │                   │ several critical   │        │                   │
│                   │                   │ requirements. The  │        │                   │
│                   │                   │ VPC peering is     │        │                   │
│                   │                   │ invalid because    │        │                   │
│                   │                   │ both VPCs use the  │        │                   │
│                   │                   │ identical          │        │                   │
│                   │                   │ 10.10.0.0/16 CIDR  │        │                   │
│                   │                   │ blocks, which AWS  │        │                   │
│                   │                   │ peering does not   │        │                   │
│                   │                   │ support, and there │        │                   │
│                   │                   │ are no route table │        │                   │
│                   │                   │ updates. The       │        │                   │
│                   │                   │ Terraform backend  │        │                   │
│                   │                   │ uses S3 with       │        │                   │
│                   │                   │ encryption         │        │                   │
│                   │                   │ enabled, but there │        │                   │
│                   │                   │ is no S3 bucket    │        │                   │
│                   │                   │ resource or        │        │                   │
│                   │                   │ cross-region       │        │                   │
│                   │                   │ replication        │        │                   │
│                   │                   │ configuration for  │        │                   │
│                   │                   │ state as           │        │                   │
│                   │                   │ explicitly         │        │                   │
│                   │                   │ required. For the  │        │                   │
│                   │                   │ GDPR/Article 32    │        │                   │
│                   │                   │ context, the       │        │                   │
│                   │                   │ database setup     │        │                   │
│                   │                   │ lacks clear        │        │                   │
│                   │                   │ encryption at      │        │                   │
│                   │                   │ rest, secure       │        │                   │
│                   │                   │ secret handling,   │        │                   │
│                   │                   │ and robust secure  │        │                   │
│                   │                   │ transit posture;   │        │                   │
│                   │                   │ master credentials │        │                   │
│                   │                   │ are hardcoded, and │        │                   │
│                   │                   │ there is no KMS    │        │                   │
│                   │                   │ usage. The Aurora  │        │                   │
│                   │                   │ global database    │        │                   │
│                   │                   │ replication intent │        │                   │
│                   │                   │ is present, but    │        │                   │
│                   │                   │ the DR cluster is  │        │                   │
│                   │                   │ not clearly        │        │                   │
│                   │                   │ configured as a    │        │                   │
│                   │                   │ proper             │        │                   │
│                   │                   │ secondary/read     │        │                   │
│                   │                   │ replica pattern,   │        │                   │
│                   │                   │ and overall        │        │                   │
│                   │                   │ security/complian… │        │                   │
│                   │                   │ handling is weak., │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.19s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


