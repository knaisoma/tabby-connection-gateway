# Tabby Connection Gateway

**Note: This is a fork of the original project available at [Eugeny/tabby-connection-gateway](https://github.com/Eugeny/tabby-connection-gateway)**

This is the connection gateway service that Tabby Web uses.
It's a Websocket &rarr; TCP gateway that allows Tabby to initiate arbitrary network connections from a browser.

You can host one yourself to prevent the connection traffic from going through the central connection gateway that I'm hosting.

Once started, you'll just need to enter your gateway URL and a secret token in the Tabby Web settings, and all future connections will go straight through your own gateway.

## Getting started (Docker)

```bash
docker pull docker.io/knaisoma/tabby-connection-gateway:latest
docker run -e TABBY_AUTH_TOKEN=secret123 -p 9000:9000 docker.io/knaisoma/tabby-connection-gateway:latest --token-auth --host 0.0.0.0
```

## Usage

TCG runs one Websocket listener for the incoming connections and one optional Websocket listener for management requests.

The management/admin listener is only used on Tabby Web's own managed gateways to authenticate new connections. For your local instance, you need to generate your own secret token and pass it via the `TABBY_AUTH_TOKEN` environment variable.

### Running with SSL

Note that if you're using Letsencrypt, you need to run the gateway on port 443 as they don't provide non-standard port certificates.

```sh
TABBY_AUTH_TOKEN="123..." tabby-connection-gateway --host 0.0.0.0 --port 443 --token-auth --certificate ssl.pem --key ssl.key
```

Connection gateway URL for Tabby settings: `wss://<host>`

You could theoretically add `--ca ca.pem` to enable client certificate auth, but AFAIK browsers (at least Chrome) don't support it with Websockets.

### Running without SSL

```sh
TABBY_AUTH_TOKEN="123..." tabby-connection-gateway --host 0.0.0.0 --port 1234 --token-auth
```

Connection gateway URL for Tabby settings: `ws://<host>:1234`

### All options

```markdown
tabby-connection-gateway <optional arguments>

optional arguments:
  --host HOST           address to listen on (default: 127.0.0.1)
  --port PORT           port to listen on (default: 9000)
  --certificate PATH    path to the SSL certificate. Enables SSL (default:
                        None)
  --private-key PATH
  --ca PATH             path to the CA certificate. Enables SSL client auth
                        (default: None)
  --no-auth             disables auth completely
  --token-auth          enables token based auth using the token from the
                        TABBY_AUTH_TOKEN env var (default: False)
  --admin-host ADMIN_HOST
                        address to listen on for management requests (default:
                        127.0.0.1)
  --admin-port ADMIN_PORT
                        port to listen on for management requests (default:
                        None)
  --admin-certificate PATH
                        path to the SSL certificate for the management server
                        (default: None)
  --admin-private-key PATH
  --admin-ca PATH       path to the CA certificate for the management server
                        (default: None)
```
