import os
import glob
from deepeval import assert_test
from deepeval.test_case import LLMTestCase, LLMTestCaseParams
from deepeval.metrics import GEval

def load_terraform_codebase(directory="terraform"):
    tf_code = ""
    patterns = ["*.tf", "*.tfvars"]
    
    for pattern in patterns:
        for filepath in glob.glob(os.path.join(directory, pattern)):
            with open(filepath, "r", encoding="utf-8") as file:
                tf_code += f"\n# File: {os.path.basename(filepath)}\n"
                tf_code += file.read() + "\n"
                
    return tf_code

def test_contextual_terraform_coherence():
    user_request = "I need to get a website up for my flower shop. It's just a few pages with pictures and contact info. I don't know much about servers, so I just want it to be online and cheap. I heard AWS is good for this."
    
    background_context = [
        "Blooms & Bytes is a floral shop founded in 2015 with 15 employees. The business serves a heavy volume of European expats ordering flowers for families back home. The current simple brochure site collects names, emails, and physical addresses via an unencrypted contact form. Because the company actively processes the personal data of EU residents, the underlying infrastructure must comply with GDPR obligations for secure data transmission and explicit consent mechanisms, which the current request ignores."
    ]
    
    generated_terraform = load_terraform_codebase()

    coherence_metric = GEval(
        name="Contextual Terraform Coherence",
        criteria="Evaluate if the generated Terraform code accurately, securely, and coherently implements the user request while adhering to the business and regulatory requirements implied by the background context.",
        evaluation_steps=[
            "Analyze the user request alongside the provided background context to identify explicit infrastructure needs and implicit compliance or security requirements.",
            "Examine the actual output containing the generated Terraform code to determine if all requested resources are present and correctly configured.",
            "Assess if the Terraform configuration addresses the hidden constraints from the context, such as GDPR compliance, encryption at rest, secure transit, or geographic restrictions.",
            "Penalize the score heavily if the code lacks necessary security measures dictated by the context or if it blindly follows a vague prompt into a non-compliant state.",
            "Reward the score if the infrastructure logic is sound, resource dependencies are correct, and the solution holistically aligns with both the explicit input and the implicit context."
        ],
        evaluation_params=[
            LLMTestCaseParams.INPUT, 
            LLMTestCaseParams.ACTUAL_OUTPUT, 
            LLMTestCaseParams.CONTEXT
        ],
    )

    test_case = LLMTestCase(
        input=user_request,
        actual_output=generated_terraform,
        context=background_context
    )

    assert_test(test_case, [coherence_metric])