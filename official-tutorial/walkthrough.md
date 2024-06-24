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

Next, We will deploy a `Hello world` Knative Service that accepts the environment variable `TARGET` and prints `Hello ${TARGET}!`.

- Deploy the Service
  ```bash
  kn service create hello \
  --image ghcr.io/knative/helloworld-go:latest \
  --port 8080 \
  --env TARGET=World
  ```

- Get info about the service
  ```bash
  kn service describe hello
  ```

- Update the service
  ```bash
  kn service update hello --env TARGET=Mahmoud
  ```
  Note:
  -  New pods are created for the updated version. 
  -  Pods are terminated after some time of inactivity.
  -  At time of inactivity the `READY` state of deployments is `0/0` indicating that there are no pods running (scale to **zero** feature). You can check all that using `kubectl`:
      ```bash
      kubectl get all
      ```


### [Autoscaling](https://knative.dev/docs/getting-started/first-autoscale/#autoscaling) 

- View a list of Knative Services by running the command:
  ```bash
  kn service list
  # or
  kubectl get ksvc
  ```

- Test your Knative Service:
  ```bash
  echo "Accessing URL $(kn service describe hello -o url)"
  curl "$(kn service describe hello -o url)"
  ```

- Watch the pods and see how they scale to zero after traffic stops going to the URL:
  ```bash
  kubectl get pod -l serving.knative.dev/service=hello -w
  ```
  - We noted that before in the previous section.


### [Traffic splitting](https://knative.dev/docs/getting-started/first-traffic-split/)

- Create a new revision by updating the created service.
  ```bash
  kn service update hello --env TARGET=Knative
  ```

- Test that the revision is created properly.
  ```bash
  echo "Accessing URL $(kn service describe hello -o url)"
  curl "$(kn service describe hello -o url)" 
  ```

- View existing revisions.
  ```bash
  kn revisions list
  # or
  kubectl get revisions
  ```

- Split the traffic between the two Revisions:
  ```bash
  kn service update hello \
  --traffic hello-service-00001=50 \
  --traffic @latest=50
  ```

- Delete the created service:
  ```bash
  kn service delete hello 
  ```

## [Knative Eventing](https://knative.dev/docs/getting-started/getting-started-eventing/)

- Check if a Broker is installed
  - There should be an InMemoryChannel-backed Broker installed in your Kind cluster as part of the `kn quickstart` install.
  ```bash
  kn broker list
  # for more info about the broker
  kn broker describe <broker-name>
  # or
  kubectl get broker <broker-name> -oyaml
  ```

### [Using a Knative Service as a source](https://knative.dev/docs/getting-started/first-source/)


In this tutorial, you will use the [CloudEvents Player](https://github.com/ruromero/cloudevents-player) app to showcase the core concepts of Knative Eventing.

- Create a CloudEvents Player service to act as your source.
  ```bash
  kn service create cloudevents-player \
  --image quay.io/ruben/cloudevents-player:latest
  ```
  - Note that The CloudEvents Player acts as a Source for CloudEvents by intaking the name of the Broker as an environment variable, `BROKER_NAME`.

- We also need to create a source binidng between the **subject** (service) and the **sink** (broker).
  ```bash
  kn source binding create ce-player-binding --subject "Service:serving.knative.dev/v1:<service-name>" --sink broker:<broker-name>
  # or
  kn source binding create ce-player-binding --subject "Service:serving.knative.dev/v1:cloudevents-player" --sink broker:example-broker
  ```

- Use the CloudEvents Player to send and receive CloudEvents.
  - Get the URL to access the CloudEvents Player
    ```bash
    kn service describe cloudevents-player -o url
    ```
  - Open it in your browser, fill the form and send the event.
- Right now, the event went nowhere as the Broker is simply a receptacle for events. In order for your events to be sent anywhere, you must create a Trigger which listens for your events and places them somewhere.

### [Using Triggers and sinks](https://knative.dev/docs/getting-started/first-trigger/)

In the previous section, we used the [CloudEvents Player](https://github.com/ruromero/cloudevents-player) as a source for events. We will use it here to receive events as well.

- Create a Trigger that listens for CloudEvents from the event source and places them into the sink.
  ```bash
  kn trigger create cloudevents-trigger --sink cloudevents-player  --broker example-broker
  ```
  - You could also specify `--filter` in the `kn` command to filter which events the trigger is listening to.
      ```bash
      # for example
      kn trigger create cloudevents-player-filter --sink cloudevents-player  --broker example-broker --filter type=some-type
      ```

## Clean Up
```bash
kind delete clusters knative
```