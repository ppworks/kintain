# [#p4dhack](https://twitter.com/?q=#!/search/%23p4dhack)用repository

# local検証用の各種SNSアプリケーションを作成する

## facebook アプリ作成

[facebook DEVELOPERS](https://developers.facebook.com/apps)から作成する。

## twtitter アプリ作成

[twitter developers](https://dev.twitter.com/apps/new)から作成する。

## github アプリ作成

[github Register a new OAuth application](https://github.com/settings/applications/new)

## サーバ起動

### .envの作成

```
touch .env
```

以下を記述

```
RACK_ENV=development
FB_ADMINS=nnnn,mmmm
FB_APP_ID=xxx
FB_APP_SECRET=xxx
GH_APP_ID=yyy
GH_APP_SECRET=yyy
TW_APP=zzz
TW_APP_SECRET=zzz

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
