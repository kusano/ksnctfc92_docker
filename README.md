# ksnctfC92

2017年に開催したCTFの問題とスコアサーバーをローカルで動かせるようにしました。

Docker Hubからダウンロード

```
docker run --rm -it -v ksnctfc92:/home/score/data/ -p 55555:55555 -p 3000:3000 -p 10080:10080 kusanok/ksnctfc92
```

このリポジトリのDockerfileをビルド

```
docker build -t ksnctfc92 .
docker run --rm -it -v ksnctfc92:/home/score/data/ -p 55555:55555 -p 3000:3000 -p 10080:10080 ksnctfc92
```

http://localhost:10080 でスコアサーバーが立ち上がります。

- **当然脆弱性があるので、ポートを外部に公開しないでください**
- 途中経過は`/home/score/data/`にマウントしたボリューム（`ksnctfc92`）に保存されます
  - `docker volume rm ksnctfc92`でボリュームを削除すると途中経過がリセットされます
- libcのバージョンが2017年の開催時とは異なります
  - exploitのコードを修正しないと通らないかもしれません

![screenshot](https://raw.githubusercontent.com/kusano/ksnctfc92_docker/master/screenshot.png)
