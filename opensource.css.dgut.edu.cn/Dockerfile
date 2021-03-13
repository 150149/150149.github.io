FROM jekyll/builder as build
WORKDIR /tmp
COPY . /tmp

RUN addgroup oss && adduser -D -G oss oss && chown -R oss:oss .
RUN chown -R oss:oss /usr/gem
USER oss
## 定义ruby镜像源
## https://gems.ruby-china.com/
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
RUN bundle install
RUN npm install
RUN npm rebuild node-sass
RUN ./node_modules/gulp/bin/gulp.js build
RUN jekyll build

FROM nginx:alpine
COPY --from=build /tmp/_site /usr/share/nginx/html

## 在主机构建时，非常慢，解决方法如下：
## 先在Centos中安装nodejs
## curl -sL https://rpm.nodesource.com/setup_lts.x | bash -
## yum -y install nodejs
## 然后，在远程主机的本项目的git目录下，先 npm install , 这样原git目录下就会生成node_model目录，相当于缓存。
## 在安装pngquant-bin@5.0.2时，提示失败，要先安装 libpng-dev
## yum install libpng-devel
## 再 npm install , 成功

## 经上面的步骤，又发生下面的问题：
## RUN ./node_modules/gulp/bin/gulp.js build 这一步出现异常。
## 提示如下：
#Error: Missing binding /tmp/node_modules/node-sass/vendor/linux_musl-x64-72/binding.node
#Node Sass could not find a binding for your current environment: Linux/musl 64-bit with Node.js 12.x
#Found bindings for the following environments:
#  - Linux 64-bit with Node.js 12.x
#This usually happens because your environment has changed since running `npm install`.
#Run `npm rebuild node-sass` to download the binding for your current environment.

## 问题原因，我们为了加快构建速度在部署主机Centos Linux上提前npm install，而在docker build阶段，在jekyll/builder镜像中npm install时，操作系统不一样，导致上面的异常。
## 解决方法，根据异常提示，我们在jekyll/builder镜像中，重新执行npm rebuild node-sass
## 在dockerfile脚本中，npm install 后，加多一句 npm rebuild node-sass , 解决npm install后，系统环境改变后产生的问题。