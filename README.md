# Overview

I am using this repo to document my personal exploration of the Knative project.

Knative is an exciting open-source project that provides a set of middleware components for building, deploying, and managing modern serverless workloads on Kubernetes. It's designed to give developers the tools they need to quickly build scalable and stateless applications in any language.

With Knative, you can focus more on writing code and less on the complexities of building and deploying applications. It offers features like scaling up or down automatically, depending on traffic, and it can even scale your app down to zero when it's not being used, which can save resources and money.

Knative also simplifies the process of rolling out new versions of your app with features like traffic splitting, which lets you gradually shift users over to a new version. This means you can make sure everything is working smoothly before everyone starts using the latest release.

Whether you're a seasoned developer or just starting out, Knative makes it easier to get your apps up and running on Kubernetes, so you can take advantage of all the benefits of a cloud-native platform.


## Local Development Environment

- Use `nix-shell`
    - Here is a [tutorial](https://www.youtube.com/watch?v=0ulldVwZiKA&t=586s&pp=ygUDbml4) on how to use it.
- Clone the repo.
- Make sure you are in the root directory for the repository.
- Make sure the `shell.nix` file is in the root directoty of the repository as well.
- Run the command:
```bash
nix-shell shell.nix --run $SHELL
```