FROM python:3.6-alpine
LABEL maintainer="Lyes Ameddah"

WORKDIR /opt

COPY ./static /opt/static/
COPY ./templates/ /opt/templates/
COPY ./app.py /opt/ 

RUN pip install Flask

EXPOSE 8080

# ODOO_URL and PGADMIN_URL : to be used as args in docker run command.
# ENV ODOO_URL=https://odoo.com
# ENV PGADMIN_URL=https://pgadmin.org


ENTRYPOINT [ "python", "app.py" ]