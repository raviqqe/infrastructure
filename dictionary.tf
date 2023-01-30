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
