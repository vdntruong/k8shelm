# --- STAGE 1: Build & Dependencies ---
FROM python:3.11-slim-buster AS builder

# Thiết lập biến môi trường để không tạo cache (giảm kích thước image)
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- STAGE 2: Final Image ---
FROM python:3.11-slim-buster

WORKDIR /app

# Copy Python packages and binaries from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . /app

RUN groupadd -r appuser && useradd -r -g appuser appuser
USER appuser

# Expose port mà Uvicorn sẽ chạy
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
