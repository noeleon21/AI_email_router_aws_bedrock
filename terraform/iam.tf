data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "bedrock_flow_execution" {
  name = "company-email-router-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "bedrock.amazonaws.com" }
        Action    = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:flow/*"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "bedrock_flow_permissions" {
  name = "company-email-router-permissions"
  role = aws_iam_role.bedrock_flow_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "InvokeModels"
        Effect = "Allow"
        Action = ["bedrock:InvokeModel", "bedrock:InvokeModelWithResponseStream"]
        Resource = [
          "arn:aws:bedrock:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:inference-profile/us.amazon.nova-2-lite-v1:0"
        ]
      },
      {
        Sid      = "AccessPrompts"
        Effect   = "Allow"
        Action   = ["bedrock:GetPrompt", "bedrock:RenderPrompt"]
        Resource = [
          aws_bedrockagent_prompt.companyemailclassifier.arn,
          aws_bedrockagent_prompt.companycomplaintprompt.arn,
          aws_bedrockagent_prompt.companygeneralprompt.arn,
        ]
      }
    ]
  })
}