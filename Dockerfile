# 使用 kasmweb/chrome 作为基础镜像
FROM kasmweb/chrome:1.16.1

# 确保以 root 用户身份执行后续命令
USER root

# 设置语言环境变量，实现中文支持
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 更新系统并安装中文语言包与字体
RUN apt-get update && apt-get install -y \
    language-pack-zh-hans \
    fonts-wqy-zenhei \
    && rm -rf /var/lib/apt/lists/*

# 创建 Chrome 配置目录
RUN mkdir -p /home/kasm-user/.config/google-chrome/Default

# 配置 Chrome 接受中文语言
RUN echo '{ "intl": { "accept_languages": "zh-CN,zh" } }' > /home/kasm-user/.config/google-chrome/Default/Preferences

# 更改配置目录的所有者和所属组
RUN chown -R kasm-user:kasm-user /home/kasm-user/.config

# 切换回默认用户
USER kasm-user

# 定义用于持久化存储 Chrome 数据的挂载点
VOLUME /home/kasm-user/.config/google-chrome
