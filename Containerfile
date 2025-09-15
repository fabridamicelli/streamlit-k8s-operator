FROM python:3.13-slim
WORKDIR /app

COPY pyproject.toml .
RUN pip install uv
RUN uv pip install --system -r pyproject.toml

COPY . .

EXPOSE 8501

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
