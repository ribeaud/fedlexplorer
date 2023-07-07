FROM python:3.11-slim

ENV PYTHONUNBUFFERED 1

COPY ./data/ /app/data/
COPY ./backend/ /app/backend/

WORKDIR /app/data

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r ../backend/requirements.txt

EXPOSE 8000

CMD ["python", "../backend/server.py"]
