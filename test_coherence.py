import os
import glob
from deepeval import assert_test
from deepeval.test_case import LLMTestCase, LLMTestCaseParams
from deepeval.metrics import AnswerRelevancyMetric, GEval


def load_terraform_codebase(directory="iac/007-codex"):
    tf_code = ""
    patterns = ["**/*.tf", "**/*.tfvars"]

    for pattern in patterns:
        search_path = os.path.join(directory, pattern)
        for filepath in glob.glob(search_path, recursive=True):
            if os.path.isfile(filepath):
                with open(filepath, "r", encoding="utf-8") as file:
                    tf_code += f"\n# File: {os.path.basename(filepath)}\n"
                    tf_code += file.read() + "\n"

    return tf_code


def test_contextual_terraform_coherence():
    user_request = "Deploy a private Azure Kubernetes Service cluster (v1.28+) with Azure CNI Overlay networking. The cluster must not have a public IP. All egress traffic must be routed through an Azure Firewall using a user-defined route (UDR) on the node subnet. Configure the firewall with application rules to allow traffic only to *.docker.io and *.ubuntu.com. The node pool should consist of 3 Standard_D4s_v5 instances, distributed across availability zones 1, 2, and 3."

    background_context = [
        "Aegis Defense Tech, founded in 2005 with 850 employees, is a defense contractor whose containerized workloads process data of European civilian contractors. The zero-trust network isolation explicitly satisfies GDPR's requirement for data protection by design and by default. The strict egress control prevents any possibility of unauthorized cross-border data exfiltration from the containerized workloads."

    ]

    generated_terraform = load_terraform_codebase()

    coherence_metric = GEval(
        name="Contextual Terraform Coherence",
        model="gpt-5.4",
        threshold=0.1,
        criteria="Evaluate if the generated Terraform code accurately, securely, and coherently implements the user request while adhering to the business and regulatory requirements implied by the background context.",
        evaluation_steps=[
            "Analyze the user request alongside the provided background context to identify explicit infrastructure needs and implicit compliance or security requirements.",
            "Examine the actual output containing the generated Terraform code to determine if all requested resources are present and correctly configured.",
            "Assess if the Terraform configuration addresses the hidden constraints from the context, such as GDPR compliance, encryption at rest, secure transit, or geographic restrictions.",
            "Penalize the score if the code lacks necessary security measures dictated by the context or if it blindly follows a vague prompt into a non-compliant state.",
            "Reward the score if the infrastructure logic is sound, resource dependencies are correct, and the solution holistically aligns with both the explicit input and the implicit context.",
            # 1"Rate the overall coherence on a strict scale of 0 to 100, and multiply the coherence score by 10 for normalization purposes. You must output a highly granular number. "
            # "CRITICAL INSTRUCTION: Calculate your final coherence score on a standard 0.0 to 1.0 scale, then explicitly multiply that exact number by 100. You must output this multiplied value as your final numeric score (for example, if your internal score is 0.31, you must output 3.1)."
        ],
        evaluation_params=[
            LLMTestCaseParams.INPUT,
            LLMTestCaseParams.ACTUAL_OUTPUT,
            LLMTestCaseParams.CONTEXT,
        ],
    )

    test_case = LLMTestCase(
        input=user_request,
        actual_output=generated_terraform,
        context=background_context,
    )

    assert_test(test_case, [coherence_metric])
