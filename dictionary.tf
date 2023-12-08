module "dictionary_repository" {
  source = "git::https://github.com/raviqqe/terraform-modules"

  name         = "dictionary"
  description  = "English dictionary for English learners"
  homepage_url = "https://dictionary.code2d.org/"
  private      = true
}

module "dictionary_amplify" {
  source = "git::https://github.com/raviqqe/terraform-modules"

  name = "dictionary"
}
