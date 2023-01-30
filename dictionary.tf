module "dictionary_repository" {
  source = "./modules/github_repository"

  name         = "dictionary"
  description  = "English dictionary for English learners"
  homepage_url = "https://dictionary.code2d.org/"
  private      = true
}

module "dictionary_amplify" {
  source = "./modules/aws_amplify"

  name = "dictionary"
}
