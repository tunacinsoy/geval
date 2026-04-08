    🎯 Evaluating test case #0                                                   0% 0:00:09
[32m.[0mRunning teardown with pytest sessionfinish...

============================= slowest 10 durations =============================
9.30s call     test_coherence_v2.py::test_contextual_coherence

(2 durations < 0.005s hidden.  Use -vv to show these durations.)
[33m[32m1 passed[0m, [33m[1m4 warnings[0m[33m in 9.31s[0m[0m
                                       Test Results                                        
┏━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓
┃                   ┃                   ┃                    ┃        ┃ Overall Success   ┃
┃ Test case         ┃ Metric            ┃ Score              ┃ Status ┃ Rate              ┃
┡━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━╇━━━━━━━━━━━━━━━━━━━┩
│ test_contextual_… │                   │                    │        │ 100.0%            │
│                   │ Precise           │ 0.41               │ PASSED │                   │
│                   │ Contextual        │ (threshold=0.2,    │        │                   │
│                   │ Coherence Metric  │ evaluation         │        │                   │
│                   │                   │ model=n/a,         │        │                   │
│                   │                   │ reason=The         │        │                   │
│                   │                   │ Terraform only     │        │                   │
│                   │                   │ partially          │        │                   │
│                   │                   │ satisfies the      │        │                   │
│                   │                   │ explicit request   │        │                   │
│                   │                   │ and does so with   │        │                   │
│                   │                   │ major correctness  │        │                   │
│                   │                   │ issues.            │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ It does include an │        │                   │
│                   │                   │ EC2 Image Builder  │        │                   │
│                   │                   │ pipeline, uses     │        │                   │
│                   │                   │ Amazon Linux 2023  │        │                   │
│                   │                   │ as the parent      │        │                   │
│                   │                   │ image, attempts to │        │                   │
│                   │                   │ add a CIS          │        │                   │
│                   │                   │ hardening          │        │                   │
│                   │                   │ component, and     │        │                   │
│                   │                   │ wires a launch     │        │                   │
│                   │                   │ template to a      │        │                   │
│                   │                   │ dynamically        │        │                   │
│                   │                   │ discovered AMI. It │        │                   │
│                   │                   │ also includes an   │        │                   │
│                   │                   │ ASG with instance  │        │                   │
│                   │                   │ refresh and some   │        │                   │
│                   │                   │ HA-oriented        │        │                   │
│                   │                   │ infrastructure     │        │                   │
│                   │                   │ like multi-AZ      │        │                   │
│                   │                   │ subnets, NAT       │        │                   │
│                   │                   │ gateways, and an   │        │                   │
│                   │                   │ optional ALB.      │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ However, the       │        │                   │
│                   │                   │ implementation is  │        │                   │
│                   │                   │ not coherent or    │        │                   │
│                   │                   │ reliable enough to │        │                   │
│                   │                   │ be considered      │        │                   │
│                   │                   │ accurate. The      │        │                   │
│                   │                   │ biggest problem is │        │                   │
│                   │                   │ that the Image     │        │                   │
│                   │                   │ Builder component  │        │                   │
│                   │                   │ is incorrectly     │        │                   │
│                   │                   │ defined:           │        │                   │
│                   │                   │ `aws_imagebuilder… │        │                   │
│                   │                   │ must be an Image   │        │                   │
│                   │                   │ Builder component  │        │                   │
│                   │                   │ document, not a    │        │                   │
│                   │                   │ raw Ansible        │        │                   │
│                   │                   │ playbook file. So  │        │                   │
│                   │                   │ the requested      │        │                   │
│                   │                   │ “execute an        │        │                   │
│                   │                   │ Ansible playbook   │        │                   │
│                   │                   │ component” is not  │        │                   │
│                   │                   │ actually           │        │                   │
│                   │                   │ implemented        │        │                   │
│                   │                   │ correctly. The AMI │        │                   │
│                   │                   │ reference is also  │        │                   │
│                   │                   │ only loosely       │        │                   │
│                   │                   │ dynamic via `data  │        │                   │
│                   │                   │ "aws_ami"` name    │        │                   │
│                   │                   │ filtering rather   │        │                   │
│                   │                   │ than being         │        │                   │
│                   │                   │ robustly tied to   │        │                   │
│                   │                   │ the pipeline       │        │                   │
│                   │                   │ output lifecycle.  │        │                   │
│                   │                   │ The ASG instance   │        │                   │
│                   │                   │ refresh is not     │        │                   │
│                   │                   │ truly “strict” in  │        │                   │
│                   │                   │ the sense          │        │                   │
│                   │                   │ requested; while   │        │                   │
│                   │                   │ it uses rolling    │        │                   │
│                   │                   │ refresh and        │        │                   │
│                   │                   │ healthy percentage │        │                   │
│                   │                   │ controls, it does  │        │                   │
│                   │                   │ not clearly        │        │                   │
│                   │                   │ enforce            │        │                   │
│                   │                   │ launch-before-ter… │        │                   │
│                   │                   │ semantics as       │        │                   │
│                   │                   │ strongly as        │        │                   │
│                   │                   │ possible, and some │        │                   │
│                   │                   │ of the block       │        │                   │
│                   │                   │ syntax appears     │        │                   │
│                   │                   │ invalid for        │        │                   │
│                   │                   │ Terraform/AWS      │        │                   │
│                   │                   │ provider usage.    │        │                   │
│                   │                   │ There are also     │        │                   │
│                   │                   │ multiple           │        │                   │
│                   │                   │ Terraform/schema   │        │                   │
│                   │                   │ issues that would  │        │                   │
│                   │                   │ likely prevent     │        │                   │
│                   │                   │ apply, such as     │        │                   │
│                   │                   │ invalid dynamic    │        │                   │
│                   │                   │ use of             │        │                   │
│                   │                   │ `target_group_arn… │        │                   │
│                   │                   │ suspicious         │        │                   │
│                   │                   │ `trigger` syntax   │        │                   │
│                   │                   │ in                 │        │                   │
│                   │                   │ `instance_refresh… │        │                   │
│                   │                   │ invalid cron       │        │                   │
│                   │                   │ formatting for AWS │        │                   │
│                   │                   │ in variables, and  │        │                   │
│                   │                   │ a stray            │        │                   │
│                   │                   │ `terraform.tfvars` │        │                   │
│                   │                   │ containing         │        │                   │
│                   │                   │ unrelated GCP      │        │                   │
│                   │                   │ settings.          │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Against the hidden │        │                   │
│                   │                   │ company context,   │        │                   │
│                   │                   │ the code shows     │        │                   │
│                   │                   │ some awareness of  │        │                   │
│                   │                   │ immutable          │        │                   │
│                   │                   │ infrastructure and │        │                   │
│                   │                   │ auditability       │        │                   │
│                   │                   │ through image      │        │                   │
│                   │                   │ pipelines,         │        │                   │
│                   │                   │ logging, versioned │        │                   │
│                   │                   │ S3 buckets, and    │        │                   │
│                   │                   │ instance           │        │                   │
│                   │                   │ replacement        │        │                   │
│                   │                   │ patterns. That     │        │                   │
│                   │                   │ said, it does not  │        │                   │
│                   │                   │ strongly           │        │                   │
│                   │                   │ operationalize the │        │                   │
│                   │                   │ compliance-driven  │        │                   │
│                   │                   │ needs. There is no │        │                   │
│                   │                   │ concrete immutable │        │                   │
│                   │                   │ deployment         │        │                   │
│                   │                   │ enforcement beyond │        │                   │
│                   │                   │ normal ASG refresh │        │                   │
│                   │                   │ behavior, no       │        │                   │
│                   │                   │ regulator-focused  │        │                   │
│                   │                   │ audit trail design │        │                   │
│                   │                   │ beyond generic     │        │                   │
│                   │                   │ logs, no explicit  │        │                   │
│                   │                   │ GDPR-oriented      │        │                   │
│                   │                   │ controls beyond a  │        │                   │
│                   │                   │ comment, and no    │        │                   │
│                   │                   │ strict             │        │                   │
│                   │                   │ egress/firewall    │        │                   │
│                   │                   │ whitelisting such  │        │                   │
│                   │                   │ as                 │        │                   │
│                   │                   │ docker.io/ubuntu.… │        │                   │
│                   │                   │ Security posture   │        │                   │
│                   │                   │ is mixed: SSH is   │        │                   │
│                   │                   │ open to            │        │                   │
│                   │                   │ `0.0.0.0/0` by     │        │                   │
│                   │                   │ default,           │        │                   │
│                   │                   │ self-signed certs  │        │                   │
│                   │                   │ are used for       │        │                   │
│                   │                   │ HTTPS, and several │        │                   │
│                   │                   │ IAM policies are   │        │                   │
│                   │                   │ broad. So it does  │        │                   │
│                   │                   │ not successfully   │        │                   │
│                   │                   │ anticipate the     │        │                   │
│                   │                   │ deeper security    │        │                   │
│                   │                   │ and compliance     │        │                   │
│                   │                   │ constraints.       │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ Overall: good      │        │                   │
│                   │                   │ intent, some HA    │        │                   │
│                   │                   │ scaffolding, but   │        │                   │
│                   │                   │ materially flawed  │        │                   │
│                   │                   │ implementation and │        │                   │
│                   │                   │ weak alignment     │        │                   │
│                   │                   │ with the hidden    │        │                   │
│                   │                   │ compliance/securi… │        │                   │
│                   │                   │ context.           │        │                   │
│                   │                   │                    │        │                   │
│                   │                   │ SCORE: 0.41,       │        │                   │
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


✓ Evaluation completed 🎉! (time taken: 9.81s | token cost: None)
» Test Results (1 total tests):
   » Pass Rate: 100.0% | Passed: 1 | Failed: 0

 ================================================================================ 

» Want to share evals with your team, or a place for your test cases to live? ❤️ 🏡
  » Run 'deepeval view' to analyze and save testing results on Confident AI.


