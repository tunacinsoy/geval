
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.02s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.02s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Contextual        │ 0.4                │ PASSED │                   │
│                   │ Terraform         │ (threshold=0.1,    │        │                   │
│                   │ Coherence [GEval] │ evaluation         │        │                   │
│                   │                   │ model=gpt-5.4,     │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ the main requested │        │                   │
│                   │                   │ resources: a       │        │                   │
│                   │                   │ Pub/Sub topic      │        │                   │
│                   │                   │ named              │        │                   │
│                   │                   │ order-events, an   │        │                   │
│                   │                   │ Avro schema, push  │        │                   │
│                   │                   │ and pull           │        │                   │
│                   │                   │ subscriptions, a   │        │                   │
│                   │                   │ Cloud Run service  │        │                   │
│                   │                   │ with min 0/max 10, │        │                   │
│                   │                   │ and a dedicated    │        │                   │
│                   │                   │ service account    │        │                   │
│                   │                   │ granted            │        │                   │
│                   │                   │ roles/pubsub.subs… │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ roles/cloudsql.cl… │        │                   │
│                   │                   │ However, it does   │        │                   │
│                   │                   │ not clearly        │        │                   │
│                   │                   │ enforce schema     │        │                   │
│                   │                   │ validation on the  │        │                   │
│                   │                   │ topic/subscriptio… │        │                   │
│                   │                   │ beyond attaching a │        │                   │
│                   │                   │ schema, and the    │        │                   │
│                   │                   │ Cloud Run push     │        │                   │
│                   │                   │ path is likely     │        │                   │
│                   │                   │ misconfigured      │        │                   │
│                   │                   │ because Pub/Sub    │        │                   │
│                   │                   │ push to Cloud Run  │        │                   │
│                   │                   │ typically needs an │        │                   │
│                   │                   │ invoker identity   │        │                   │
│                   │                   │ setup for the      │        │                   │
│                   │                   │ Pub/Sub service    │        │                   │
│                   │                   │ agent, not the     │        │                   │
│                   │                   │ same runtime       │        │                   │
│                   │                   │ service account.   │        │                   │
│                   │                   │ The Cloud SQL Auth │        │                   │
│                   │                   │ Proxy setup is     │        │                   │
│                   │                   │ also incorrect: it │        │                   │
│                   │                   │ mounts a Secret    │        │                   │
│                   │                   │ Manager secret     │        │                   │
│                   │                   │ containing a DB    │        │                   │
│                   │                   │ password as if it  │        │                   │
│                   │                   │ were a service     │        │                   │
│                   │                   │ account credential │        │                   │
│                   │                   │ file, which would  │        │                   │
│                   │                   │ not work. From the │        │                   │
│                   │                   │ GDPR/security      │        │                   │
│                   │                   │ context about      │        │                   │
│                   │                   │ European branches  │        │                   │
│                   │                   │ and data           │        │                   │
│                   │                   │ minimization,      │        │                   │
│                   │                   │ there is no        │        │                   │
│                   │                   │ geographic         │        │                   │
│                   │                   │ restriction to EU  │        │                   │
│                   │                   │ regions and no     │        │                   │
│                   │                   │ explicit handling  │        │                   │
│                   │                   │ to ensure PII      │        │                   │
│                   │                   │ stripping before   │        │                   │
│                   │                   │ ingestion. There   │        │                   │
│                   │                   │ are some security  │        │                   │
│                   │                   │ positives like     │        │                   │
│                   │                   │ private Cloud SQL, │        │                   │
│                   │                   │ no public IP, and  │        │                   │
│                   │                   │ OIDC on push       │        │                   │
│                   │                   │ delivery, but the  │        │                   │
│                   │                   │ solution is not    │        │                   │
│                   │                   │ holistically       │        │                   │
│                   │                   │ compliant or fully │        │                   │
│                   │                   │ functional.,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 5.55s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


