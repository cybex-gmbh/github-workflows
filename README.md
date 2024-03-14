# Workflows

This repository stores GitHub Action workflow files for reuse. Check below for explanations for each workflow.

A workflow that uses another workflow is referred to as a "caller" workflow. The reusable workflow is a "called" workflow.

## Usage

### General

To call a reusable workflow, define a job without steps and reference the workflow file in the `uses` keyword:

```yml
jobs:
  your-job-name:
    name: A concise name for your job
    uses: username/repository/.github/workflows/workflow.yml@main
```

If a reusable workflow expects `Inputs` and `Secrets`, they can be passed like this:

```yml
...
uses: username/repository/.github/workflows/workflow.yml@main
with:
  AN_INPUT: 1234
secrets:
  A_MULTILINE_SECRET: |
    SECRET1="${{ secrets.SECRET1 }}"
    SECRET2="${{ secrets.SECRET2 }}"
  ANOTHER_SECRET: ${{ secrets.SECRET3 }}
```

> [!NOTE]
>
> `Inputs` are non-sensitive variables of the type boolean, number or string.
>
> `Secrets` are sensitive variables which will not be shown in workflow logs.
>
> A multiline secret can be used to pass an arbitrary amount of secrets to a called workflow, e.g. env variables.

If all required `Secrets` are already in any secret store, they can be inherited to the called workflow:

```yml
...
    secrets: inherit
```

As soon as one `Secret` is explicitly specified, all other `Secrets` also have to be specified.

### Docker Build & Push

This workflow builds a docker image and pushes it to Docker Hub.

Working with GitHub releases is required as the semantic versioning is used for image tags. The `latest` tag will only be applied, if the release is marked as latest in GitHub. 

Additionally, the repository README file and description will be synchronized to Docker Hub. 

For this workflow to work, the following GitHub secrets have to be defined:

- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN

Also, the Docker Hub repository has to be passed as input. See the workflow input section for details.

### [Pullpreview](https://github.com/pullpreview/action)

When labeling a pull request with the "pullpreview" label, a staging environment is booted. To make this functional, some environment variables have to be stored in GitHub secrets:

- PULLPREVIEW_BASIC_AUTH
- PULLPREVIEW_AWS_ACCESS_KEY_ID
- PULLPREVIEW_AWS_SECRET_ACCESS_KEY

There might be more necessary environment variables, depending on the app.

#### Basic auth

The basic authentication is used to prevent the staging environment from being publicly viewable.

Use the following command to create a new user:password pair:

```bash
htpasswd -nB user
```

> By using the -B option `bcrypt` is used for hashing. The default is `MD5`.

The output has to be stored inside the `PULLPREVIEW_BASIC_AUTH` secret.

#### AWS Credentials

You need credentials of an IAM user that can manage AWS Lightsail. For a recommended configuration take a look at
the [Pullpreview wiki](https://github.com/pullpreview/action/wiki/Recommended-AWS-Configuration).

## Development
