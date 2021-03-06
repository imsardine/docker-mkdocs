FROM python:3.6

WORKDIR /workspace
COPY . /workspace

RUN pip install pipenv==2018.10.13 \
    && pipenv install --deploy --system \
    && rm -rf *

ENTRYPOINT ["mkdocs"]
