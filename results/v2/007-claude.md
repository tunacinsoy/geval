
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
5.22s call     test_coherence.py::test_contextual_terraform_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 5.23s[0m[0m
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
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform includes │        │                   │
│                   │                   │ several explicit   │        │                   │
│                   │                   │ requirements: AKS  │        │                   │
│                   │                   │ is configured as a │        │                   │
│                   │                   │ private cluster    │        │                   │
│                   │                   │ with Azure CNI     │        │                   │
│                   │                   │ Overlay,           │        │                   │
│                   │                   │ outbound_type is   │        │                   │
│                   │                   │ userDefinedRoutin… │        │                   │
│                   │                   │ the node pool uses │        │                   │
│                   │                   │ 3 Standard_D4s_v5  │        │                   │
│                   │                   │ nodes across zones │        │                   │
│                   │                   │ 1/2/3, and node    │        │                   │
│                   │                   │ public IPs are     │        │                   │
│                   │                   │ disabled. However, │        │                   │
│                   │                   │ it fails key       │        │                   │
│                   │                   │ security/complian… │        │                   │
│                   │                   │ expectations from  │        │                   │
│                   │                   │ the prompt and     │        │                   │
│                   │                   │ context: the       │        │                   │
│                   │                   │ firewall           │        │                   │
│                   │                   │ application rules  │        │                   │
│                   │                   │ are not limited to │        │                   │
│                   │                   │ only *.docker.io   │        │                   │
│                   │                   │ and *.ubuntu.com   │        │                   │
│                   │                   │ because it also    │        │                   │
│                   │                   │ allows Microsoft,  │        │                   │
│                   │                   │ docker.com, and    │        │                   │
│                   │                   │ canonical.com      │        │                   │
│                   │                   │ domains, weakening │        │                   │
│                   │                   │ the strict egress  │        │                   │
│                   │                   │ control needed for │        │                   │
│                   │                   │ GDPR-oriented      │        │                   │
│                   │                   │ cross-border       │        │                   │
│                   │                   │ exfiltration       │        │                   │
│                   │                   │ prevention. The    │        │                   │
│                   │                   │ design also        │        │                   │
│                   │                   │ creates a private  │        │                   │
│                   │                   │ endpoint for the   │        │                   │
│                   │                   │ AKS control plane  │        │                   │
│                   │                   │ and a              │        │                   │
│                   │                   │ control-plane      │        │                   │
│                   │                   │ subnet, which is   │        │                   │
│                   │                   │ not how AKS        │        │                   │
│                   │                   │ private clusters   │        │                   │
│                   │                   │ are normally       │        │                   │
│                   │                   │ modeled, and it    │        │                   │
│                   │                   │ provisions two     │        │                   │
│                   │                   │ Azure Firewalls in │        │                   │
│                   │                   │ the same           │        │                   │
│                   │                   │ AzureFirewallSubn… │        │                   │
│                   │                   │ which is not a     │        │                   │
│                   │                   │ sound deployment.  │        │                   │
│                   │                   │ There is no clear  │        │                   │
│                   │                   │ geographic         │        │                   │
│                   │                   │ restriction to an  │        │                   │
│                   │                   │ EU region despite  │        │                   │
│                   │                   │ the context about  │        │                   │
│                   │                   │ European civilian  │        │                   │
│                   │                   │ contractor data,   │        │                   │
│                   │                   │ and some extra     │        │                   │
│                   │                   │ resources like an  │        │                   │
│                   │                   │ open Key Vault     │        │                   │
│                   │                   │ network policy are │        │                   │
│                   │                   │ unnecessary and    │        │                   │
│                   │                   │ not aligned with   │        │                   │
│                   │                   │ zero-trust         │        │                   │
│                   │                   │ principles.,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 6.14s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


