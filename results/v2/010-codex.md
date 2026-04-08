
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
6.86s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 6.87s[0m[0m
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
│                   │                   │ resources like an  │        │                   │
│                   │                   │ Image Builder      │        │                   │
│                   │                   │ recipe, component, │        │                   │
│                   │                   │ pipeline, launch   │        │                   │
│                   │                   │ template, and ASG, │        │                   │
│                   │                   │ and it attempts    │        │                   │
│                   │                   │ dynamic AMI lookup │        │                   │
│                   │                   │ via SSM plus an    │        │                   │
│                   │                   │ instance_refresh   │        │                   │
│                   │                   │ block. However, it │        │                   │
│                   │                   │ does not actually  │        │                   │
│                   │                   │ produce or         │        │                   │
│                   │                   │ reference the      │        │                   │
│                   │                   │ hardened AMI from  │        │                   │
│                   │                   │ the Image Builder  │        │                   │
│                   │                   │ pipeline: the SSM  │        │                   │
│                   │                   │ parameter is       │        │                   │
│                   │                   │ populated from the │        │                   │
│                   │                   │ base Amazon Linux  │        │                   │
│                   │                   │ 2023 AMI data      │        │                   │
│                   │                   │ source, not the    │        │                   │
│                   │                   │ built image. The   │        │                   │
│                   │                   │ Ansible CIS        │        │                   │
│                   │                   │ component is only  │        │                   │
│                   │                   │ a placeholder echo │        │                   │
│                   │                   │ task rather than   │        │                   │
│                   │                   │ real CIS Level 1   │        │                   │
│                   │                   │ hardening. For the │        │                   │
│                   │                   │ CarePlus Health    │        │                   │
│                   │                   │ context handling   │        │                   │
│                   │                   │ health records for │        │                   │
│                   │                   │ EU residents, the  │        │                   │
│                   │                   │ configuration      │        │                   │
│                   │                   │ misses explicit    │        │                   │
│                   │                   │ GDPR-oriented      │        │                   │
│                   │                   │ controls such as   │        │                   │
│                   │                   │ region/geographic  │        │                   │
│                   │                   │ restrictions and   │        │                   │
│                   │                   │ stronger           │        │                   │
│                   │                   │ immutable/audit    │        │                   │
│                   │                   │ alignment; the     │        │                   │
│                   │                   │ pipeline is even   │        │                   │
│                   │                   │ disabled,          │        │                   │
│                   │                   │ undermining        │        │                   │
│                   │                   │ continuous         │        │                   │
│                   │                   │ compliance.        │        │                   │
│                   │                   │ Security is mixed: │        │                   │
│                   │                   │ there is some      │        │                   │
│                   │                   │ encryption for the │        │                   │
│                   │                   │ S3 backend and     │        │                   │
│                   │                   │ artifacts bucket   │        │                   │
│                   │                   │ and TLS on the     │        │                   │
│                   │                   │ ALB, but there are │        │                   │
│                   │                   │ major issues like  │        │                   │
│                   │                   │ overly broad IAM   │        │                   │
│                   │                   │ permissions and a  │        │                   │
│                   │                   │ builder security   │        │                   │
│                   │                   │ group exposing SSH │        │                   │
│                   │                   │ to 0.0.0.0/0. The  │        │                   │
│                   │                   │ ASG refresh policy │        │                   │
│                   │                   │ is not strict      │        │                   │
│                   │                   │ enough to          │        │                   │
│                   │                   │ guarantee          │        │                   │
│                   │                   │ launch-before-ter… │        │                   │
│                   │                   │ zero downtime,     │        │                   │
│                   │                   │ since it uses      │        │                   │
│                   │                   │ rolling refresh    │        │                   │
│                   │                   │ with only          │        │                   │
│                   │                   │ min_healthy_perce… │        │                   │
│                   │                   │ instead of         │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ launch-first style │        │                   │
│                   │                   │ settings.,         │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 7.7s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


