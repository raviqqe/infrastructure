module "dictionary_repository" {
  source = "./modules/github_repository"

  name         = "dictionary"
  description  = "English dictionary for English learners"
  homepage_url = "https://englia.app/"
  private      = true
}

import {
  to = github_repository_pages.dictionary
  id = "dictionary"
}

resource "github_repository_pages" "dictionary" {
  repository = module.dictionary_repository.name
  build_type = "workflow"
}
