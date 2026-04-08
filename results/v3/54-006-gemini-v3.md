    🎯 Evaluating test case #0                                                   0% 0:00:11
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
11.63s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 11.63s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.31               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform only     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ implements the     │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ and does not       │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ address the hidden │        │                   │
│                   │                   │ business context.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Strengths:         │        │                   │
│                   │                   │ - Correctly        │        │                   │
│                   │                   │ targets two        │        │                   │
│                   │                   │ regions with       │        │                   │
│                   │                   │ aliased AWS        │        │                   │
│                   │                   │ providers.         │        │                   │
│                   │                   │ - Creates two      │        │                   │
│                   │                   │ VPCs,              │        │                   │
│                   │                   │ public/private     │        │                   │
│                   │                   │ subnets, ALBs, app │        │                   │
│                   │                   │ ASGs, and an       │        │                   │
│                   │                   │ Aurora Global      │        │                   │
│                   │                   │ Database           │        │                   │
│                   │                   │ structure.         │        │                   │
│                   │                   │ - Uses an S3       │        │                   │
│                   │                   │ backend for        │        │                   │
│                   │                   │ Terraform state.   │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Major issues       │        │                   │
│                   │                   │ against the        │        │                   │
│                   │                   │ explicit request:  │        │                   │
│                   │                   │ - VPC peering is   │        │                   │
│                   │                   │ invalid as         │        │                   │
│                   │                   │ written: AWS does  │        │                   │
│                   │                   │ not allow peering  │        │                   │
│                   │                   │ between VPCs with  │        │                   │
│                   │                   │ identical CIDR     │        │                   │
│                   │                   │ ranges, so the     │        │                   │
│                   │                   │ requested          │        │                   │
│                   │                   │ identical          │        │                   │
│                   │                   │ `10.10.0.0/16`     │        │                   │
│                   │                   │ design is not      │        │                   │
│                   │                   │ actually workable  │        │                   │
│                   │                   │ with peering. The  │        │                   │
│                   │                   │ code fails to      │        │                   │
│                   │                   │ detect or resolve  │        │                   │
│                   │                   │ this               │        │                   │
│                   │                   │ contradiction.     │        │                   │
│                   │                   │ - Cross-region VPC │        │                   │
│                   │                   │ peering also       │        │                   │
│                   │                   │ requires           │        │                   │
│                   │                   │ accepter-side      │        │                   │
│                   │                   │ handling;          │        │                   │
│                   │                   │ `auto_accept =     │        │                   │
│                   │                   │ true` is not       │        │                   │
│                   │                   │ sufficient across  │        │                   │
│                   │                   │ regions/accounts   │        │                   │
│                   │                   │ in this form.      │        │                   │
│                   │                   │ - ALBs and DB      │        │                   │
│                   │                   │ subnet groups are  │        │                   │
│                   │                   │ not highly         │        │                   │
│                   │                   │ available: only    │        │                   │
│                   │                   │ one public subnet  │        │                   │
│                   │                   │ and one private    │        │                   │
│                   │                   │ subnet per region  │        │                   │
│                   │                   │ are defined, but   │        │                   │
│                   │                   │ ALB and Aurora     │        │                   │
│                   │                   │ require/strongly   │        │                   │
│                   │                   │ expect multi-AZ    │        │                   │
│                   │                   │ subnet coverage    │        │                   │
│                   │                   │ for resilience.    │        │                   │
│                   │                   │ - Aurora Global    │        │                   │
│                   │                   │ Database is        │        │                   │
│                   │                   │ incomplete: no     │        │                   │
│                   │                   │ `aws_rds_cluster_… │        │                   │
│                   │                   │ resources are      │        │                   │
│                   │                   │ created, so the    │        │                   │
│                   │                   │ clusters are not   │        │                   │
│                   │                   │ usable.            │        │                   │
│                   │                   │ - DR Aurora        │        │                   │
│                   │                   │ cluster is         │        │                   │
│                   │                   │ incorrectly        │        │                   │
│                   │                   │ configured with    │        │                   │
│                   │                   │ master             │        │                   │
│                   │                   │ credentials;       │        │                   │
│                   │                   │ secondary global   │        │                   │
│                   │                   │ cluster members    │        │                   │
│                   │                   │ should be attached │        │                   │
│                   │                   │ differently and    │        │                   │
│                   │                   │ not configured     │        │                   │
│                   │                   │ like an            │        │                   │
│                   │                   │ independent        │        │                   │
│                   │                   │ writable primary.  │        │                   │
│                   │                   │ - Terraform        │        │                   │
│                   │                   │ backend            │        │                   │
│                   │                   │ replication is not │        │                   │
│                   │                   │ implemented: only  │        │                   │
│                   │                   │ backend            │        │                   │
│                   │                   │ configuration is   │        │                   │
│                   │                   │ declared, but no   │        │                   │
│                   │                   │ S3 bucket,         │        │                   │
│                   │                   │ versioning,        │        │                   │
│                   │                   │ replication        │        │                   │
│                   │                   │ configuration,     │        │                   │
│                   │                   │ destination        │        │                   │
│                   │                   │ bucket, IAM        │        │                   │
│                   │                   │ replication role,  │        │                   │
│                   │                   │ or KMS             │        │                   │
│                   │                   │ considerations are │        │                   │
│                   │                   │ provisioned.       │        │                   │
│                   │                   │ - No route tables, │        │                   │
│                   │                   │ internet gateways, │        │                   │
│                   │                   │ NAT gateways, or   │        │                   │
│                   │                   │ routing are        │        │                   │
│                   │                   │ defined, so        │        │                   │
│                   │                   │ “public” and       │        │                   │
│                   │                   │ “private” subnet   │        │                   │
│                   │                   │ behavior is not    │        │                   │
│                   │                   │ actually           │        │                   │
│                   │                   │ established.       │        │                   │
│                   │                   │ - Security groups  │        │                   │
│                   │                   │ are incomplete,    │        │                   │
│                   │                   │ lacking egress     │        │                   │
│                   │                   │ rules and tighter  │        │                   │
│                   │                   │ controls.          │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Major issues       │        │                   │
│                   │                   │ against hidden     │        │                   │
│                   │                   │ context / implicit │        │                   │
│                   │                   │ constraints:       │        │                   │
│                   │                   │ - No GDPR-oriented │        │                   │
│                   │                   │ resilience         │        │                   │
│                   │                   │ hardening beyond   │        │                   │
│                   │                   │ basic multi-region │        │                   │
│                   │                   │ intent.            │        │                   │
│                   │                   │ - No meaningful    │        │                   │
│                   │                   │ disaster recovery  │        │                   │
│                   │                   │ readiness          │        │                   │
│                   │                   │ validation,        │        │                   │
│                   │                   │ failover           │        │                   │
│                   │                   │ orchestration,     │        │                   │
│                   │                   │ backup retention,  │        │                   │
│                   │                   │ encryption,        │        │                   │
│                   │                   │ deletion           │        │                   │
│                   │                   │ protection, or     │        │                   │
│                   │                   │ monitoring for     │        │                   │
│                   │                   │ database health.   │        │                   │
│                   │                   │ - No strict        │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ whitelisting of    │        │                   │
│                   │                   │ outbound           │        │                   │
│                   │                   │ destinations such  │        │                   │
│                   │                   │ as docker.io or    │        │                   │
│                   │                   │ ubuntu.com; in     │        │                   │
│                   │                   │ practice AWS       │        │                   │
│                   │                   │ security groups    │        │                   │
│                   │                   │ cannot whitelist   │        │                   │
│                   │                   │ FQDNs directly,    │        │                   │
│                   │                   │ and the code does  │        │                   │
│                   │                   │ not attempt any    │        │                   │
│                   │                   │ compensating       │        │                   │
│                   │                   │ control.           │        │                   │
│                   │                   │ - Hardcoded        │        │                   │
│                   │                   │ database           │        │                   │
│                   │                   │ credentials are a  │        │                   │
│                   │                   │ serious security   │        │                   │
│                   │                   │ flaw and           │        │                   │
│                   │                   │ inappropriate for  │        │                   │
│                   │                   │ financial data     │        │                   │
│                   │                   │ handling.          │        │                   │
│                   │                   │ - Placeholder AMI  │        │                   │
│                   │                   │ and legacy         │        │                   │
│                   │                   │ `aws_launch_confi… │        │                   │
│                   │                   │ reduce production  │        │                   │
│                   │                   │ readiness.         │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, the code  │        │                   │
│                   │                   │ captures the rough │        │                   │
│                   │                   │ shape of the       │        │                   │
│                   │                   │ requested          │        │                   │
│                   │                   │ architecture but   │        │                   │
│                   │                   │ is not coherent or │        │                   │
│                   │                   │ deployable as a    │        │                   │
│                   │                   │ compliant,         │        │                   │
│                   │                   │ resilient DR       │        │                   │
│                   │                   │ design. It misses  │        │                   │
│                   │                   │ critical HA,       │        │                   │
│                   │                   │ routing, backend   │        │                   │
│                   │                   │ replication, and   │        │                   │
│                   │                   │ security           │        │                   │
│                   │                   │ requirements, and  │        │                   │
│                   │                   │ it fails to        │        │                   │
│                   │                   │ resolve the        │        │                   │
│                   │                   │ fundamental        │        │                   │
│                   │                   │ CIDR/peering       │        │                   │
│                   │                   │ conflict.          │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.31,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 12.12s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


