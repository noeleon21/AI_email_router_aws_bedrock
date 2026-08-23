locals {
  model_id = "global.amazon.nova-2-lite-v1:0"

  email_prompt_definitions = {
    classifier = {
      name        = "companyemailclassifier"
      description = "Classifies customer emails into complaint, question, or refund."
      text        = "You are an email classifier. Read the following customer email and classify it as exactly one of: complaint, question, or refund. Respond with only the classification label in lowercase, nothing else. Customer email: {{email}}"
    }
    general = {
      name        = "companygeneralprompt"
      description = "Generates professional responses to general customer emails."
      text        = "You are a helpful customer service agent. Read the following customer email and write a brief, professional response (3-4 sentences). Customer email: {{email}}"
    }
    complaint = {
      name        = "companycomplaintprompt"
      description = "Generates empathetic responses to customer complaints."
      text        = "You are a customer service agent. Read the following customer complaint and write a brief, empathetic response (3-4 sentences) that acknowledges the issue and offers a resolution. Customer email: {{email}}"
    }
  }

  prompt_arns = [
    for prompt in aws_bedrockagent_prompt.email_prompts : prompt.arn
  ]

  model_arns = [
    "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:inference-profile/global.amazon.nova-2-lite-v1:0",
    "arn:aws:bedrock:${data.aws_region.current.region}::foundation-model/amazon.nova-2-lite-v1:0",
    "arn:aws:bedrock:::foundation-model/amazon.nova-2-lite-v1:0"
  ]
}
