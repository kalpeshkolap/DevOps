FROM python:3.12.3-alpine3.20
RUN apk add mysql mysql-client gcc musl-dev mariadb-connector-c-dev
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
WORKDIR /code
RUN pip install --upgrade pip && pip install -r requirements.txt
COPY ./requirements.txt /code/
COPY . .
EXPOSE 8000
CMD  python manage.py runserver 0.0.0.0:8000
