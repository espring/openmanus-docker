# 使用官方Python基础镜像
FROM python:3.12-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    git \
    && rm -rf /var/lib/apt/lists/*
    
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libdbus-1-3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libdrm2 \
    libxkbcommon0 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install --no-cache-dir uv

ENV PATH="/root/.cargo/bin:${PATH}"

# 克隆项目仓库
RUN git clone https://github.com/mannaandpoem/OpenManus.git /app
WORKDIR /app

RUN sed -i 's/headless=False/headless=True/g' /app/app/tool/browser_use_tool.py

# 创建虚拟环境并安装依赖
RUN uv venv && \
    . .venv/bin/activate && \
    uv pip install -r requirements.txt && \
    pip install playwright && \
    python -m playwright install 

# 设置环境变量
# 初始化配置文件
#RUN cp config/config.example.toml config/config.toml && \
#    sed -i 's/api_key = ".*"/api_key = "YOUR_API_KEY"/g' config/config.toml

# 设置容器启动命令
CMD ["bash", "-c", "source .venv/bin/activate && python main.py"]