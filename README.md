# Централизованное логирование

Spring Boot пишет структурированные JSON-события в `logs/application.json`. Filebeat читает этот файл и передаёт записи в Logstash, который отправляет их в Elasticsearch. Kibana автоматически получает data view и dashboard при запуске стека.

## Запуск

Нужны JDK 21, Maven и Docker Engine с Docker Compose.

```bash
mvn clean package -DskipTests
docker compose up --build -d
```

После запуска откройте `http://localhost:5601`. Kibana откроет dashboard с последними событиями. Для тестового события выполните:

```bash
curl "http://localhost:8080/logs/sample?message=first-event"
```

Новые записи автоматически попадают в `logs/application.json`, Elasticsearch и dashboard Kibana. Первичная настройка при первом запуске может занять несколько минут.

## Состав стека

- Spring Boot и `logstash-logback-encoder` формируют JSON-логи.
- Filebeat использует `filestream` и NDJSON parser.
- Logstash принимает события Beats и индексирует их как `springboot-*`.
- Elasticsearch сохраняет данные в bind volume `elasticsearch-data/`.
- Kibana импортирует data view, сохранённый поиск и dashboard из `kibana/saved-objects.ndjson`.

Сохранённые объекты также можно экспортировать из работающей Kibana:

```powershell
./scripts/export-kibana-objects.ps1
```

Не используйте `docker compose down -v`, если хотите сохранить состояние Elasticsearch. Чтобы остановить сервисы без удаления данных, выполните `docker compose down`.

## Проверка

GitHub Actions собирает приложение, запускает ELK-стек в Docker Compose, создаёт тестовое событие и проверяет его появление в Elasticsearch, а также автоматически созданные data view и dashboard в Kibana.
