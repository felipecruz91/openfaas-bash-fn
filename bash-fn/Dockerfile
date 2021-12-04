FROM ghcr.io/openfaas/classic-watchdog:0.2.0 as watchdog

FROM alpine:3.12

RUN mkdir -p /home/app

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

# Add non root user
RUN addgroup -S app && adduser app -S -G app
RUN chown app /home/app

ENV TERRAFORM_VERSION=1.0.3

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /home/app

COPY main.tf /home/app/
COPY provision.sh .

USER app

# Populate example here - i.e. "cat", "sha512sum" or "node index.js"
ENV fprocess="xargs sh provision.sh"
# Set to true to see request in function logs
ENV write_debug="false"

EXPOSE 8080

HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
