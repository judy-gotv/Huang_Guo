# Author: Passwd Word
# HGhub 前端静态预览镜像
#
# 本项目是 Tauri 2 桌面/移动应用，前端（src/）全部 API 调用都走 Tauri 的
# invoke() 与 hg:// 自定义协议，只有在 Tauri 壳里才能完整工作。
# 这个镜像只做一件事：把前端 Vite 构建产物用 nginx 静态托管出来，
# 供界面预览 / 静态检查用，不代表桌面端完整功能。
# 完整应用请用仓库自带的 release / build-macos / build-ios 工作流出包。
# syntax=docker/dockerfile:1
FROM node:22-bookworm-slim AS build
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@10 --activate
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .npmrc ./
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
