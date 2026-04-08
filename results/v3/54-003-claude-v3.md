    🎯 Evaluating test case #0                                                   0% 0:00:13
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
13.18s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 13.19s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.24               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform          │        │                   │
│                   │                   │ partially fits the │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ for a cheap,       │        │                   │
│                   │                   │ temporary          │        │                   │
│                   │                   │ playground: it     │        │                   │
│                   │                   │ uses small         │        │                   │
│                   │                   │ instance sizes,    │        │                   │
│                   │                   │ simple networking, │        │                   │
│                   │                   │ tags an expiration │        │                   │
│                   │                   │ date, and keeps    │        │                   │
│                   │                   │ the stack          │        │                   │
│                   │                   │ disposable.        │        │                   │
│                   │                   │ However, it fails  │        │                   │
│                   │                   │ badly against the  │        │                   │
│                   │                   │ hidden context,    │        │                   │
│                   │                   │ which is the more  │        │                   │
│                   │                   │ important          │        │                   │
│                   │                   │ requirement here.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ The hidden context │        │                   │
│                   │                   │ implies severe     │        │                   │
│                   │                   │ GDPR-sensitive     │        │                   │
│                   │                   │ handling of real   │        │                   │
│                   │                   │ student PII and    │        │                   │
│                   │                   │ disability data    │        │                   │
│                   │                   │ from minors in a   │        │                   │
│                   │                   │ non-production     │        │                   │
│                   │                   │ test environment.  │        │                   │
│                   │                   │ The code does not  │        │                   │
│                   │                   │ implement any      │        │                   │
│                   │                   │ dynamic data       │        │                   │
│                   │                   │ masking, synthetic │        │                   │
│                   │                   │ data generation,   │        │                   │
│                   │                   │ anonymization      │        │                   │
│                   │                   │ pipeline, access   │        │                   │
│                   │                   │ segregation, audit │        │                   │
│                   │                   │ controls, or       │        │                   │
│                   │                   │ policy guardrails  │        │                   │
│                   │                   │ preventing         │        │                   │
│                   │                   │ production         │        │                   │
│                   │                   │ snapshots from     │        │                   │
│                   │                   │ being used raw. In │        │                   │
│                   │                   │ fact, it           │        │                   │
│                   │                   │ provisions a       │        │                   │
│                   │                   │ normal test RDS    │        │                   │
│                   │                   │ instance and even  │        │                   │
│                   │                   │ encourages direct  │        │                   │
│                   │                   │ database           │        │                   │
│                   │                   │ connectivity. That │        │                   │
│                   │                   │ is a major miss.   │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Security posture   │        │                   │
│                   │                   │ is also weak for   │        │                   │
│                   │                   │ this context: SSH, │        │                   │
│                   │                   │ HTTP, and HTTPS    │        │                   │
│                   │                   │ are open to        │        │                   │
│                   │                   │ 0.0.0.0/0 on       │        │                   │
│                   │                   │ compute instances; │        │                   │
│                   │                   │ there are no       │        │                   │
│                   │                   │ strict             │        │                   │
│                   │                   │ egress/firewall    │        │                   │
│                   │                   │ controls or domain │        │                   │
│                   │                   │ allowlists such as │        │                   │
│                   │                   │ docker.io/ubuntu.… │        │                   │
│                   │                   │ no WAF, no VPC     │        │                   │
│                   │                   │ endpoints, no      │        │                   │
│                   │                   │ Secrets Manager,   │        │                   │
│                   │                   │ no KMS CMKs, no    │        │                   │
│                   │                   │ IAM DB auth, no    │        │                   │
│                   │                   │ SSM policy despite │        │                   │
│                   │                   │ suggesting SSM     │        │                   │
│                   │                   │ usage, and no      │        │                   │
│                   │                   │ deletion           │        │                   │
│                   │                   │ protections or     │        │                   │
│                   │                   │ compliance-orient… │        │                   │
│                   │                   │ logging/auditing.  │        │                   │
│                   │                   │ High availability  │        │                   │
│                   │                   │ is only            │        │                   │
│                   │                   │ superficially      │        │                   │
│                   │                   │ addressed: it      │        │                   │
│                   │                   │ claims             │        │                   │
│                   │                   │ standby/failover   │        │                   │
│                   │                   │ but actually sets  │        │                   │
│                   │                   │ single-AZ subnets  │        │                   │
│                   │                   │ and creates a read │        │                   │
│                   │                   │ replica rather     │        │                   │
│                   │                   │ than a proper      │        │                   │
│                   │                   │ compliant HA       │        │                   │
│                   │                   │ architecture.      │        │                   │
│                   │                   │ There are also     │        │                   │
│                   │                   │ coherence/quality  │        │                   │
│                   │                   │ issues: duplicate  │        │                   │
│                   │                   │ outputs,           │        │                   │
│                   │                   │ references to      │        │                   │
│                   │                   │ outputs inside     │        │                   │
│                   │                   │ outputs, and       │        │                   │
│                   │                   │ likely             │        │                   │
│                   │                   │ invalid/misleading │        │                   │
│                   │                   │ RDS                │        │                   │
│                   │                   │ comments/configur… │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Because the prompt │        │                   │
│                   │                   │ says to reward     │        │                   │
│                   │                   │ high availability, │        │                   │
│                   │                   │ region             │        │                   │
│                   │                   │ specificity, and   │        │                   │
│                   │                   │ strict firewall    │        │                   │
│                   │                   │ whitelists if      │        │                   │
│                   │                   │ present: region    │        │                   │
│                   │                   │ specificity is     │        │                   │
│                   │                   │ present            │        │                   │
│                   │                   │ (`us-east-1`), but │        │                   │
│                   │                   │ HA is              │        │                   │
│                   │                   │ weak/inaccurate    │        │                   │
│                   │                   │ and strict         │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ whitelisting is    │        │                   │
│                   │                   │ absent. Overall,   │        │                   │
│                   │                   │ the code mostly    │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ “temporary         │        │                   │
│                   │                   │ playground” ask    │        │                   │
│                   │                   │ while ignoring the │        │                   │
│                   │                   │ critical implicit  │        │                   │
│                   │                   │ compliance and     │        │                   │
│                   │                   │ security           │        │                   │
│                   │                   │ constraints.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.24,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 13.68s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


