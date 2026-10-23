$uri = 'http://localhost:5601/api/saved_objects/_export'
$body = '{"type":["dashboard","visualization","index-pattern"],"includeReferencesDeep":true}'
Invoke-WebRequest -Uri $uri -Method Post -Headers @{ 'kbn-xsrf' = 'true' } -ContentType 'application/json' -Body $body -OutFile 'kibana/saved-objects.ndjson'

