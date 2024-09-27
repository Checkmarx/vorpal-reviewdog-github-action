# GitHub Action: Run Vorpal with reviewdog 🐶

This action runs `Vorpal` with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

**Vorpal is an ultra-fast engine**, specifically designed to empower developers by enabling them to identify and address security best coding practices early in the development process, known as "shifting left." By catching potential issues at the initial stages, Vorpal helps developers proactively prevent costly security reviews and critical security issues later in the development cycle.
 
Unlike traditional SAST engines that scan entire projects and analyze complex source code flows, Vorpal focuses on individual files and short code snippets, including AI-generated code. It empowers developers with clear, actionable feedback on detected issues, complete with descriptions and remediation advice, enabling them to quickly enhance the security of their codebases. While Vorpal doesn't delve into specific attack vectors, it emphasizes proactive security measures early in the development process, which not only strengthens code security but also reduces and refines findings in later SAST scans, making them more precise and manageable.

Vorpal currently supports `Java`, `JavaScript (Node.js)`, `C#`, and `Python`.

## Examples
### With github-pr-check
By default, with reporter: github-pr-check an annotation is added to the line:

![image](https://github.com/user-attachments/assets/bd22dc03-5d2a-43e4-8f12-734b530e1ba9)


### With github-pr-review
With reporter: github-pr-review a comment is added to the Pull Request Conversation:

![image](https://github.com/user-attachments/assets/3f6a35fa-c49d-4f8c-a37f-cbb7cb483809)


## Inputs

### `github_token`

**Description**: GITHUB_TOKEN.  
**Required**: true  
**Default**: `${{ github.token }}`

### `source_path`

**Description**: Specify the source paths to analyze (comma-separated).  
**Required**: true

### `level`

**Description**: Report level for reviewdog [info, warning, error].  
**Default**: `error`

### `reporter`

**Description**: Reporter of reviewdog command [github-pr-check, github-pr-review].  
**Default**: `github-pr-review`

### `filter_mode`

**Description**: Filtering mode for the reviewdog command [added, diff_context, file, nofilter].  
**Default**: `added`

### `fail_on_error`

**Description**: Exit code for reviewdog when errors are found [true, false].  
**Default**: `false`

### `reviewdog_flags`

**Description**: Additional reviewdog flags.  
**Default**: ``

## Simple Example Usage

```yaml
name: vorpal-reviewdog
on: [pull_request]
jobs:
  vorpal:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Vorpal with reviewdog
        uses: checkmarx/vorpal-reviewdog-github-action@v1.0.0
        with:
          source_path: testdata/samples/FileA.java,testdata/samples/FileB.java
          filter_mode: file
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-check
          level: error
          fail_on_error: false

```

## Example With Changed Files
In the example bellow we use the [tj-action/changed-files](https://github.com/tj-actions/changed-files) with vorpal-reviewdog-github-action so we do not need to specify files in the source_path field.

```yaml
name: vorpal-reviewdog-changeFiles
on: [pull_request]
jobs:
  vorpal:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Get changed files
        id: changed-files
        uses: tj-actions/changed-files@v44
        with:
          separator: ','
        
      - name: Vorpal with reviewdog
        if: ${{ steps.changed-files.outputs.all_changed_files != '' }}
        uses: checkmarx/vorpal-reviewdog-github-action@v1.0.0
        with:
          source_path: "${{ steps.changed-files.outputs.all_changed_files }}"
          filter_mode: file
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-check
          level: error
          fail_on_error: false
```

## Sponsor

[![Evrone Logo](https://github.com/user-attachments/assets/ff7dcb32-d462-4eb8-aa12-eaff0ddecc66)](https://checkmarx.com)

## License

Apache License Version 2.0


