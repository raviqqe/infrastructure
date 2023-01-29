module "github_repository" {
  source = "./modules/github-repository"

  name         = "dictionary"
  description  = "English dictionary for English learners"
  homepage_url = "https://dictionary.code2d.org/"
  private      = true
}

resource "aws_amplify_app" "dictionary" {
  name = "dictionary"
}

resource "aws_amplify_backend_environment" "dictionary" {
  app_id           = aws_amplify_app.example.id
  environment_name = "example"

  deployment_artifacts = "app-example-deployment"
  stack_name           = "amplify-app-example"
}
