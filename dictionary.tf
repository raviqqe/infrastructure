module "dictionary_repository" {
  source = "git::https://github.com/raviqqe/terraform-modules//github_repository"

  name         = "dictionary"
  description  = "English dictionary for English learners"
  homepage_url = "https://englia.app/"
  private      = true
}

module "dictionary_amplify" {
  source = "git::https://github.com/raviqqe/terraform-modules//aws_amplify"

  name = "dictionary"
}
