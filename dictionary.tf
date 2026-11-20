import {
  to = module.dictionary_repository.github_repository_pages.repository
  id = "dictionary"
}

module "dictionary_repository" {
  source = "./modules/github_repository"

  name         = "dictionary"
  description  = "English dictionary for English learners"
  homepage_url = "https://englia.app/"
  private      = true
}
