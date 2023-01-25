module "github_repository" {
  source = "./modules/github-repository"

  name         = "dictionary"
  description  = "English dictionary with infinite history"
  homepage_url = "https://dictionary.code2d.org/"
  private      = true
}

resource "google_project" "dictionary" {
  provider = google-beta

  project_id = "dictionary-%{random_suffix}"
  name       = "dictionary"
}

resource "google_firebase_project" "default" {
  provider = google-beta

  project  = google_project.dictionary.project_id
}
