    🎯 Evaluating test case #0                                                   0% 0:00:07
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
7.84s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 7.85s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.29               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ generated          │        │                   │
│                   │                   │ Terraform only     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ and does so        │        │                   │
│                   │                   │ incoherently. It   │        │                   │
│                   │                   │ does target the    │        │                   │
│                   │                   │ requested regions  │        │                   │
│                   │                   │ and includes       │        │                   │
│                   │                   │ reasonably         │        │                   │
│                   │                   │ HA-oriented        │        │                   │
│                   │                   │ networking         │        │                   │
│                   │                   │ patterns like      │        │                   │
│                   │                   │ multi-AZ subnets,  │        │                   │
│                   │                   │ NAT gateways per   │        │                   │
│                   │                   │ AZ, ALBs in public │        │                   │
│                   │                   │ subnets, and app   │        │                   │
│                   │                   │ instances in       │        │                   │
│                   │                   │ private subnets.   │        │                   │
│                   │                   │ However, it fails  │        │                   │
│                   │                   │ several core       │        │                   │
│                   │                   │ requirements:      │        │                   │
│                   │                   │ there is no actual │        │                   │
│                   │                   │ VPC peering        │        │                   │
│                   │                   │ implementation,    │        │                   │
│                   │                   │ and identical CIDR │        │                   │
│                   │                   │ blocks would make  │        │                   │
│                   │                   │ peering invalid in │        │                   │
│                   │                   │ AWS anyway, so the │        │                   │
│                   │                   │ design does not    │        │                   │
│                   │                   │ resolve a major    │        │                   │
│                   │                   │ architectural      │        │                   │
│                   │                   │ contradiction in   │        │                   │
│                   │                   │ the prompt. The    │        │                   │
│                   │                   │ Aurora setup is    │        │                   │
│                   │                   │ not an Aurora      │        │                   │
│                   │                   │ Global Database;   │        │                   │
│                   │                   │ instead it creates │        │                   │
│                   │                   │ two independent    │        │                   │
│                   │                   │ regional clusters  │        │                   │
│                   │                   │ with a comment     │        │                   │
│                   │                   │ acknowledging the  │        │                   │
│                   │                   │ replica is not     │        │                   │
│                   │                   │ real. Terraform    │        │                   │
│                   │                   │ state storage with │        │                   │
│                   │                   │ S3 cross-region    │        │                   │
│                   │                   │ replication is     │        │                   │
│                   │                   │ also not           │        │                   │
│                   │                   │ implemented—only   │        │                   │
│                   │                   │ backend stanzas    │        │                   │
│                   │                   │ with placeholder   │        │                   │
│                   │                   │ bucket names are   │        │                   │
│                   │                   │ provided, and      │        │                   │
│                   │                   │ backend resources  │        │                   │
│                   │                   │ cannot bootstrap   │        │                   │
│                   │                   │ themselves this    │        │                   │
│                   │                   │ way. The codebase  │        │                   │
│                   │                   │ is additionally    │        │                   │
│                   │                   │ inconsistent and   │        │                   │
│                   │                   │ likely             │        │                   │
│                   │                   │ nonfunctional due  │        │                   │
│                   │                   │ to                 │        │                   │
│                   │                   │ duplicated/confli… │        │                   │
│                   │                   │ files, duplicate   │        │                   │
│                   │                   │ variable/local     │        │                   │
│                   │                   │ definitions,       │        │                   │
│                   │                   │ outputs            │        │                   │
│                   │                   │ referencing        │        │                   │
│                   │                   │ nonexistent        │        │                   │
│                   │                   │ resources, and     │        │                   │
│                   │                   │ provider/data      │        │                   │
│                   │                   │ source mismatches. │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Against the hidden │        │                   │
│                   │                   │ company context,   │        │                   │
│                   │                   │ the solution does  │        │                   │
│                   │                   │ not meaningfully   │        │                   │
│                   │                   │ anticipate GDPR    │        │                   │
│                   │                   │ Article 32-style   │        │                   │
│                   │                   │ resilience/compli… │        │                   │
│                   │                   │ needs beyond basic │        │                   │
│                   │                   │ multi-region       │        │                   │
│                   │                   │ intent. It lacks a │        │                   │
│                   │                   │ correct            │        │                   │
│                   │                   │ active-passive     │        │                   │
│                   │                   │ global database    │        │                   │
│                   │                   │ design, lacks a    │        │                   │
│                   │                   │ coherent DR        │        │                   │
│                   │                   │ failover           │        │                   │
│                   │                   │ mechanism, and     │        │                   │
│                   │                   │ does not           │        │                   │
│                   │                   │ strengthen         │        │                   │
│                   │                   │ security posture   │        │                   │
│                   │                   │ for a              │        │                   │
│                   │                   │ financial-data     │        │                   │
│                   │                   │ environment. There │        │                   │
│                   │                   │ are no strict      │        │                   │
│                   │                   │ egress controls or │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ whitelists, no     │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ encryption key     │        │                   │
│                   │                   │ strategy beyond    │        │                   │
│                   │                   │ default RDS        │        │                   │
│                   │                   │ encryption, no     │        │                   │
│                   │                   │ state bucket       │        │                   │
│                   │                   │ replication        │        │                   │
│                   │                   │ resources, and no  │        │                   │
│                   │                   │ compliance-orient… │        │                   │
│                   │                   │ tagging or         │        │                   │
│                   │                   │ backup/failover    │        │                   │
│                   │                   │ controls. So while │        │                   │
│                   │                   │ there are some HA  │        │                   │
│                   │                   │ signals, the       │        │                   │
│                   │                   │ implementation     │        │                   │
│                   │                   │ misses critical    │        │                   │
│                   │                   │ redundancy,        │        │                   │
│                   │                   │ correctness, and   │        │                   │
│                   │                   │ security           │        │                   │
│                   │                   │ expectations.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.29,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 8.35s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


