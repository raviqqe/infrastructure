import {
  id = "hathaway"
  to = module.hathaway_repository.github_repository.repository
}

module "hathaway_repository" {
  source = "./modules/github_repository"

  name    = "hathaway"
  topics  = []
  private = true
}
