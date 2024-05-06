# Workflows

This repository stores GitHub Action workflow files for reuse. Check below for explanations for each workflow.

A workflow that uses another workflow is referred to as a "caller" workflow. The reusable workflow is a "called" workflow.

## Usage

### Examples

There are examples on how to call the reusable workflows in the `/examples` folder. Workflows have to be placed in the `.github/workflows` folder in your repository.

### General

> [!NOTE]
>
> `Inputs` are non-sensitive variables of the type boolean, number or string. Passed with the `with` keyword.
>
> `Secrets` are sensitive variables which will not be shown in workflow logs. Passed with the `secrets` keyword.

If all required `Secrets` are already in any secret store, they can be inherited to the called workflow:

```yml
...
    secrets: inherit
```

As soon as one `Secret` is explicitly specified, all other `Secrets` also have to be specified.

A multiline secret can be used to pass an arbitrary amount of secrets to a called workflow, e.g. env variables:

```yml
...
  secrets:
    A_MULTILINE_SECRET: |
      SECRET1="${{ secrets.SECRET1 }}"
      SECRET2="${{ secrets.SECRET2 }}"
```

### Docker Build & Push

This workflow builds a docker image and pushes it to Docker Hub.

Working with GitHub releases is required as the semantic versioning is used for image tags. The `latest` tag will only be applied, if the release is marked as latest in GitHub. 

Additionally, the repository README file and description will be synchronized to Docker Hub. 

For this workflow to work, the following GitHub secrets have to be defined:

- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN

Also, the Docker Hub repository has to be passed as input. See the workflow input section for details.

### [Pullpreview](https://github.com/pullpreview/action)

When labeling a pull request with the `pullpreview` label, a staging environment is booted. To make this functional, some environment variables have to be stored in GitHub secrets:

- PULLPREVIEW_BASIC_AUTH
- PULLPREVIEW_AWS_ACCESS_KEY_ID
- PULLPREVIEW_AWS_SECRET_ACCESS_KEY

There might be more necessary environment variables, depending on the app.

#### Viewing the deployment

After successfully deploying, the staging environment can be viewed at the bottom of the conversation history.

#### SSH

User: ec2-user

IP: Can be found in the URL of the deployment or is printed out in the GitHub Actions log of the workflow.

```bash
ssh ec2-user@0.0.0.0
```

This will also be printed out in the comment section of the pull request and updated after each deployment.

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

#### Artifacts

The name of an artifact can be passed as an `Input` to include additional files on the staging environment. When extracting downloaded artifacts, the file paths are preserved.

See [GitHub Artifacts Docs](https://docs.github.com/en/actions/using-workflows/storing-workflow-data-as-artifacts) for more information.

### Tests workflow

This workflow executes tests for Laravel projects.

You may pass custom commands which execute the tests, in case your project needs a specific way of executing the tests on the command line (e.g. package projects that don't have the `Artisan` file).
For the default, take a look at the workflow file.

There is also an `Input` for when you need to install additional linux packages. 

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
