resource "aws_bedrock_guardrail" "email_router_guardrail" {
  name                      = "email-router-guardrail"
  blocked_input_messaging   = "This email contains content that cannot be processed."
  blocked_outputs_messaging = "This email contains content that cannot be processed."
  description               = "Guardrail for the AI email router workflow."

  content_policy_config {
    filters_config {
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
      type            = "HATE"
    }
    filters_config {
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
      type            = "INSULTS"
    }
    tier_config {
      tier_name = "CLASSIC"
    }
  }
}

resource "aws_bedrock_guardrail_version" "email_router_guardrail_version" {
  description   = "Version 1 of the email router guardrail"
  guardrail_arn = aws_bedrock_guardrail.email_router_guardrail.guardrail_arn
  skip_destroy  = true
}