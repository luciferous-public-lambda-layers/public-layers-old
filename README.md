# template-python-lambda-layer-by-terraform
## 概要

- pipモジュールをインストールしたLambda Layerを作成するためのテンプレート
  - Lambda Layerを作成し、SSM ParameterにLayerArnを登録する
- pipモジュールのインストールにはDockerとPoetryを利用する
- AWSへのデプロイにはTerraformを使用する
- Github Actionsを使用してAWSにデプロイするためのワークフロー定義も行っている

## 詳細
### ディレクトリ構成
```
./
├── .github/
│  └── workflows/
│     └── deploy.yml
├── .gitignore
├── build.sh
├── Dockerfile
├── layers/
│  └── base/
│     ├── poetry.lock
│     └── pyproject.toml
├── LICENSE
├── Makefile
├── modules/
│  └── layer/
│     ├── outputs.tf
│     ├── resources.tf
│     ├── terraform.tf
│     └── variables.tf
├── README.md
├── terraform.sample.tfvars
└── terraform.tf
```

- `.github/workflows/deploy.yml`: Github Actionsを使ってデプロイを行うためのワークフロー定義
- `build.sh`: Dockerを使用してpipモジュールをインストールするScript
- `Dockerfile`: pipモジュールをインストールするためのDockerfile
- `layers/**`: レイヤーを定義する。ディレクトリを分けることで複数定義できる
    - `pyproject.toml`: インストールするpipモジュールを管理するのに使う
    - `poetry.lock`: poetryが使用するlockファイル
- `Makefile`: 各種コマンドを定義している
- `modules/layer`: Lambda Layerとそれを参照するためのSSM Parameterを定義するTerraform Module
- `terraform.sample.tfvars`: 使用するtfvarsのサンプル
- `terraform.tf`: Terraform定義

最初から書いている `layers/bases`配下のファイルはサンプル。

### build.shの使い方
```
build.sh --name LAYER_DIR_NAME --arch [amd64|arm64] --runtime-version RUNTIME_VERSION

  --name LAYER_DIR_NAME: directory having pyproject.toml in layers (ex: layers/base)
  --arch [amd64|arm64]: CPU architecture
  --runtime-version RUNTIME_VERSION: use python runtime version (default: 3.12) (ex: 3.12, 3.10)
```

DockerとPoetryを使ってpipモジュールをインストールする。

- `--name`でpyproject.tomlとpoetry.lockファイルがあるディレクトリを指定 (ここに`python/`ディレクトリが作成されその中にpipモジュールがインストールされる)
- `--arch`でCPUアーキテクチャを指定
- `--runtime-version`でLambdaのPython Runtimeのバージョンを指定する (指定がなければ `3.12`を使用する)
