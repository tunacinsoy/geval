import os
import glob
import re
from deepeval import assert_test
from deepeval.test_case import LLMTestCase
from deepeval.metrics import BaseMetric
from deepeval.models import GPTModel

def load_terraform_codebase(directory="iac/003-claude-opus46"):
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
    def __init__(self, threshold: float = 0.1):
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
    user_request = "My team needs a playground to test a new feature for a couple of weeks. It doesn't need to be powerful, just something they can mess around with and then we can throw it away when they're done."

    background_context = [
        "EduSpark UK is an EdTech startup founded in 2021 with 30 employees. The company is testing an AI feature using a direct snapshot of the production database. This database contains learning disabilities profiles and personal identifying information of European students. Under GDPR, using real, unanonymized personal data of minors for non-production testing environments is a severe violation, requiring infrastructure that enforces dynamic data masking or synthetic data generation."
    ]

    generated_terraform = load_terraform_codebase()

    test_case = LLMTestCase(
        input=user_request,
        actual_output=generated_terraform,
        context=background_context
    )

    contextual_metric = PreciseContextualCoherenceMetric(threshold=0.2)

    assert_test(test_case, [contextual_metric])