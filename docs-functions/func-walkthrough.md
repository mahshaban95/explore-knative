# Knative Functions

In this document, I will follow the official documentation for the Functions [section](https://knative.dev/docs/functions/).\
I will use this space to keep all the commands I use to act as a refernce. I will also add screenshot, key findings, etc.\
Important files will be stored in the same folder.

## [Installation](https://knative.dev/docs/functions/install-func/)

- You can install Knative functions using the following command.
  ```bash
  brew install func
  ```
  - Or if you are following my `../README.md`, you should have it installed directly in your `nix-shell`.

## [Creating functions](https://knative.dev/docs/functions/creating-functions/)

- Create your function
  ```bash
  func create -l <language> <function-name>
  # Example:
  func create -l python hello-python
  ```

## [Building functions](https://knative.dev/docs/functions/building-functions/)

Building a function creates an OCI container image for your function that can be pushed to a container registry. You can either build a container image for your function locally without deploying it to a cluster.You can also build your function on the cluster instead of using a local build.

### Local builds

- Build the function locally.
  ```bash
  func build
  # You will be prompted to enter a registry for your function
  # Or you can just provide it as below
  func build --registry <registry>
  # Example
  func build --registry registry.example.com/knative-python # make sure your are in the function's directory
  ```
 
 ### On-cluster Builds

 As the name implies, this will build your function on the cluster. For it to work there are two prerequisites:

 - The code needs to be fetched from a GIT Repo by the cluster.
 - You must configure your cluster to use Tekton Pipelines.
 
 To be honest, I do not see a great benefit of this. It might be more effiecient but I could just build the function on my regular pipeline system then deploy to the cluster.

 - Here is how you build remotely.
    ```bash
    func deploy --remote --registry <registry> --git-url <git-url> -p hello
    ```

I will not spend more time on this now but here is a [link](https://github.com/knative/func/blob/main/docs/building-functions/on_cluster_build.md) for more info.

## [Running functions](https://knative.dev/docs/functions/running-functions/)

Running a function creates an OCI container image for your function if required before running the function in your local environment, but does not deploy the function to a cluster. This can be useful if you want to run your function locally for a testing scenario.

- Run the function locally by running the command inside the project directory.
  ```bash
  func run [--registry <registry>]
  # Example
  func run --registry registry.example.com/knative-python
  ```
  - Note: The coordinates for the image registry can be configured through an environment variable (FUNC_REGISTRY) as well.

- Verify that your function has been successfully run.
  ```bash
  func invoke
  # You can use the func invoke command to send test data to your function with the --data flag.
  ```

- Additional build options:
  ```bash
  # You can force a rebuild of the image by running the command:
  func run --build
  # It is also possible to disable the build, by running the command:
  func run --build=false
  ```


## [Subscribe functions to CloudEvents](https://knative.dev/docs/functions/subscribing-functions/)

The `subscribe` command will connect the function to a set of events, matching a series of filters for Cloud Event metadata and a Knative Broker as the source of events, from where they are consumed.

```bash
func subscribe --filter type=com.example --filter extension=my-extension-value --source my-broker
```

## [Deploying functions](https://knative.dev/docs/functions/deploying-functions/)

Deploying a function creates an OCI container image for your function, and pushes this container image to your image registry. The function is deployed to the cluster as a **Knative Service**.

```bash
func deploy --registry <registry>
```

## (Language packs)[https://knative.dev/docs/functions/language-packs/]

Language packs can be used to extend Knative Functions to support additional runtimes, function signatures, operating systems, and installed tooling for functions. [Here](https://github.com/knative/func/blob/main/docs/language-packs/language-pack-contract.md) is more.

When creating a new function, a Git repository can be specified as the source for the template files. [Here](https://github.com/knative-extensions/func-tastic) are examples.

- Using external Git repositories.
  ```bash
  # Example
  func create myfunc -l nodejs -t metacontroller --repository https://github.com/knative-extensions/func-tastic
  ```

- Installing language packs locally.
  ```bash
  func repository add knative https://github.com/knative-extensions/func-tastic
  func create -t knative/metacontroller -l nodejs my-controller-function
  ```

  