#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "faker",
# ]
# ///

import os
from faker import Faker
import random
import sqlite3
import json
from datetime import datetime

# Initialize Faker
fake = Faker()

# Connect to SQLite database
conn = sqlite3.connect("development.db")
cursor = conn.cursor()

# Define content types and statuses
content_types = ["note", "article", "blogmark", "comment", "quotation"]
statuses = ["draft", "published", "archived"]
categories = ["programming", "work", "hobby", "travel", "food"]

# Generate 100 entries
for _ in range(100):
    content_type = random.choice(content_types)
    title = fake.sentence(nb_words=6) if content_type != "note" else None
    content = fake.paragraph(nb_sentences=5)
    link = fake.url() if content_type in ["article", "blogmark"] else None
    rank = random.randint(0, 100)
    timestamp = datetime.now().isoformat(" ")
    retracted_at = None # timestamp if random.random() < 0.1 else None
    retracted_notes = None # fake.sentence() if retracted_at else None
    via_url = fake.url() if random.random() < 0.3 else None
    via_notes = "via"
    format_ = "markdown"
    status = random.choice(statuses)
    metadata = json.dumps({"source": fake.word(), "views": random.randint(1, 1000)})
    photo_url = fake.image_url() if random.random() < 0.2 else ""
    photo_caption = fake.sentence() if photo_url else None
    private_notes = fake.sentence() if random.random() < 0.2 else None
    shortcode = fake.unique.uuid4()[:8]
    cssclasses = ' '.join([fake.word() for w in range(0,random.randint(1,3))])

    # Insert into entry table
    cursor.execute("""
        INSERT INTO entry (
            content_type, title, content, link, rank,
            created_at, updated_at, published_at, happened_at,
            retracted_at, retracted_notes, via_url, via_notes,
            format, status, metadata,
            photo_url, photo_caption, private_notes, shortcode, cssclasses
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        content_type, title, content, link, rank,
        timestamp, timestamp, timestamp, timestamp,
        retracted_at, retracted_notes, via_url, via_notes,
        format_, status, metadata,
        photo_url, photo_caption, private_notes, shortcode, cssclasses
    ))

conn.commit()
conn.close()
