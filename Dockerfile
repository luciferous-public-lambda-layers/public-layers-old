ARG RUNTIME_VERSION=3.12

FROM public.ecr.aws/sam/build-python${RUNTIME_VERSION}:latest as generate-requirements-txt

WORKDIR /tmp
ADD pyproject.toml /tmp/pyproject.toml
ADD poetry.lock /tmp/poetry.lock

RUN pip install poetry
RUN poetry export > requirements.txt

FROM public.ecr.aws/sam/build-python${RUNTIME_VERSION}:latest
RUN mkdir /tmp/layer
WORKDIR /tmp/layer
COPY --from=generate-requirements-txt \
    /tmp/requirements.txt \
    /tmp/layer/requirements.txt

CMD ["pip", "install", "-r", "requirements.txt", "-t", "python"]

