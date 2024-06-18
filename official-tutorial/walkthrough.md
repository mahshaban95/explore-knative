# Official Tutorial
 
In this document, I will follow the officail Knative [tutorial](https://knative.dev/docs/getting-started/).\
I will use this space to keep all the commands I use to act as a refernce. I will also add screenshot, key findings, etc.\
Important files will be stored in the same folder, `Official Tutorial`.

## [Installl Knative with quickstart](https://knative.dev/docs/getting-started/quickstart-install/)

- To setup a local environment that includes all the necessary depemdemcies (KN, Kubectl, Kind, etc), please refer to `../README.md`.
  - The local environment is installed using `nix-shell`, and it includes the quickstart plugin.

- Run the Knative quickstart plugin:
  ```bash
  kn quickstart kind
  ```

- After the plugin is finished, verify you have a cluster called knative:
  ```bash
  kind get clusters
  ```

## [Knative Functions](https://knative.dev/docs/getting-started/about-knative-functions/)

- This section requires `knative-extensions/kn-plugins/func`, so I added it to the `nix-shell` env.

- Verify `kn fun` is workig
  ```bash
  kn func version
  # or just
  func version # if not considered a kn plugin
  ```

- Create your function
  ```bash
  func create -l <language> <function-name>
  # Example:
  func create -l go hello
  ```

- Run the function locally by running the command inside the project directory.
  ```bash
  cd hello
  func run [--registry <registry>]
  # Example
  func run --registry knative # This builds an OCI image called knative in your local machine
  kn func run --build # This can force building

- Test the function
  ```bash
  func invoke # make sure you are in the same directoty as the function
  ```

- Deploy the function
  - I have no idea what this does but here is the command anyway so I revisit in the future.
  ```bash
  func deploy --registry <registry>
  ```
  - I think it deploys the function to the cluster or upload it to the registry but the [documentation](https://knative.dev/docs/getting-started/build-run-deploy-func/#deploying-a-function) in the getting-started tutorial is very vague.


- Build the function without Running it
  ```bash
  func build
  ```

## [Knative Serving](https://knative.dev/docs/getting-started/first-service/)