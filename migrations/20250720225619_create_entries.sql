-- +goose Up
-- +goose StatementBegin
create table if not exists entry (
id integer primary key autoincrement,
parent_id integer references entries (id) null,
-- type of content (note, article, blogmark, comment, quotation)
content_type text default 'note',
title text,
content text not null,
link text, -- a url
rank integer default 0,
created_at timestamp default current_timestamp,
updated_at timestamp default current_timestamp,
published_at timestamp default current_timestamp,
happened_at timestamp default current_timestamp,
retracted_at timestamp default current_timestamp,
retracted_notes text,
via_url text,
via_notes text default 'via',
format text default 'markdown',
status text default 'draft', -- status of the entry
metadata json default '{}',
photo_url text default '',
photo_caption text,
private_notes text,
shortcode text unique,
cssclasses text default ''
) ;

-- content-type: quotation
-- content = quotation
-- source = via_notes
-- source_url = via_url

CREATE VIRTUAL TABLE fts_entry USING FTS5 (title, content) ;

create table category (
id integer primary key autoincrement,
name text not null,
slug text not null,
content text not null
) ;

CREATE TABLE entry_category (
entry_id INTEGER NOT NULL,
category_id INTEGER NOT NULL,
PRIMARY KEY (entry_id, category_id),
FOREIGN KEY (entry_id) REFERENCES entry (id) ON DELETE CASCADE,
FOREIGN KEY (category_id) REFERENCES tag (id) ON DELETE CASCADE
) ;

create table tag (
id integer primary key autoincrement,
name text not null,
slug text not null,
content text not null
) ;
CREATE TABLE entry_tag (
entry_id INTEGER NOT NULL,
tag_id INTEGER NOT NULL,
PRIMARY KEY (entry_id, tag_id),
FOREIGN KEY (entry_id) REFERENCES entry (id) ON DELETE CASCADE,
FOREIGN KEY (tag_id) REFERENCES tag (id) ON DELETE CASCADE
) ;

create table series (
id integer primary key autoincrement,
name text not null,
slug text not null,
content text not null
) ;

create table series_entry (
rank INTEGER NOT NULL,
series_id INTEGER NOT NULL,
entry_id INTEGER NOT NULL,
PRIMARY KEY (series_id, entry_id),
FOREIGN KEY (series_id) REFERENCES series (id) ON DELETE CASCADE,
FOREIGN KEY (entry_id) REFERENCES entry (id) ON DELETE CASCADE
) ;

create table entry_connection (
entry_id INTEGER NOT NULL,
connected_entry_id INTEGER NOT NULL,
connection_name text not null,
PRIMARY KEY (entry_id, connected_entry_id),
FOREIGN KEY (entry_id) REFERENCES entry (id) ON DELETE CASCADE,
FOREIGN KEY (connected_entry_id) REFERENCES entry (id) ON DELETE CASCADE
) ;

create table datalog (
id integer primary key autoincrement,
action text not null,
timestamp timestamp default current_timestamp,
data json default '{}'
) ;
create index datalog_action_idx on datalog (action) ;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
drop table if exists fts_entry ;
drop table if exists entry_connection ;
drop table if exists entry_category ;
drop table if exists entry_tag ;
drop table if exists series_entry ;
drop table if exists series ;
drop table if exists tag ;
drop table if exists category ;
drop table if exists entry ;
drop table if exists datalog ;
-- +goose StatementEnd
