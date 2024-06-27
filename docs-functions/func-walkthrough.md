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

Building a function creates an OCI container image for your function that can be pushed to a container registry. You can either build a container image for your function locally without deploying it to a cluster.You can also build your function on the cluster instead of using a local build

### Local builds

- Build the function locally.
  ```bash
  func build
  # You will be prompted to enter a registry for your function
  # Or you can just provide it as below
  func build --registry <registry>
  ```
 