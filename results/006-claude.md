
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
6.94s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 6.96s[0m[0m
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
│                   │                   │ does create VPCs   │        │                   │
│                   │                   │ in eu-central-1    │        │                   │
│                   │                   │ and eu-west-1 with │        │                   │
│                   │                   │ 10.10.0.0/16,      │        │                   │
│                   │                   │ private app        │        │                   │
│                   │                   │ subnets, public    │        │                   │
│                   │                   │ ALBs, and          │        │                   │
│                   │                   │ encrypted Aurora   │        │                   │
│                   │                   │ clusters, which    │        │                   │
│                   │                   │ partially matches  │        │                   │
│                   │                   │ the request and    │        │                   │
│                   │                   │ GDPR Article 32    │        │                   │
│                   │                   │ availability       │        │                   │
│                   │                   │ context. However,  │        │                   │
│                   │                   │ it misses critical │        │                   │
│                   │                   │ requested          │        │                   │
│                   │                   │ infrastructure:    │        │                   │
│                   │                   │ there is no VPC    │        │                   │
│                   │                   │ peering resource   │        │                   │
│                   │                   │ at all, no actual  │        │                   │
│                   │                   │ Aurora Global      │        │                   │
│                   │                   │ Database           │        │                   │
│                   │                   │ configuration or   │        │                   │
│                   │                   │ global cluster     │        │                   │
│                   │                   │ linkage for        │        │                   │
│                   │                   │ active-passive     │        │                   │
│                   │                   │ cross-region       │        │                   │
│                   │                   │ replication, and   │        │                   │
│                   │                   │ no S3 bucket       │        │                   │
│                   │                   │ resources or       │        │                   │
│                   │                   │ cross-region       │        │                   │
│                   │                   │ replication setup  │        │                   │
│                   │                   │ for Terraform      │        │                   │
│                   │                   │ state—only backend │        │                   │
│                   │                   │ stanzas with       │        │                   │
│                   │                   │ placeholder bucket │        │                   │
│                   │                   │ names. It also has │        │                   │
│                   │                   │ major correctness  │        │                   │
│                   │                   │ issues, including  │        │                   │
│                   │                   │ duplicated/confli… │        │                   │
│                   │                   │ files, outputs     │        │                   │
│                   │                   │ referencing        │        │                   │
│                   │                   │ nonexistent        │        │                   │
│                   │                   │ resources, and a   │        │                   │
│                   │                   │ secondary RDS      │        │                   │
│                   │                   │ cluster that is    │        │                   │
│                   │                   │ merely commented   │        │                   │
│                   │                   │ as a replica       │        │                   │
│                   │                   │ rather than        │        │                   │
│                   │                   │ configured as one. │        │                   │
│                   │                   │ Security/complian… │        │                   │
│                   │                   │ is only partially  │        │                   │
│                   │                   │ addressed via      │        │                   │
│                   │                   │ storage            │        │                   │
│                   │                   │ encryption; secure │        │                   │
│                   │                   │ transit/TLS is not │        │                   │
│                   │                   │ enforced on the    │        │                   │
│                   │                   │ ALBs, and the      │        │                   │
│                   │                   │ state backend      │        │                   │
│                   │                   │ lacks a compliant  │        │                   │
│                   │                   │ implemented        │        │                   │
│                   │                   │ replication        │        │                   │
│                   │                   │ design.,           │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 7.98s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


