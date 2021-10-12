#!/usr/bin/env bash

cat wiki_recentchange.json | sed -n "s/^data: //p" | jq "select(.meta.domain == 'en.wikipedia.org') | .meta.uri" | sort > recentchange_uris
echo "Recent_Change URIs $(cat recentchange_uris | wc -l)"

cat wiki_revision_score.json | sed -n "s/^data: //p" | jq 'select(.meta.domain == "en.wikipedia.org") | .meta.uri' | sort > revision_score_uris
echo "Revision_Score URIs $(cat revision_score_uris | wc -l)"

cat wiki_revision_create.json | sed -n "s/^data: //p" | jq 'select(.meta.domain == "en.wikipedia.org") | .meta.uri' | sort > revision_create_uris
echo "Revision_Create URIs $(cat revision_create_uris | wc -l)"

echo "Returning Matching URIs"
echo "Matching URIs: Recent_Change & Revision_Score $(comm -12 recentchange_uris revision_score_uris | wc -l)"
#echo "Same with grep $(grep -f recentchange_uris revisionscore_uris | wc -l)"

echo "Matching URIs: Recent_Change & Revision_Create $(comm -12 recentchange_uris revision_create_uris | wc -l)"

echo "Matching UIRs: Revision_Score & Revision_Create $(comm -12 revision_score_uris revision_create_uris | wc -l)"
#rm recentchange revisionscore revisioncreate



