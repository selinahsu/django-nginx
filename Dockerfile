# Base Image 
FROM python:3.8.5

# create and set working directory
RUN mkdir /app
WORKDIR /app

# Add current directory code to working directory
# you can use ADD or COPY
ADD . /app/

# set default environment variables
# you can also get environment variables from a .env file using Python's os.environ
ENV PYTHONUNBUFFERED 1
ENV LANG C.UTF-8

# this setting is not encouraged becasue it prevents the installer from opening up dialog boxes when it runs into errors
ENV DEBIAN_FRONTEND=noninteractive 

ENV DEBUG=1

# set project environment variables
# grab these via Python's os.environ
# these are 100% optional here
ENV PORT=8000

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata \
        python3-setuptools \
        python3-pip \
        python3-dev \
        python3-venv \
        git \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# install environment dependencies
RUN pip3 install --upgrade pip 
RUN pip3 install pipenv

# Install project dependencies
RUN pipenv install --skip-lock --dev

EXPOSE 8888
CMD gunicorn cfehome.wsgi:application --bind 0.0.0.0:$PORT