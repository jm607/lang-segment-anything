FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV GRADIO_SERVER_NAME="0.0.0.0"

# 1) python3/pip 설치 + 기본 도구 + OpenCV 런타임 의존성
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      python3 \
      python3-pip \
      python3-venv \
      openssh-client \
      build-essential \
      git \
      libgl1 \
      libglib2.0-0 \
      libsm6 \
      libxext6; \
    rm -rf /var/lib/apt/lists/*; \
    # 2) python3 동작 확인 및 pip 업그레이드
    which python3; python3 --version; \
    python3 -m pip --version || true; \
    python3 -m pip install --upgrade --no-cache-dir pip; \
    python3 -m pip --version

# Install necessary packages
# 3) 앱 복사 및 의존성 설치
WORKDIR /lang-segment-anything
COPY . /lang-segment-anything

#RUN pip install -r requirements.txt
RUN python3 -m pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Entry point
CMD ["python3", "app.py"]
