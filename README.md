# Централизованное логирование

Spring Boot приложение пишет JSON-логи в `logs/application.json`. Filebeat читает файл и отправляет события в Logstash, который индексирует их в Elasticsearch. Kibana доступна на порту `5601`.

Для запуска нужны JDK 21, Maven и Docker Engine:

```bash
mvn clean package -DskipTests
docker compose up --build -d
```

Создайте событие и проверьте файл логов:

```bash
curl "http://localhost:8080/logs/sample?message=first-event"
Get-Content logs/application.json -Tail 5
```

Откройте `http://localhost:5601`, создайте data view `springboot-*` с полем времени `@timestamp`, затем создайте сохранённый поиск и dashboard для поля `message`. Сохранённые объекты Kibana хранятся в данных Elasticsearch, подключённых через `elasticsearch-data/`.

Для экспорта конфигурации Kibana выполните:

```powershell
./scripts/export-kibana-objects.ps1
```

Файл `kibana/saved-objects.ndjson` можно импортировать через Saved Objects в Kibana. Не используйте `docker compose down -v`, если хотите сохранить данные Elasticsearch.

