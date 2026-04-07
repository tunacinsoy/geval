import os
import glob
import re
from deepeval import assert_test
from deepeval.test_case import LLMTestCase
from deepeval.metrics import BaseMetric
from deepeval.models import GPTModel

def load_terraform_codebase(directory="iac/007-claude"):
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

class PreciseContextualCoherenceMetric(BaseMetric):
    def __init__(self, threshold: float = 0.2):
        self.threshold = threshold
        self.model = GPTModel(model="gpt-5.4")

        # Explicitly initialize required base attributes to prevent NoneType errors
        self.success = False
        self.score = 0.0
        self.reason = None
        self.error = None
        self.strict_mode = False
        #self.evaluation_model = "gpt-5.4"
        self.evaluation_cost = 0
        self.verbose_logs = ""

    def measure(self, test_case: LLMTestCase) -> float:
        prompt = f"""
        Evaluate the following Infrastructure as Code (Terraform) generation task.

        Explicit User Request: {test_case.input}
        Hidden Company Context: {test_case.context}
        Generated Terraform Code: {test_case.actual_output}

        Evaluate how accurately and coherently the Terraform code implements the explicit user request while successfully anticipating and resolving the implicit architectural constraints defined in the hidden company context.
        Reward the score if the generated code includes high availability configurations, specific region targeting, and strict firewall whitelists (like docker.io and ubuntu.com) as implied by the context.
        Penalize the score if the code only addresses the explicit request and ignores the security or redundancy needs of the business context.

        First, provide a brief reasoning for your evaluation.
        Then, on a new line at the very end of your response, provide a precise granular score between 0.00 and 1.00 using the exact format: 'SCORE: 0.XX'.
        """

        try:
            res = self.model.generate(prompt)

            # FIX: Extract the text if DeepEval returns a (response, cost) tuple
            if isinstance(res, tuple):
                res = res[0]

            self.reason = res

            match = re.search(r"SCORE:\s*(0\.\d+|1\.0+)", res)
            self.score = float(match.group(1)) if match else 0.0

            # Cast strictly to boolean
            self.success = bool(self.score >= self.threshold)
        except Exception as e:
            self.error = str(e)
            self.success = False
            self.score = 0.0

        return self.score

    # Add async execution support for assert_test
    async def a_measure(self, test_case: LLMTestCase) -> float:
        return self.measure(test_case)

    def is_successful(self) -> bool:
        return bool(self.success)

    @property
    def __name__(self):
        return "Precise Contextual Coherence Metric"

def test_contextual_coherence():
    user_request = "Deploy a private Azure Kubernetes Service cluster (v1.28+) with Azure CNI Overlay networking. The cluster must not have a public IP. All egress traffic must be routed through an Azure Firewall using a user-defined route (UDR) on the node subnet. Configure the firewall with application rules to allow traffic only to *.docker.io and *.ubuntu.com. The node pool should consist of 3 Standard_D4s_v5 instances, distributed across availability zones 1, 2, and 3."

    background_context = [
        "Aegis Defense Tech, founded in 2005 with 850 employees, is a defense contractor whose containerized workloads process data of European civilian contractors. The zero-trust network isolation explicitly satisfies GDPR's requirement for data protection by design and by default. The strict egress control prevents any possibility of unauthorized cross-border data exfiltration from the containerized workloads."
    ]

    generated_terraform = load_terraform_codebase()

    test_case = LLMTestCase(
        input=user_request,
        actual_output=generated_terraform,
        context=background_context
    )

    contextual_metric = PreciseContextualCoherenceMetric(threshold=0.2)

    assert_test(test_case, [contextual_metric])