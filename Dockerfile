# ベースイメージの指定
FROM python:3.11.4-slim

# 作業ディレクトリの設定
WORKDIR /app

# 依存関係のインストール
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Tesseractをインストール
RUN apt-get update && \
    apt-get install -y tesseract-ocr && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# PATH環境変数の更新
ENV PATH="/opt/homebrew/bin:${PATH}"

# アプリケーションのコピー
COPY new_env /app/new_env
COPY src /app/src

# ポートの公開
EXPOSE 8000

# アプリケーションの起動
CMD ["gunicorn", "src.view:app", "-w", "4", "-b", "0.0.0.0:8000"]