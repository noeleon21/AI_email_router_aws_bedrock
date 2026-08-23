resource "aws_bedrockagent_prompt" "companyemailclassifier" {
  name            = "companyemailclassifier"
  description     = "Classifies customer emails into different categories"
  default_variant = "Variant1"

  variant {
    name     = "Variant1"
    model_id = "global.amazon.nova-2-lite-v1:0"

    inference_configuration {
      text {
        temperature = 0.8
      }
    }

    template_type = "TEXT"
    template_configuration {
      text {
        text = "You are an email classifier. Read the following customer email and classify it as exactly one of: complaint, question, or refund. Respond with only the classification label in lowercase, nothing else. Customer email: {{email}}"

        input_variable {
          name = "email"
        }
        
      }
    }
  }
}





resource "aws_bedrockagent_prompt" "companygeneralprompt" {
  name            = "companygeneralprompt"
  description     = "Generates professional responses to general customer emails"
  default_variant = "Variant1"

  variant {
    name     = "Variant1"
    model_id = "global.amazon.nova-2-lite-v1:0"

    inference_configuration {
      text {
        temperature = 0.8
      }
    }

    template_type = "TEXT"
    template_configuration {
      text {
        text = "You are a helpful customer service agent. Read the following customer email and write a brief, professional response (3-4 sentences). Customer email: {{email}}"

        input_variable {
          name = "email"
        }
        
      }
    }
  }
}

resource "aws_bedrockagent_prompt" "companycomplaintprompt" {
  name            = "companycomplaintprompt"
  description     = "Generates empathetic responses to customer complaints"
  default_variant = "Variant1"

  variant {
    name     = "Variant1"
    model_id = "global.amazon.nova-2-lite-v1:0"

    inference_configuration {
      text {
        temperature = 0.8
      }
    }

    template_type = "TEXT"
    template_configuration {
      text {
        text = "You are a customer service agent. Read the following customer complaint and write a brief, empathetic response (3-4 sentences) that acknowledges the issue and offers a resolution. Customer email: {{email}}"

        input_variable {
          name = "email"
        }
        
      }
    }
  }
}