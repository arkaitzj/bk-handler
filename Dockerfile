FROM python:3.10-alpine

WORKDIR /workdir

COPY requirements.txt .

RUN pip install -r ./requirements.txt

COPY ./bk-handler .

ENTRYPOINT [ "./bk-handler"  ]
