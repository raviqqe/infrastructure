output "repo_id" {
  value = github_repository.repository.repo_id
}

output "name" {
  value = github_repository.repository.name
}

output "owner" {
  value = split("/", github_repository.repository.full_name)[0]
}

output "full_name" {
  value = github_repository.repository.full_name
}
