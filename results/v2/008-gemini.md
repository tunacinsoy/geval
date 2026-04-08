
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
4.14s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 4.15s[0m[0m
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
│                   │                   │ the main requested │        │                   │
│                   │                   │ components: a      │        │                   │
│                   │                   │ Pub/Sub topic      │        │                   │
│                   │                   │ named              │        │                   │
│                   │                   │ order-events, an   │        │                   │
│                   │                   │ Avro schema        │        │                   │
│                   │                   │ resource, a push   │        │                   │
│                   │                   │ subscription to    │        │                   │
│                   │                   │ Cloud Run, a pull  │        │                   │
│                   │                   │ subscription, and  │        │                   │
│                   │                   │ a dedicated        │        │                   │
│                   │                   │ service account    │        │                   │
│                   │                   │ with               │        │                   │
│                   │                   │ roles/pubsub.subs… │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ roles/cloudsql.cl… │        │                   │
│                   │                   │ It also sets Cloud │        │                   │
│                   │                   │ Run scaling to min │        │                   │
│                   │                   │ 0 and max 10.      │        │                   │
│                   │                   │ However, schema    │        │                   │
│                   │                   │ enforcement is not │        │                   │
│                   │                   │ correctly          │        │                   │
│                   │                   │ implemented: it    │        │                   │
│                   │                   │ creates a second   │        │                   │
│                   │                   │ google_pubsub_top… │        │                   │
│                   │                   │ with the same name │        │                   │
│                   │                   │ to attach schema   │        │                   │
│                   │                   │ settings instead   │        │                   │
│                   │                   │ of configuring the │        │                   │
│                   │                   │ original topic,    │        │                   │
│                   │                   │ and it uses JSON   │        │                   │
│                   │                   │ encoding rather    │        │                   │
│                   │                   │ than clearly       │        │                   │
│                   │                   │ enforcing Avro on  │        │                   │
│                   │                   │ publish. The Cloud │        │                   │
│                   │                   │ SQL Auth Proxy     │        │                   │
│                   │                   │ requirement is not │        │                   │
│                   │                   │ addressed in the   │        │                   │
│                   │                   │ Cloud Run          │        │                   │
│                   │                   │ container          │        │                   │
│                   │                   │ configuration, and │        │                   │
│                   │                   │ there is no        │        │                   │
│                   │                   │ explicit Cloud SQL │        │                   │
│                   │                   │ instance           │        │                   │
│                   │                   │ connection setup.  │        │                   │
│                   │                   │ Relative to the    │        │                   │
│                   │                   │ GDPR-focused       │        │                   │
│                   │                   │ context, the       │        │                   │
│                   │                   │ schema only        │        │                   │
│                   │                   │ includes limited   │        │                   │
│                   │                   │ fields, which      │        │                   │
│                   │                   │ supports data      │        │                   │
│                   │                   │ minimization, but  │        │                   │
│                   │                   │ there are no       │        │                   │
│                   │                   │ explicit regional  │        │                   │
│                   │                   │ or compliance      │        │                   │
│                   │                   │ controls for       │        │                   │
│                   │                   │ European           │        │                   │
│                   │                   │ processing, and    │        │                   │
│                   │                   │ security/complian… │        │                   │
│                   │                   │ handling is only   │        │                   │
│                   │                   │ partial.,          │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 4.6s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


