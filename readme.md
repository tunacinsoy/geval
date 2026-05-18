```bash
export OPENAI_API_KEY="your-openai-api-key"

# Create venv
python -m venv venv

# Activate venv
source venv/bin/activate

# Install the dependencies that is listed in requirements file
pip install -r requirements.txt

deepeval test run test_coherence_v2.py > <SCENARIO>-<LLM_MODEL>.md
```