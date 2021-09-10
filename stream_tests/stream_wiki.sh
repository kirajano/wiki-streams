#!/usr/bin/env bash

curl -s "https://stream.wikimedia.org/v2/stream/revision-score" | sample -s $1 > wiki_revision_score.json &
curl -s "https://stream.wikimedia.org/v2/stream/recentchange" | sample -s $2 > wiki_recentchange.json &
curl -s "https://stream.wikimedia.org/v2/stream/revision-create" | sample -s $1 > wiki_revision_create.json &
wait
echo "Done"
