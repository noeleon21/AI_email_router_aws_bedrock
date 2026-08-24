# AI Email Router with Amazon Bedrock

This project defines the Amazon Bedrock foundation for an AI-powered customer email router using Terraform.

## Implemented So Far

- Amazon Bedrock prompts for:
	- Email classification (`complaint`, `question`, or `refund`)
	- Complaint responses
	- General customer responses
- A Bedrock guardrail for hate and insult content
- A Bedrock flow that:
	1. Accepts an email as input
	2. Classifies the email
	3. Routes complaints to the complaint-response prompt
	4. Routes other messages to the general-response prompt
	5. Returns the generated response
- IAM permissions for the Bedrock flow to invoke the model, access prompts, and apply the guardrail
- AWS provider configuration for the `us-east-1` region

## Project Structure

```text
terraform/
├── bedrockflow.tf       # Bedrock flow and routing logic
├── bedrockguardrail.tf  # Bedrock guardrail and version
├── bedrockprompts.tf    # Bedrock prompt resources
├── iam.tf               # Bedrock flow IAM role and permissions
├── locals.tf            # Model and prompt definitions
├── main.tf              # Terraform and AWS provider configuration
└── variables.tf         # Reserved project variables
```

## Prerequisites

- Terraform
- An AWS account with permission to create Bedrock resources and IAM roles
- Access to the configured Amazon Bedrock model in `us-east-1`

## Deploy

From the `terraform` directory:

```powershell
terraform init
terraform plan
terraform apply
```

The Bedrock flow currently expects an email string as its input document. Its output is the generated response from the selected prompt.

## Not Implemented Yet

The following pieces are intentionally excluded from the implemented project scope:

- Python email-processing code
- AWS Lambda deployment and invocation
- Amazon S3 email storage
- Amazon SES domain verification, receipt rules, and outgoing email

These integrations can be added later to receive real emails, store the raw messages, invoke the Bedrock flow, and send replies.