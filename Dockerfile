# 使用官方的 Nginx 镜像作为基础镜像
FROM nginx:stable-alpine

# 将项目的打包文件复制到 Nginx 容器的 HTML 目录中
COPY dist/ /usr/share/nginx/html/

# 暴露 80 端口
EXPOSE 80

# 运行 Nginx
CMD ["nginx", "-g", "daemon off;"]