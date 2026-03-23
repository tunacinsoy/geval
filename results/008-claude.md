
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.47s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.48s[0m[0m
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
│                   │                   │ components: a      │        │                   │
│                   │                   │ Pub/Sub topic      │        │                   │
│                   │                   │ named              │        │                   │
│                   │                   │ order-events, an   │        │                   │
│                   │                   │ Avro schema        │        │                   │
│                   │                   │ resource, push and │        │                   │
│                   │                   │ pull               │        │                   │
│                   │                   │ subscriptions, a   │        │                   │
│                   │                   │ Cloud Run service  │        │                   │
│                   │                   │ with a dedicated   │        │                   │
│                   │                   │ service account,   │        │                   │
│                   │                   │ and IAM roles for  │        │                   │
│                   │                   │ roles/pubsub.subs… │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ roles/cloudsql.cl… │        │                   │
│                   │                   │ However, it does   │        │                   │
│                   │                   │ not clearly        │        │                   │
│                   │                   │ enforce schema     │        │                   │
│                   │                   │ validation on the  │        │                   │
│                   │                   │ topic beyond       │        │                   │
│                   │                   │ attaching          │        │                   │
│                   │                   │ schema_settings,   │        │                   │
│                   │                   │ and it misses the  │        │                   │
│                   │                   │ requested fixed    │        │                   │
│                   │                   │ Cloud Run scaling  │        │                   │
│                   │                   │ of min 0 and max   │        │                   │
│                   │                   │ 10 by making them  │        │                   │
│                   │                   │ variable/environm… │        │                   │
│                   │                   │ It also does not   │        │                   │
│                   │                   │ actually configure │        │                   │
│                   │                   │ Cloud SQL Auth     │        │                   │
│                   │                   │ Proxy usage in     │        │                   │
│                   │                   │ Cloud Run, despite │        │                   │
│                   │                   │ mentioning Cloud   │        │                   │
│                   │                   │ SQL connection env │        │                   │
│                   │                   │ vars. Against the  │        │                   │
│                   │                   │ GDPR-focused       │        │                   │
│                   │                   │ context, the Avro  │        │                   │
│                   │                   │ schema includes    │        │                   │
│                   │                   │ clear PII fields   │        │                   │
│                   │                   │ like customer_id,  │        │                   │
│                   │                   │ shipping_address,  │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ billing_address,   │        │                   │
│                   │                   │ which conflicts    │        │                   │
│                   │                   │ with the           │        │                   │
│                   │                   │ requirement that   │        │                   │
│                   │                   │ PII be stripped at │        │                   │
│                   │                   │ ingestion for data │        │                   │
│                   │                   │ minimization.      │        │                   │
│                   │                   │ There are also     │        │                   │
│                   │                   │ notable Terraform  │        │                   │
│                   │                   │ correctness        │        │                   │
│                   │                   │ issues, such as    │        │                   │
│                   │                   │ outputs            │        │                   │
│                   │                   │ referencing        │        │                   │
│                   │                   │ nonexistent        │        │                   │
│                   │                   │ modules for        │        │                   │
│                   │                   │ subscriptions and  │        │                   │
│                   │                   │ extra broad        │        │                   │
│                   │                   │ permissions like   │        │                   │
│                   │                   │ roles/editor,      │        │                   │
│                   │                   │ which weaken       │        │                   │
│                   │                   │ alignment and      │        │                   │
│                   │                   │ security posture., │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.0s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


