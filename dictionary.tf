module "github_repository" {
  source = "./modules/github-repository"

  name         = "dictionary"
  description  = "English dictionary with infinite history"
  homepage_url = "https://dictionary.code2d.org/"
  private      = true
}

resource "random_id" "dictionary_project_id" {
  byte_length = 5
  prefix      = "dictionary-"
}

resource "google_project" "dictionary" {
  provider = google-beta

  project_id = random_id.dictionary_project_id.id
  name       = "dictionary"
}

resource "google_firebase_project" "default" {
  provider = google-beta

  project      = google_project.dictionary.project_id
  display_name = "dictionary"
}
