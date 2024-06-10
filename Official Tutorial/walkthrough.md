# Official Tutorial
 
In this document, I will follow the officail Knative [tutorial](https://knative.dev/docs/getting-started/).\
I will use this space to keep all the commands I use to act as a refernce. I will also add screenshot, key findings, etc.\
Important files will be stored in the same folder, `Official Tutorial`.

## [Installl Knative with quickstart](https://knative.dev/docs/getting-started/quickstart-install/)

- To setup a local environment that includes all the necessary depemdemcies (KN, Kubectl, Kind, etc), please refer to `../README.md`.

- Install Knative and Kubernetes using kind by running:
  ```bash
  kn quickstart kind
  ```

- After the plugin is finished, verify you have a cluster called knative:
  ```bash
  kind get clusters
  ```

## [Knative Functions](https://knative.dev/docs/getting-started/about-knative-functions/)

