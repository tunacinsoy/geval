
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.47s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.48s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.1                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ a broad AWS test   │        │                   │
│                   │                   │ stack with VPC,    │        │                   │
│                   │                   │ EC2, RDS, S3,      │        │                   │
│                   │                   │ security groups,   │        │                   │
│                   │                   │ and some           │        │                   │
│                   │                   │ encryption at rest │        │                   │
│                   │                   │ for EBS, RDS, and  │        │                   │
│                   │                   │ S3, so some        │        │                   │
│                   │                   │ explicit           │        │                   │
│                   │                   │ infrastructure is  │        │                   │
│                   │                   │ present. However,  │        │                   │
│                   │                   │ it fails the       │        │                   │
│                   │                   │ critical hidden    │        │                   │
│                   │                   │ requirement from   │        │                   │
│                   │                   │ the input: this is │        │                   │
│                   │                   │ a non-production   │        │                   │
│                   │                   │ test environment   │        │                   │
│                   │                   │ using EU minors'   │        │                   │
│                   │                   │ sensitive          │        │                   │
│                   │                   │ GDPR-regulated     │        │                   │
│                   │                   │ data, which        │        │                   │
│                   │                   │ requires dynamic   │        │                   │
│                   │                   │ data masking or    │        │                   │
│                   │                   │ synthetic data     │        │                   │
│                   │                   │ generation, and    │        │                   │
│                   │                   │ the code instead   │        │                   │
│                   │                   │ provisions a plain │        │                   │
│                   │                   │ PostgreSQL test    │        │                   │
│                   │                   │ database with no   │        │                   │
│                   │                   │ masking,           │        │                   │
│                   │                   │ anonymization, or  │        │                   │
│                   │                   │ synthetic-data     │        │                   │
│                   │                   │ controls. It also  │        │                   │
│                   │                   │ defaults to        │        │                   │
│                   │                   │ us-east-1 despite  │        │                   │
│                   │                   │ European student   │        │                   │
│                   │                   │ data and           │        │                   │
│                   │                   │ geographic         │        │                   │
│                   │                   │ restrictions,      │        │                   │
│                   │                   │ exposes            │        │                   │
│                   │                   │ SSH/HTTP/HTTPS     │        │                   │
│                   │                   │ from 0.0.0.0/0,    │        │                   │
│                   │                   │ and lacks clear    │        │                   │
│                   │                   │ transit-encryption │        │                   │
│                   │                   │ enforcement for    │        │                   │
│                   │                   │ the database,      │        │                   │
│                   │                   │ making the         │        │                   │
│                   │                   │ solution largely   │        │                   │
│                   │                   │ non-compliant      │        │                   │
│                   │                   │ despite otherwise  │        │                   │
│                   │                   │ reasonable         │        │                   │
│                   │                   │ resource           │        │                   │
│                   │                   │ dependencies.,     │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.05s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


