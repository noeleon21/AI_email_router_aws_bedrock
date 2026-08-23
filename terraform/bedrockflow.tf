resource "aws_bedrockagent_flow" "company-email-router" {
  name               = "companyemailrouter"
  execution_role_arn = aws_iam_role.bedrock_flow_execution.arn

  definition {

    # 1. Input -> Classifier
    connection {
      name   = "FlowInputNodeFlowInputNode0Tocompanyemailclassifiercompanyemailclassifier0"
      source = "FlowInputNode"
      target = "companyemailclassifier"
      type   = "Data"

      configuration {
        data {
          source_output = "document"
          target_input  = "email"
        }
      }
    }

     connection {
      name   = "FlowInputNodeFlowInputNode0Tocompanyemailcompliantprompt"
      source = "FlowInputNode"
      target = "companycomplaintprompt"
      type   = "Data"

      configuration {
        data {
          source_output = "document"
          target_input  = "email"
        }
      }
    }

        connection {
      name   = "FlowInputNodeFlowInputNode0Tocompanyemailgeneralprompt"
      source = "FlowInputNode"
      target = "companygeneralprompt"
      type   = "Data"

      configuration {
        data {
          source_output = "document"
          target_input  = "email"
        }
      }
    }

    

    # 2. Classifier -> Condition node
    connection {
      name   = "companyemailclassifierToComplaintChecker"
      source = "companyemailclassifier"
      target = "complaintchecker"
      type   = "Data"

      configuration {
        data {
          source_output = "modelCompletion"   # matches classifier's output name
          target_input  = "conditionInput"    # matches complaint-checker's input name
        }
      }
    }
    

    # 3. Condition: is_complaint -> complaint response prompt
    connection {
      name   = "complaintcheckertocompanycomplaintprompt"
      source = "complaintchecker"
      target = "companycomplaintprompt"
      type   = "Conditional"

      configuration {
        conditional {
          condition = "is_complaint"
        }
      }
    }

    # 4. Condition: default -> general response prompt
    connection {
      name   = "complaintcheckertocompanygeneralprompt"
      source = "complaintchecker"
      target = "companygeneralprompt"
      type   = "Conditional"

      configuration {
        conditional {
          condition = "default"
        }
      }
    }

    # 5. Complaint response -> Output
    connection {
      name   = "companycomplaintresponsetooutput"
      source = "companycomplaintprompt"
      target = "CompliantFlowOutputNode"
      type   = "Data"

      configuration {
        data {
          source_output = "modelCompletion"
          target_input  = "document"
        }
      }
    }

    # 6. General response -> Output
    connection {
      name   = "companygeneralresponsetooutput"
      source = "companygeneralprompt"
      target = "GeneralFlowOutputNode"
      type   = "Data"

      configuration {
        data {
          source_output = "modelCompletion"
          target_input  = "document"
        }
      }
    }

    # --- Nodes ---

    node {
      name = "FlowInputNode"
      type = "Input"

      configuration {
        input {}
      }

      output {
        name = "document"
        type = "String"
      }
    }

    node {
      name = "companyemailclassifier"
      type = "Prompt"

      configuration {
        prompt {
          source_configuration {
            resource {
              prompt_arn = aws_bedrockagent_prompt.email_prompts["classifier"].arn
            }
          }

          guardrail_configuration {
            guardrail_identifier = aws_bedrock_guardrail.email_router_guardrail.guardrail_arn
            guardrail_version    = aws_bedrock_guardrail.email_router_guardrail.version
          }
        }
      }

      input {
        expression = "$.data"
        name       = "email"
        type       = "String"
      }

      output {
        name = "modelCompletion"
        type = "String"
      }
    }

    node {
      name = "complaintchecker"
      type = "Condition"

      configuration {
        condition {
          condition {
            name       = "is_complaint"
            expression = "conditionInput == \"complaint\""
          }
          condition {
            name = "default"
          }
        }
      }

      input {
        expression = "$.data"
        name       = "conditionInput"
        type       = "String"
      }
    }

    node {
      name = "companycomplaintprompt"
      type = "Prompt"

      configuration {
        prompt {
          source_configuration {
            resource {
              prompt_arn = aws_bedrockagent_prompt.email_prompts["complaint"].arn
            }
          }
        }
      }

      input {
        expression = "$.data"
        name       = "email"
        type       = "String"
      }

      output {
        name = "modelCompletion"
        type = "String"
      }
    }

    node {
      name = "companygeneralprompt"
      type = "Prompt"

      configuration {
        prompt {
          source_configuration {
            resource {
              prompt_arn = aws_bedrockagent_prompt.email_prompts["general"].arn
            }
          }
        }
      }

      input {
        expression = "$.data"
        name       = "email"
        type       = "String"
      }

      output {
        name = "modelCompletion"
        type = "String"
      }
    }

    node {
      name = "CompliantFlowOutputNode"
      type = "Output"

      configuration {
        output {}
      }

      input {
        expression = "$.data"
        name       = "document"
        type       = "String"
      }
    }

      node {
      name = "GeneralFlowOutputNode"
      type = "Output"

      configuration {
        output {}
      }

      input {
        expression = "$.data"
        name       = "document"
        type       = "String"
      }
    }
  }
}

resource "terraform_data" "prepare_flow" {
  triggers_replace = {
    flow_state = sha256(jsonencode(aws_bedrockagent_flow.company-email-router))
  }

  provisioner "local-exec" {
    command = "aws bedrock-agent prepare-flow --flow-identifier ${aws_bedrockagent_flow.company-email-router.id} --region us-east-1"
  }
}