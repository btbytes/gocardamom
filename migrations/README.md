# Database migrations using goose

```bash
$ goose sqlite3 development.db create create_entries sql
```

## Running migrations

To run migrations, execute the following command:

```bash
$ goose sqlite3 ../development.db up
```
