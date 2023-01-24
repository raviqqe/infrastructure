resource "github_repository" "dictionary" {
  name         = "dictionary"
  description  = "English dictionary with infinite history"
  homepage_url = "https://dictionary.code2d.org/"
  visibility   = "private"

  allow_auto_merge            = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
  allow_squash_merge          = true
  allow_update_branch         = true
  delete_branch_on_merge      = true
  merge_commit_message        = "PR_BODY"
  merge_commit_title          = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"
  squash_merge_commit_title   = "PR_TITLE"
}
