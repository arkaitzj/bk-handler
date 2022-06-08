# Unblock buildkite pipelines
Intended to be used from a container, such as a post-sync hook, although nothing prevents you from using it from commandline


## Help
So far only the unblock command is implemented and it needs the buildkite token passed as an env var BUILDKITE_TOKEN

      Usage: bk-handler [OPTIONS] COMMAND [ARGS]...

      Options:
        --help  Show this message and exit.

      Commands:
        unblock
      
Here is how it is used

      Usage: bk-handler unblock [OPTIONS]

      Options:
        --pipeline-slug TEXT  [required]
        --block-key TEXT      [required]
        --build-id INTEGER    [required]
        --organization TEXT   [required]
        --field TEXT
        --help                Show this message and exit.


      $ BUILDKITE_TOKEN=BLAH ./bk-handler unblock --organization ${MYCOMPANY} --pipeline-slut my-pipeline \
                                                  --build-id 34 --block-key stage-sync --field synced=yes

For an ArgoCD example with helm placeholders:

      apiVersion: batch/v1
      kind: Job
      metadata:
        name: Deployment-MYAPP-ready
        annotations:
          argocd.argoproj.io/hook: PostSync
          argocd.argoproj.io/hook-delete-policy: HookSucceeded
      spec:
        template:
          spec:
            containers:
            - name: buildkite-trigger
              image: arkaitzj/bk-handler
              env:
                - name: BUILDKITE_TOKEN
                  valueFrom: 
                    secretKeyRef:
                      name: deployment-pipeline-secrets
                      key: buildkite-token
                      optional: false
              args:
                - unblock
                - --organization 
                - MYCOMPANY 
                - --pipeline-slug 
                - "{{ $.Values.pipeline }}"
                - --block-key 
                - "{{ $.Values.block_key}}" 
                - --build-id 
                - "{{ $.Values.build }}"
                - --field 
                - "{{ $.Values.field }}=yes"

            restartPolicy: Never
        backoffLimit: 1
In this case the buildkite token is taken from a Kubernetes secret