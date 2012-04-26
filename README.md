# [#p4dhack](https://twitter.com/?q=#!/search/%23p4dhack)用repository


## サーバ起動

### .envの作成

```
touch .env
```

以下を記述

```
RACK_ENV=development
```

### 起動

```
foreman start
```

```http://localhost:5000``` にアクセスする


## test 実行

```
bundle exec guard
```
