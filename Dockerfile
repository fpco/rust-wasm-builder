ARG rust_ver

FROM rust:${rust_ver}
ARG wasm_opt_ver
ENV wasm_opt_ver=${wasm_opt_ver}
RUN bash -ex -o pipefail -c 'ver="version_${wasm_opt_ver}"; \
    url="https://github.com/WebAssembly/binaryen/releases/download/${ver}/binaryen-${ver}-x86_64-linux.tar.gz"; \
    wget -O- "${url}" | tar xvzf -; \
    find -name wasm-opt -exec mv {} /usr/bin/ \; ; \
    rustup target add wasm32-unknown-unknown'

VOLUME /code
VOLUME /usr/local/cargo/registry
VOLUME /code/artifacts

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
