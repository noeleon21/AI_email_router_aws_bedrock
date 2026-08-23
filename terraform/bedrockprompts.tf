resource "aws_bedrockagent_prompt" "email_prompts" {
  for_each = local.email_prompt_definitions

  name            = each.value.name
  description     = each.value.description
  default_variant = "Variant1"

  variant {
    name     = "Variant1"
    model_id = local.model_id

    inference_configuration {
      text {
        temperature = 0.8
      }
    }

    template_type = "TEXT"
    template_configuration {
      text {
        text = each.value.text

        input_variable {
          name = "email"
        }
      }
    }
  }
}