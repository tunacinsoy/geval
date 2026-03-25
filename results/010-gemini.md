
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.65s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.66s[0m[0m
                                       Test Results
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.6                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ the core requested │        │                   │
│                   │                   │ resources: an EC2  │        │                   │
│                   │                   │ Image Builder      │        │                   │
│                   │                   │ pipeline based on  │        │                   │
│                   │                   │ Amazon Linux 2023, │        │                   │
│                   │                   │ an Image Builder   │        │                   │
│                   │                   │ component that     │        │                   │
│                   │                   │ runs an Ansible    │        │                   │
│                   │                   │ playbook for CIS   │        │                   │
│                   │                   │ hardening, a       │        │                   │
│                   │                   │ launch template    │        │                   │
│                   │                   │ consuming a        │        │                   │
│                   │                   │ dynamically        │        │                   │
│                   │                   │ looked-up hardened │        │                   │
│                   │                   │ AMI, and an ASG    │        │                   │
│                   │                   │ with               │        │                   │
│                   │                   │ instance_refresh   │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ create_before_des… │        │                   │
│                   │                   │ behavior that      │        │                   │
│                   │                   │ supports           │        │                   │
│                   │                   │ launch-before-ter… │        │                   │
│                   │                   │ semantics. It also │        │                   │
│                   │                   │ partially aligns   │        │                   │
│                   │                   │ with the           │        │                   │
│                   │                   │ healthcare/GDPR    │        │                   │
│                   │                   │ context by using   │        │                   │
│                   │                   │ private subnets    │        │                   │
│                   │                   │ and encrypted S3   │        │                   │
│                   │                   │ backend state.     │        │                   │
│                   │                   │ However, it misses │        │                   │
│                   │                   │ important          │        │                   │
│                   │                   │ compliance and     │        │                   │
│                   │                   │ correctness        │        │                   │
│                   │                   │ details: no        │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ encryption         │        │                   │
│                   │                   │ settings for the   │        │                   │
│                   │                   │ built AMI or       │        │                   │
│                   │                   │ launch template    │        │                   │
│                   │                   │ volumes, no secure │        │                   │
│                   │                   │ transport controls │        │                   │
│                   │                   │ for fetching the   │        │                   │
│                   │                   │ playbook from S3,  │        │                   │
│                   │                   │ and no geographic  │        │                   │
│                   │                   │ restriction logic  │        │                   │
│                   │                   │ despite EU         │        │                   │
│                   │                   │ resident data in   │        │                   │
│                   │                   │ context. The       │        │                   │
│                   │                   │ immutable          │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ requirement is     │        │                   │
│                   │                   │ only partially met │        │                   │
│                   │                   │ because the ASG    │        │                   │
│                   │                   │ refresh is rolling │        │                   │
│                   │                   │ rather than        │        │                   │
│                   │                   │ clearly enforcing  │        │                   │
│                   │                   │ full replacement   │        │                   │
│                   │                   │ semantics, and the │        │                   │
│                   │                   │ AMI lookup depends │        │                   │
│                   │                   │ on the pipeline    │        │                   │
│                   │                   │ resource rather    │        │                   │
│                   │                   │ than an actual     │        │                   │
│                   │                   │ image build. There │        │                   │
│                   │                   │ are also           │        │                   │
│                   │                   │ significant        │        │                   │
│                   │                   │ implementation     │        │                   │
│                   │                   │ issues in          │        │                   │
│                   │                   │ tfvars/variables   │        │                   │
│                   │                   │ naming mismatches  │        │                   │
│                   │                   │ (env, alert_email, │        │                   │
│                   │                   │ private_subnet_id  │        │                   │
│                   │                   │ vs                 │        │                   │
│                   │                   │ private_subnet_id… │        │                   │
│                   │                   │ ansible_playbook_… │        │                   │
│                   │                   │ vs                 │        │                   │
│                   │                   │ ansible_playbook_… │        │                   │
│                   │                   │ that would break   │        │                   │
│                   │                   │ the                │        │                   │
│                   │                   │ configuration.,    │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.32s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


