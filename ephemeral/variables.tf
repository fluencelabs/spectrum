variable "github_branch" {
  description = "GitHub branch that Flux will checkout to"
  type        = string
}

variable "github_pr_url" {
  description = "GitHub url to PR that triggered the workflow"
  type        = string
  default     = "https://github.com/fluencelabs"
}
