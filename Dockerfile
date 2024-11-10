FROM python:3.12-alpine AS tabby-connection-gateway

WORKDIR /app

COPY . /app
RUN pip install -r requirements.txt && \
  python setup.py install

ENTRYPOINT ["python", "-m", "tabby_connection_gateway.cli"]
