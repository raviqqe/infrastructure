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

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.dictionary.id
  branch_name = "main"
}

resource "aws_amplify_backend_environment" "dictionary" {
  app_id           = aws_amplify_app.dictionary.id
  environment_name = "production"
}

resource "aws_amplify_app" "dictionary_2" {
  name = "dictionary_2"
}
