FROM alpine:latest

ENV BUILDKITE_TOKEN

WORKDIR /workdir

COPY ./bk-handler .

ENTRYPOINT [ "./bk-handler"  ]
