resource "aws_iam_role" "this" {
  name = "${var.project_name}-${var.environment}-step-function"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_invoke" {
  name = "${var.project_name}-${var.environment}-step-function-lambda"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version : "2012-10-17"
    Statement : [{
      Effect : "Allow"
      Action : [
        "lambda:InvokeFunction"
      ]
      Resource : var.lambda_arns
    }]
  })
}