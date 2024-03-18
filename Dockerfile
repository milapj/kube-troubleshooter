FROM --platform=linux/amd64 alpine:3.14

SHELL ["/bin/sh", "-exc"]
WORKDIR /usr/local

RUN \
    apk upgrade; \
    apk add --no-cache dumb-init bind-tools vim curl unzip less jq tmux

RUN \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    unzip awscliv2.zip; \
    ./aws/install; \
    rm -rf awscliv2.zip

RUN \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"; \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c; \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl ; \
    kubectl version --client


ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD /bin/bash
