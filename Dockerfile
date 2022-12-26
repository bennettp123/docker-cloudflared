FROM debian:bullseye AS build

# see https://pkg.cloudflare.com/index.html#debian-bullseye
RUN apt-get update \
    && apt-get install -y \
       curl \
       sudo \
   && sudo mkdir -p --mode=0755 /usr/share/keyrings

ARG COMMENT="Installing cloudflared..."

RUN echo "${COMMENT}" \
   && curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null \
   && echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bullseye main' | sudo tee /etc/apt/sources.list.d/cloudflared.list \
   && sudo apt-get update \
   && sudo apt-get install -y \
       cloudflared

FROM scratch
COPY --from=build /usr/bin/cloudflared /bin/cloudflared
CMD [ "/bin/cloudflared" ]
