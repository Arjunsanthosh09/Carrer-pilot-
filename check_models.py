from groq import Groq
from config import Config

client = Groq(api_key=Config.GROQ_API_KEY)

print("✅ Available models:")
models = client.models.list()

# Check if it's a tuple or list
if isinstance(models, tuple):
    for model in models:
        print(f"  - {model.id}")
else:
    # If it's an object with 'data' attribute
    for model in models.data:
        print(f"  - {model.id}")