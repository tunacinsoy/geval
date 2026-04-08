    🎯 Evaluating test case #0                                                   0% 0:00:10
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
10.92s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 10.93s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.56               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform          │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ but has several    │        │                   │
│                   │                   │ correctness and    │        │                   │
│                   │                   │ completeness       │        │                   │
│                   │                   │ issues, and it     │        │                   │
│                   │                   │ does not           │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ address the hidden │        │                   │
│                   │                   │ compliance-driven  │        │                   │
│                   │                   │ immutable          │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ context beyond a   │        │                   │
│                   │                   │ basic rolling      │        │                   │
│                   │                   │ refresh pattern.   │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Strengths:         │        │                   │
│                   │                   │ - It does define   │        │                   │
│                   │                   │ an EC2 Image       │        │                   │
│                   │                   │ Builder pipeline   │        │                   │
│                   │                   │ based on Amazon    │        │                   │
│                   │                   │ Linux 2023.        │        │                   │
│                   │                   │ - It includes a    │        │                   │
│                   │                   │ custom Image       │        │                   │
│                   │                   │ Builder component  │        │                   │
│                   │                   │ that runs an       │        │                   │
│                   │                   │ Ansible playbook   │        │                   │
│                   │                   │ intended for CIS   │        │                   │
│                   │                   │ Level 1 hardening. │        │                   │
│                   │                   │ - It wires the     │        │                   │
│                   │                   │ resulting AMI into │        │                   │
│                   │                   │ a launch template  │        │                   │
│                   │                   │ via a dynamic      │        │                   │
│                   │                   │ `aws_ami` lookup.  │        │                   │
│                   │                   │ - The ASG uses     │        │                   │
│                   │                   │ `instance_refresh` │        │                   │
│                   │                   │ with               │        │                   │
│                   │                   │ `min_healthy_perc… │        │                   │
│                   │                   │ = 100`, which      │        │                   │
│                   │                   │ aligns with        │        │                   │
│                   │                   │ launch-before-ter… │        │                   │
│                   │                   │ behavior for       │        │                   │
│                   │                   │ zero-downtime      │        │                   │
│                   │                   │ replacement when   │        │                   │
│                   │                   │ capacity allows.   │        │                   │
│                   │                   │ - It targets a     │        │                   │
│                   │                   │ specific AWS       │        │                   │
│                   │                   │ region and uses    │        │                   │
│                   │                   │ multiple subnets   │        │                   │
│                   │                   │ for the ASG, which │        │                   │
│                   │                   │ supports           │        │                   │
│                   │                   │ availability.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Weaknesses:        │        │                   │
│                   │                   │ - The Image        │        │                   │
│                   │                   │ Builder parent     │        │                   │
│                   │                   │ image ARN is       │        │                   │
│                   │                   │ invalid/incomplete │        │                   │
│                   │                   │ (`x.x.x`           │        │                   │
│                   │                   │ placeholder), so   │        │                   │
│                   │                   │ the pipeline is    │        │                   │
│                   │                   │ not actually       │        │                   │
│                   │                   │ deployable as      │        │                   │
│                   │                   │ written.           │        │                   │
│                   │                   │ - The Ansible      │        │                   │
│                   │                   │ component uses     │        │                   │
│                   │                   │ `aws s3 cp` but    │        │                   │
│                   │                   │ the Image Builder  │        │                   │
│                   │                   │ instance role      │        │                   │
│                   │                   │ lacks explicit S3  │        │                   │
│                   │                   │ read permissions   │        │                   │
│                   │                   │ for the playbook   │        │                   │
│                   │                   │ location.          │        │                   │
│                   │                   │ - The AMI lookup   │        │                   │
│                   │                   │ depends on the     │        │                   │
│                   │                   │ pipeline resource, │        │                   │
│                   │                   │ but that does not  │        │                   │
│                   │                   │ guarantee an image │        │                   │
│                   │                   │ has actually been  │        │                   │
│                   │                   │ built; Terraform   │        │                   │
│                   │                   │ cannot reliably    │        │                   │
│                   │                   │ wait for scheduled │        │                   │
│                   │                   │ pipeline output    │        │                   │
│                   │                   │ this way.          │        │                   │
│                   │                   │ - The launch       │        │                   │
│                   │                   │ template/ASG       │        │                   │
│                   │                   │ linkage will not   │        │                   │
│                   │                   │ automatically      │        │                   │
│                   │                   │ trigger refresh on │        │                   │
│                   │                   │ new AMI creation   │        │                   │
│                   │                   │ unless Terraform   │        │                   │
│                   │                   │ is re-applied      │        │                   │
│                   │                   │ after a new AMI    │        │                   │
│                   │                   │ exists.            │        │                   │
│                   │                   │ - Several variable │        │                   │
│                   │                   │ mismatches make    │        │                   │
│                   │                   │ the configuration  │        │                   │
│                   │                   │ inconsistent or    │        │                   │
│                   │                   │ broken: `env`,     │        │                   │
│                   │                   │ `alert_email`,     │        │                   │
│                   │                   │ `private_subnet_i… │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ `ansible_playbook… │        │                   │
│                   │                   │ are used in        │        │                   │
│                   │                   │ tfvars/resources   │        │                   │
│                   │                   │ but not properly   │        │                   │
│                   │                   │ declared or        │        │                   │
│                   │                   │ matched to actual  │        │                   │
│                   │                   │ variable names.    │        │                   │
│                   │                   │ - The ASG refresh  │        │                   │
│                   │                   │ is not especially  │        │                   │
│                   │                   │ “strict” beyond    │        │                   │
│                   │                   │ `min_healthy_perc… │        │                   │
│                   │                   │ = 100`; there are  │        │                   │
│                   │                   │ no checkpoints, no │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ replacement        │        │                   │
│                   │                   │ triggers, and no   │        │                   │
│                   │                   │ stronger immutable │        │                   │
│                   │                   │ rollout controls.  │        │                   │
│                   │                   │ - Security groups  │        │                   │
│                   │                   │ allow unrestricted │        │                   │
│                   │                   │ egress to          │        │                   │
│                   │                   │ `0.0.0.0/0`; there │        │                   │
│                   │                   │ are no strict      │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ whitelists, and    │        │                   │
│                   │                   │ nothing like       │        │                   │
│                   │                   │ docker.io/ubuntu.… │        │                   │
│                   │                   │ allowlisting.      │        │                   │
│                   │                   │ - The hidden       │        │                   │
│                   │                   │ business context   │        │                   │
│                   │                   │ around             │        │                   │
│                   │                   │ tamper-proof       │        │                   │
│                   │                   │ immutable          │        │                   │
│                   │                   │ compliance and     │        │                   │
│                   │                   │ GDPR-grade         │        │                   │
│                   │                   │ auditability is    │        │                   │
│                   │                   │ not really         │        │                   │
│                   │                   │ implemented. There │        │                   │
│                   │                   │ is no stronger     │        │                   │
│                   │                   │ audit trail        │        │                   │
│                   │                   │ design, no         │        │                   │
│                   │                   │ distribution       │        │                   │
│                   │                   │ controls, no image │        │                   │
│                   │                   │ tests/validation,  │        │                   │
│                   │                   │ no KMS/encryption  │        │                   │
│                   │                   │ specifics, and no  │        │                   │
│                   │                   │ compliance-orient… │        │                   │
│                   │                   │ hardening around   │        │                   │
│                   │                   │ build/runtime      │        │                   │
│                   │                   │ isolation.         │        │                   │
│                   │                   │ - High             │        │                   │
│                   │                   │ availability is    │        │                   │
│                   │                   │ only partially     │        │                   │
│                   │                   │ addressed through  │        │                   │
│                   │                   │ multi-subnet ASG   │        │                   │
│                   │                   │ placement; there   │        │                   │
│                   │                   │ is no explicit     │        │                   │
│                   │                   │ multi-AZ balancing │        │                   │
│                   │                   │ detail, health     │        │                   │
│                   │                   │ check tuning, or   │        │                   │
│                   │                   │ resilient          │        │                   │
│                   │                   │ notification/audit │        │                   │
│                   │                   │ architecture.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall, this is a │        │                   │
│                   │                   │ decent first-pass  │        │                   │
│                   │                   │ implementation of  │        │                   │
│                   │                   │ the explicit       │        │                   │
│                   │                   │ request, but it is │        │                   │
│                   │                   │ not fully          │        │                   │
│                   │                   │ functional and     │        │                   │
│                   │                   │ falls short on the │        │                   │
│                   │                   │ implicit           │        │                   │
│                   │                   │ security/complian… │        │                   │
│                   │                   │ architecture       │        │                   │
│                   │                   │ expectations.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.56,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 11.45s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


