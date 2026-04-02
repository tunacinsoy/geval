import os
import glob
from deepeval import assert_test
from deepeval.test_case import LLMTestCase, LLMTestCaseParams
from deepeval.metrics import AnswerRelevancyMetric, GEval


def load_terraform_codebase(directory="iac/004-claude"):
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
    user_request = "We have a list of customer emails and orders that is getting too big for Excel. I need a proper database to put it in so the website can talk to it. It needs to be reliable so we don't lose any orders."

    background_context = [
        "Coastal Threads is a clothing brand founded in 2020 with 60 employees. The company is moving thousands of customer records from spreadsheets to a database. A significant portion of these records belong to European customers who opted into marketing newsletters. The company currently lacks any infrastructure to support GDPR's Right to be Forgotten or data portability, making a simple database migration a major compliance risk without built-in automated deletion workflows."
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
