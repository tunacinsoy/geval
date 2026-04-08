    🎯 Evaluating test case #0                                                   0% 0:00:07
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
7.63s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 7.64s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.46               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform only     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ and does a weak    │        │                   │
│                   │                   │ job of aligning    │        │                   │
│                   │                   │ with the hidden    │        │                   │
│                   │                   │ GDPR/security      │        │                   │
│                   │                   │ context.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Positives: it does │        │                   │
│                   │                   │ create a Pub/Sub   │        │                   │
│                   │                   │ topic named        │        │                   │
│                   │                   │ `order-events`,    │        │                   │
│                   │                   │ defines an Avro    │        │                   │
│                   │                   │ schema, attaches   │        │                   │
│                   │                   │ schema settings to │        │                   │
│                   │                   │ the topic, creates │        │                   │
│                   │                   │ both a push and a  │        │                   │
│                   │                   │ pull subscription, │        │                   │
│                   │                   │ deploys a Cloud    │        │                   │
│                   │                   │ Run service with a │        │                   │
│                   │                   │ dedicated service  │        │                   │
│                   │                   │ account, and       │        │                   │
│                   │                   │ grants             │        │                   │
│                   │                   │ `roles/pubsub.sub… │        │                   │
│                   │                   │ plus               │        │                   │
│                   │                   │ `roles/cloudsql.c… │        │                   │
│                   │                   │ It also targets a  │        │                   │
│                   │                   │ specific region    │        │                   │
│                   │                   │ and includes some  │        │                   │
│                   │                   │ HA-related knobs   │        │                   │
│                   │                   │ for Cloud SQL.     │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, there are │        │                   │
│                   │                   │ major correctness  │        │                   │
│                   │                   │ and coherence      │        │                   │
│                   │                   │ issues. The        │        │                   │
│                   │                   │ request requires   │        │                   │
│                   │                   │ schema validation  │        │                   │
│                   │                   │ enforcement; the   │        │                   │
│                   │                   │ code creates a     │        │                   │
│                   │                   │ schema and topic   │        │                   │
│                   │                   │ schema settings,   │        │                   │
│                   │                   │ but does not       │        │                   │
│                   │                   │ clearly ensure     │        │                   │
│                   │                   │ enforcement        │        │                   │
│                   │                   │ semantics beyond   │        │                   │
│                   │                   │ standard Pub/Sub   │        │                   │
│                   │                   │ schema attachment. │        │                   │
│                   │                   │ More importantly,  │        │                   │
│                   │                   │ the Cloud Run      │        │                   │
│                   │                   │ scaling            │        │                   │
│                   │                   │ requirement is     │        │                   │
│                   │                   │ explicitly `min 0, │        │                   │
│                   │                   │ max 10`, but the   │        │                   │
│                   │                   │ implementation     │        │                   │
│                   │                   │ makes this         │        │                   │
│                   │                   │ environment-depen… │        │                   │
│                   │                   │ and even sets prod │        │                   │
│                   │                   │ min to 1. The      │        │                   │
│                   │                   │ Cloud Run push     │        │                   │
│                   │                   │ subscription is    │        │                   │
│                   │                   │ also               │        │                   │
│                   │                   │ misconfigured:     │        │                   │
│                   │                   │ Pub/Sub push to    │        │                   │
│                   │                   │ Cloud Run should   │        │                   │
│                   │                   │ generally use a    │        │                   │
│                   │                   │ dedicated invoker  │        │                   │
│                   │                   │ identity, not the  │        │                   │
│                   │                   │ runtime service    │        │                   │
│                   │                   │ account as the     │        │                   │
│                   │                   │ OIDC token issuer. │        │                   │
│                   │                   │ The code claims    │        │                   │
│                   │                   │ Cloud SQL Auth     │        │                   │
│                   │                   │ Proxy usage, but   │        │                   │
│                   │                   │ does not actually  │        │                   │
│                   │                   │ configure Cloud    │        │                   │
│                   │                   │ Run with the Cloud │        │                   │
│                   │                   │ SQL connection     │        │                   │
│                   │                   │ annotation or a    │        │                   │
│                   │                   │ sidecar/proxy      │        │                   │
│                   │                   │ pattern; instead   │        │                   │
│                   │                   │ it only passes the │        │                   │
│                   │                   │ instance           │        │                   │
│                   │                   │ connection name as │        │                   │
│                   │                   │ an env var. There  │        │                   │
│                   │                   │ are also broken    │        │                   │
│                   │                   │ references         │        │                   │
│                   │                   │ (`module.pubsub_p… │        │                   │
│                   │                   │ `module.pubsub_pu… │        │                   │
│                   │                   │ and likely invalid │        │                   │
│                   │                   │ logging sink       │        │                   │
│                   │                   │ destinations,      │        │                   │
│                   │                   │ reducing           │        │                   │
│                   │                   │ deployability.     │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Against the hidden │        │                   │
│                   │                   │ context, the code  │        │                   │
│                   │                   │ does not           │        │                   │
│                   │                   │ meaningfully       │        │                   │
│                   │                   │ implement data     │        │                   │
│                   │                   │ minimization or    │        │                   │
│                   │                   │ PII stripping at   │        │                   │
│                   │                   │ ingestion. In      │        │                   │
│                   │                   │ fact, the Avro     │        │                   │
│                   │                   │ schema includes    │        │                   │
│                   │                   │ `customer_id`,     │        │                   │
│                   │                   │ shipping address,  │        │                   │
│                   │                   │ and billing        │        │                   │
│                   │                   │ address, which     │        │                   │
│                   │                   │ conflicts with the │        │                   │
│                   │                   │ stated             │        │                   │
│                   │                   │ GDPR-oriented      │        │                   │
│                   │                   │ minimization goal. │        │                   │
│                   │                   │ Service accounts   │        │                   │
│                   │                   │ are somewhat       │        │                   │
│                   │                   │ scoped, but there  │        │                   │
│                   │                   │ is also            │        │                   │
│                   │                   │ overprivileging    │        │                   │
│                   │                   │ (`roles/editor`    │        │                   │
│                   │                   │ for Terraform SA,  │        │                   │
│                   │                   │ extra              │        │                   │
│                   │                   │ logging/monitoring │        │                   │
│                   │                   │ roles, secret      │        │                   │
│                   │                   │ accessor at        │        │                   │
│                   │                   │ project level). No │        │                   │
│                   │                   │ strict firewall    │        │                   │
│                   │                   │ whitelists such as │        │                   │
│                   │                   │ `docker.io` and    │        │                   │
│                   │                   │ `ubuntu.com` are   │        │                   │
│                   │                   │ present. High      │        │                   │
│                   │                   │ availability is    │        │                   │
│                   │                   │ only partially     │        │                   │
│                   │                   │ anticipated via    │        │                   │
│                   │                   │ optional Cloud SQL │        │                   │
│                   │                   │ HA, not            │        │                   │
│                   │                   │ consistently       │        │                   │
│                   │                   │ enforced. Overall, │        │                   │
│                   │                   │ it overbuilds in   │        │                   │
│                   │                   │ some areas,        │        │                   │
│                   │                   │ underdelivers on   │        │                   │
│                   │                   │ the core request   │        │                   │
│                   │                   │ in others, and     │        │                   │
│                   │                   │ misses the hidden  │        │                   │
│                   │                   │ compliance intent. │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.46,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 8.11s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


