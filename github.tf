module "github_repository" {
  source       = "./modules/github-repository"
  name         = "dictionary"
  description  = "English dictionary with infinite history"
  homepage_url = "https://dictionary.code2d.org/"
  private      = true
}
