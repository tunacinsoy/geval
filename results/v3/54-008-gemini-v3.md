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
│                   │                   │ important          │        │                   │
│                   │                   │ correctness and    │        │                   │
│                   │                   │ architectural      │        │                   │
│                   │                   │ gaps. Positively,  │        │                   │
│                   │                   │ it creates a       │        │                   │
│                   │                   │ Pub/Sub topic      │        │                   │
│                   │                   │ named              │        │                   │
│                   │                   │ `order-events`,    │        │                   │
│                   │                   │ defines an Avro    │        │                   │
│                   │                   │ schema, creates    │        │                   │
│                   │                   │ both a push and    │        │                   │
│                   │                   │ pull subscription, │        │                   │
│                   │                   │ deploys a Cloud    │        │                   │
│                   │                   │ Run service with   │        │                   │
│                   │                   │ min/max scaling    │        │                   │
│                   │                   │ set to 0/10, and   │        │                   │
│                   │                   │ provisions a       │        │                   │
│                   │                   │ dedicated service  │        │                   │
│                   │                   │ account with       │        │                   │
│                   │                   │ `roles/pubsub.sub… │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ `roles/cloudsql.c… │        │                   │
│                   │                   │ However, the       │        │                   │
│                   │                   │ schema attachment  │        │                   │
│                   │                   │ is implemented     │        │                   │
│                   │                   │ incorrectly by     │        │                   │
│                   │                   │ creating a second  │        │                   │
│                   │                   │ `google_pubsub_to… │        │                   │
│                   │                   │ resource with the  │        │                   │
│                   │                   │ same name instead  │        │                   │
│                   │                   │ of attaching       │        │                   │
│                   │                   │ `schema_settings`  │        │                   │
│                   │                   │ to the original    │        │                   │
│                   │                   │ topic resource,    │        │                   │
│                   │                   │ which would fail.  │        │                   │
│                   │                   │ It also sets       │        │                   │
│                   │                   │ schema encoding to │        │                   │
│                   │                   │ `JSON` despite the │        │                   │
│                   │                   │ request            │        │                   │
│                   │                   │ emphasizing Avro   │        │                   │
│                   │                   │ validation; while  │        │                   │
│                   │                   │ Pub/Sub supports   │        │                   │
│                   │                   │ Avro schema with   │        │                   │
│                   │                   │ JSON encoding,     │        │                   │
│                   │                   │ this is not the    │        │                   │
│                   │                   │ clearest           │        │                   │
│                   │                   │ implementation of  │        │                   │
│                   │                   │ “using Avro” and   │        │                   │
│                   │                   │ weakens fidelity.  │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ More critically,   │        │                   │
│                   │                   │ the Cloud SQL Auth │        │                   │
│                   │                   │ Proxy requirement  │        │                   │
│                   │                   │ is not actually    │        │                   │
│                   │                   │ implemented. The   │        │                   │
│                   │                   │ Cloud Run service  │        │                   │
│                   │                   │ lacks a            │        │                   │
│                   │                   │ `volumes`/Cloud    │        │                   │
│                   │                   │ SQL instance mount │        │                   │
│                   │                   │ or                 │        │                   │
│                   │                   │ `run.googleapis.c… │        │                   │
│                   │                   │ equivalent         │        │                   │
│                   │                   │ configuration, and │        │                   │
│                   │                   │ no Cloud SQL       │        │                   │
│                   │                   │ instance variable  │        │                   │
│                   │                   │ or connection      │        │                   │
│                   │                   │ binding is         │        │                   │
│                   │                   │ present. The push  │        │                   │
│                   │                   │ subscription       │        │                   │
│                   │                   │ authentication is  │        │                   │
│                   │                   │ also questionable: │        │                   │
│                   │                   │ Pub/Sub push OIDC  │        │                   │
│                   │                   │ should generally   │        │                   │
│                   │                   │ use a dedicated    │        │                   │
│                   │                   │ invoker service    │        │                   │
│                   │                   │ account with       │        │                   │
│                   │                   │ `iam.serviceAccou… │        │                   │
│                   │                   │ as needed, while   │        │                   │
│                   │                   │ the code reuses    │        │                   │
│                   │                   │ the runtime        │        │                   │
│                   │                   │ service account.   │        │                   │
│                   │                   │ There is also a    │        │                   │
│                   │                   │ resource type      │        │                   │
│                   │                   │ mismatch risk:     │        │                   │
│                   │                   │ `google_cloud_run… │        │                   │
│                   │                   │ is for v1-style    │        │                   │
│                   │                   │ Cloud Run, while   │        │                   │
│                   │                   │ the service        │        │                   │
│                   │                   │ resource is        │        │                   │
│                   │                   │ `google_cloud_run… │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Against the hidden │        │                   │
│                   │                   │ context, the code  │        │                   │
│                   │                   │ does little to     │        │                   │
│                   │                   │ reflect GDPR/data  │        │                   │
│                   │                   │ minimization       │        │                   │
│                   │                   │ concerns beyond    │        │                   │
│                   │                   │ schema enforcement │        │                   │
│                   │                   │ and scoped IAM. It │        │                   │
│                   │                   │ does not model     │        │                   │
│                   │                   │ stricter           │        │                   │
│                   │                   │ ingestion-layer    │        │                   │
│                   │                   │ controls, data     │        │                   │
│                   │                   │ sanitization       │        │                   │
│                   │                   │ boundaries,        │        │                   │
│                   │                   │ regional           │        │                   │
│                   │                   │ sensitivity for    │        │                   │
│                   │                   │ European           │        │                   │
│                   │                   │ operations, or     │        │                   │
│                   │                   │ stronger security  │        │                   │
│                   │                   │ hardening. There   │        │                   │
│                   │                   │ is no              │        │                   │
│                   │                   │ high-availability  │        │                   │
│                   │                   │ or redundancy      │        │                   │
│                   │                   │ design beyond      │        │                   │
│                   │                   │ basic              │        │                   │
│                   │                   │ managed-service    │        │                   │
│                   │                   │ defaults, no       │        │                   │
│                   │                   │ explicit region    │        │                   │
│                   │                   │ choice aligned to  │        │                   │
│                   │                   │ Europe, and no     │        │                   │
│                   │                   │ firewall/egress    │        │                   │
│                   │                   │ whitelist controls │        │                   │
│                   │                   │ such as docker.io  │        │                   │
│                   │                   │ or ubuntu.com.     │        │                   │
│                   │                   │ Monitoring was     │        │                   │
│                   │                   │ added, which is    │        │                   │
│                   │                   │ useful, but it     │        │                   │
│                   │                   │ does not           │        │                   │
│                   │                   │ compensate for the │        │                   │
│                   │                   │ missing security   │        │                   │
│                   │                   │ and                │        │                   │
│                   │                   │ compliance-orient… │        │                   │
│                   │                   │ architectural      │        │                   │
│                   │                   │ adaptations        │        │                   │
│                   │                   │ implied by the     │        │                   │
│                   │                   │ company context.   │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 11.43s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


