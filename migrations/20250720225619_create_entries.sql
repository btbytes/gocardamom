-- +goose Up
-- +goose StatementBegin
create table if not exists entries (
id integer primary key autoincrement,
parent_id integer references entries (id) null,
-- type of content (note, article, blogmark, comment)
content_type text default 'note',
title text,
content text not null,
link text, -- a url
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
category text default '',
tags text default '[]',
photo_url text default '',
photo_caption text,
private_notes text,
slug text not null,
cssclasses text default ''
) ;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
drop table if exists entries ;
-- +goose StatementEnd
