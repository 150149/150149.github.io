#!/usr/bin/env bash
docker run -d --name css-opensource --restart=always -p 56621:80 css-opensource:latest-alpine

## 在华为云的ECS的安全组中开放 56621 端口 ;
## 再在nginx.css设置 opensource.css.dgut.edu.cn 的域名影射。

## 测试 5