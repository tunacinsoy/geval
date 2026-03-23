
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
7.03s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 7.04s[0m[0m
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
│                   │                   │ requested pieces   │        │                   │
│                   │                   │ such as an EC2     │        │                   │
│                   │                   │ Image Builder      │        │                   │
│                   │                   │ recipe based on    │        │                   │
│                   │                   │ Amazon Linux 2023, │        │                   │
│                   │                   │ a launch template  │        │                   │
│                   │                   │ that dynamically   │        │                   │
│                   │                   │ looks up a         │        │                   │
│                   │                   │ hardened AMI, and  │        │                   │
│                   │                   │ an ASG with        │        │                   │
│                   │                   │ instance_refresh   │        │                   │
│                   │                   │ plus               │        │                   │
│                   │                   │ create_before_des… │        │                   │
│                   │                   │ intent. However,   │        │                   │
│                   │                   │ alignment is weak  │        │                   │
│                   │                   │ because the        │        │                   │
│                   │                   │ Terraform is not   │        │                   │
│                   │                   │ holistically       │        │                   │
│                   │                   │ correct for the    │        │                   │
│                   │                   │ request or the     │        │                   │
│                   │                   │ healthcare/GDPR    │        │                   │
│                   │                   │ context: the Image │        │                   │
│                   │                   │ Builder component  │        │                   │
│                   │                   │ does not clearly   │        │                   │
│                   │                   │ define a valid     │        │                   │
│                   │                   │ Ansible component  │        │                   │
│                   │                   │ document,          │        │                   │
│                   │                   │ compliance         │        │                   │
│                   │                   │ scanning is        │        │                   │
│                   │                   │ optional and       │        │                   │
│                   │                   │ disabled by        │        │                   │
│                   │                   │ default, and the   │        │                   │
│                   │                   │ ASG refresh is not │        │                   │
│                   │                   │ configured to      │        │                   │
│                   │                   │ explicitly         │        │                   │
│                   │                   │ prioritize         │        │                   │
│                   │                   │ launch-before-ter… │        │                   │
│                   │                   │ zero-downtime      │        │                   │
│                   │                   │ behavior. It also  │        │                   │
│                   │                   │ introduces         │        │                   │
│                   │                   │ risky/non-complia… │        │                   │
│                   │                   │ elements for       │        │                   │
│                   │                   │ CarePlus Health,   │        │                   │
│                   │                   │ including broad    │        │                   │
│                   │                   │ SSH access         │        │                   │
│                   │                   │ defaulting to      │        │                   │
│                   │                   │ 0.0.0.0/0,         │        │                   │
│                   │                   │ self-signed ALB    │        │                   │
│                   │                   │ certs, comments    │        │                   │
│                   │                   │ about creating an  │        │                   │
│                   │                   │ unencrypted base   │        │                   │
│                   │                   │ AMI export, and no │        │                   │
│                   │                   │ clear immutable    │        │                   │
│                   │                   │ audit-trail        │        │                   │
│                   │                   │ controls tied to   │        │                   │
│                   │                   │ regulated          │        │                   │
│                   │                   │ health-record      │        │                   │
│                   │                   │ processing for EU  │        │                   │
│                   │                   │ residents. There   │        │                   │
│                   │                   │ are also obvious   │        │                   │
│                   │                   │ correctness issues │        │                   │
│                   │                   │ like a malformed   │        │                   │
│                   │                   │ dynamic            │        │                   │
│                   │                   │ target_group_arns  │        │                   │
│                   │                   │ block and          │        │                   │
│                   │                   │ unrelated GCP      │        │                   │
│                   │                   │ tfvars, which      │        │                   │
│                   │                   │ reduce confidence  │        │                   │
│                   │                   │ in infrastructure  │        │                   │
│                   │                   │ soundness.,        │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 7.54s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


