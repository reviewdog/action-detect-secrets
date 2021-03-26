# GitHub Action: Run detect-secrets with reviewdog

This action runs [detect-secrets](https://github.com/Yelp/detect-secrets) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

![detect-secrets-1](https://user-images.githubusercontent.com/3680861/112022952-6fcd7800-8b3b-11eb-8973-86a8a747d757.png)

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `workdir`

Optional. The directory from which to look for and run detect-secrets. Default '.'

### `filter_mode`

Optional. Reviewdog filter mode [added, diff_context, file, nofilter]
It's the same as the `-filter-mode` flag of reviewdog.

### `fail_on_error`

Whether reviewdog should fail when errors are found. [true,false]
This is useful for failing CI builds in addition to adding comments when errors are found.
It's the same as the `-fail-on-error` flag of reviewdog.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-pr-review,github-check].
Default is github-pr-check.
github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

### `reviewdog_flags`

Optional. Additional reviewdog flags.

### `detect_secrets_flags`

Optional. Flags and args of detect-secrets command.
The default is `--all-files --force-use-all-plugins`.

## Example usage

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: reviewdog
on: [pull_request]
jobs:
  detect-secrets:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: detect-secrets
      uses: reviewdog/action-detect-secrets@master
      with:
        github_token: ${{ secrets.github_token }}
        reporter: github-pr-review # Change reporter.
```

## Troubleshooting

```yaml
token: |  # pragma: allowlist secret
    gX69YO4CvBsVjzAwYxdG
    yDd30t5+9ez31gKATtj4
```
