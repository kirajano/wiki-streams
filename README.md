## Wikipedia Event Streaming

### Purpose
Use the Wikipeda data stream to address what is happening in Wikipedia and potential of fraudelent / damaging content. Identify topics and domains that are mostly susceptible.

### Description
Track fraudelent (and bot) created content on Wikipedia in real-time.
Wikipedia implements a real-time ML revision algo to understand if changes are damaging or goodfaith.
This real-time data could be used to create a service that reports on: 
* Share of damaging vs. non-damaging content
* Language locales where damaging content is the highest
* Topics that are prone to falsehood from the outside world
* etc...

### Output
A Dashboard or REST Service that is available to be used for returning stats on various params.

### Sources
Wikimedia Data Stream
https://stream.wikimedia.org/?doc#/streams


### Technology Stack
* Streaming --> Conflunent / Kinesis
* Scripting --> Python / Unix
* Reproducability --> Docker
* Service --> AWS Lambda, AWS API Gateway / Azure Equivalent
* Storage --> RS, file.db etc...

### Endpoints
<p>Page: Create, Move, Delete, Link Change, Recent Change<p>
<p>Revision: Create, Score<p><br>

---
#### Data per Endpoint
---

**Recentchange**:
https://stream.wikimedia.org//v2/stream/recentchange 
* Title
* URL
* Language domain
* timestamp
* user_name
* user_comment (comment reason for change)
* user_is_bot (here called "bot")
* bot_type(located user; not new field!)
* type(edit, categorize etc.) --> unique to end-point
* length (article lenght: old and new) --> unique to end-point
* minor change (if it is a minor change) --> unique to end-point

*Sample JSON*
```
"$schema":"/mediawiki/recentchange/1.0.0",
   "meta":{
      "uri":"https://commons.wikimedia.org/wiki/File:DESERT_SCIMITAR_130430-M-OC922-009.jpg",
      "request_id":"1b12bec3-c72e-4451-ae23-bc5742c51343",
      "id":"e195ebcf-e9ff-4179-9591-0d2384b96117",
      "dt":"2021-08-27T13:20:18Z",
      "domain":"commons.wikimedia.org",
      "stream":"mediawiki.recentchange",
      "topic":"codfw.mediawiki.recentchange",
      "partition":0,
      "offset":441362978
   },
   "id":1754327016,
   "type":"edit",
   "namespace":6,
   "title":"File:DESERT SCIMITAR 130430-M-OC922-009.jpg",
   "comment":"add location United States inside Taken On on template",
   "timestamp":1630070418,
   "user":"RudolphousBot",
   "bot":true,
   "minor":true,
   "patrolled":true,
   "length":{
      "old":1132,
      "new":1155
   },
   "revision":{
      "old":585514253,
      "new":586543834
   },
   "server_url":"https://commons.wikimedia.org",
   "server_name":"commons.wikimedia.org",
   "server_script_path":"/w",
   "wiki":"commonswiki",
   "parsedcomment":"add location United States inside Taken On on template"
```

**Revision Create**:
https://stream.wikimedia.org//v2/stream/revision-create 
* Title, URL, Lang Domain, timestamp, user_name, user_is_bot, bot_type(located in user_text), user_comment
* user_group(bot,editor, others)
* user_registration_date
* user_edit_count
* rev_content_changed (if content has been chaned during the revision by the user) --> unique to end-point

*Sample JSON*
```
{
   "$schema":"/mediawiki/revision/create/1.1.0",
   "meta":{
      "uri":"https://meta.wikimedia.org/wiki/MediaWiki:Centralnotice-Election2021_Board_voting_starts_new_new-vote/ba",
      "request_id":"18d52d9e-f74a-4076-b5b0-a8679025099d",
      "id":"d2b4b215-5158-4bb0-aa28-365b6bf94ad4",
      "dt":"2021-08-27T11:49:49Z",
      "domain":"meta.wikimedia.org",
      "stream":"mediawiki.revision-create",
      "topic":"codfw.mediawiki.revision-create",
      "partition":0,
      "offset":269740393
   },
   "database":"metawiki",
   "page_id":11490274,
   "page_title":"MediaWiki:Centralnotice-Election2021_Board_voting_starts_new_new-vote/ba",
   "page_namespace":8,
   "rev_id":21941944,
   "rev_timestamp":"2021-08-27T11:49:48Z",
   "rev_sha1":"6fcwahwaz8kd7flbxurwyzbvbcw4kmr",
   "rev_minor_edit":true,
   "rev_len":21,
   "rev_content_model":"wikitext",
   "rev_content_format":"text/x-wiki",
   "performer":{
      "user_text":"DerHexer",
      "user_groups":[
         "centralnoticeadmin",
         "oauthadmin",
         "oversight",
         "steward",
         "sysop",
         "translationadmin",
         "*",
         "user",
         "autoconfirmed"
      ],
      "user_is_bot":false,
      "user_id":33668,
      "user_registration_dt":"2006-10-14T10:36:59Z",
      "user_edit_count":7790
   },
   "page_is_redirect":false,
   "comment":"Protected \"[[MediaWiki:Centralnotice-Election2021 Board voting starts new new-vote/ba]]\": Automatically protected by CentralNotice; please edit only via [[Special:CentralNotice]] or [[Special:Translate]] ([Edit=Allow only central notice administrators] (indefinite) [Move=Allow only central notice administrators] (indefinite)) [cascading]",
   "parsedcomment":"Protected &quot;<a href=\"/wiki/MediaWiki:Centralnotice-Election2021_Board_voting_starts_new_new-vote/ba\" title=\"MediaWiki:Centralnotice-Election2021 Board voting starts new new-vote/ba\">MediaWiki:Centralnotice-Election2021 Board voting starts new new-vote/ba</a>&quot;: Automatically protected by CentralNotice; please edit only via <a href=\"/wiki/Special:CentralNotice\" title=\"Special:CentralNotice\">Special:CentralNotice</a> or <a href=\"/wiki/Special:Translate\" title=\"Special:Translate\">Special:Translate</a> ([Edit=Allow only central notice administrators] (indefinite) [Move=Allow only central notice administrators] (indefinite)) [cascading]",
   "rev_parent_id":21941943,
   "rev_content_changed":false
}
```

**Revision Score:** 
https://stream.wikimedia.org//v2/stream/revision-score
* Title, URL, Lang Domain, timestamp, user, user_group(bot,editor), user_is_bot, bot_type(see above), user_edit_count, user_registration_date
* ML content quality (mostly wikidata): --> unique to end-point
-- damage_score
-- goodfaith_score 
* ML_topic (mostly wikidata): --> unique to end-point
-- Biography
-- Culture
-- Music
-- etc.
* ML draft_topic (sames as item_topic but flagged as draft) --> unique to end-point

*Sample JSON*
```
{
   "$schema":"/mediawiki/revision/score/2.0.0",
   "meta":{
      "stream":"mediawiki.revision-score",
      "uri":"https://it.wikipedia.org/wiki/Sinfonia_n._3",
      "request_id":"2a40b30f-7b24-4ce3-8c50-a39ad21070d1",
      "id":"05727ba0-0736-11ec-a4e8-af04d934395e",
      "dt":"2021-08-27T12:55:14.266Z",
      "domain":"it.wikipedia.org",
      "topic":"codfw.mediawiki.revision-score",
      "partition":0,
      "offset":152777675
   },
   "database":"itwiki",
   "page_id":3160677,
   "page_title":"Sinfonia_n._3",
   "page_namespace":0,
   "page_is_redirect":false,
   "performer":{
      "user_text":"ValterVB",
      "user_groups":[
         "sysop",
         "*",
         "user",
         "autoconfirmed"
      ],
      "user_is_bot":false,
      "user_id":697352,
      "user_registration_dt":"2011-12-10T18:13:32Z",
      "user_edit_count":76119
   },
   "rev_id":122707501,
   "rev_parent_id":122046357,
   "rev_timestamp":"2021-08-27T12:55:10Z",
   "scores":{
      "damaging":{
         "model_name":"damaging",
         "model_version":"0.5.0",
         "prediction":[
            "false"
         ],
         "probability":{
            "false":0.9880401000905714,
            "true":0.011959899909428638
         }
      },
      "goodfaith":{
         "model_name":"goodfaith",
         "model_version":"0.5.0",
         "prediction":[
            "true"
         ],
         "probability":{
            "false":0.009194563774685416,
            "true":0.9908054362253146
         }
      }
   }
}
```


<br>*(NOT USEFUL FOR NOW)*

**Page Delete** --> Events are more rare and used also for renaming pages
* User name
* timestamp
* comment (reason for deletion)

**Page Create:**  --> Events are more more rare than changes to existing articles
* User
* Timestamp
* comment
* Title
* URI
* Lang Domain
* user_is_bot
* user_edit_count
	
**Domains:** 
Wikipedia, Wikidata, Wikisource, Wikimedia

*Notes on further steps:*
* Prototype Stream Sync (see existing approch from 'same topic' link)
* Check API for categories to lookup (see Daniel's comment)
* Check if user info is available who generate damaging content
* Goodfaith and Damage Model seem to be conflicting (express mutually exclusive predictions)

*Links to same topic:*
* Dahsboard of streaming events https://esjewett.github.io/wm-eventsource-demo/

*Notes from Daniel:*
* DBPedia for categories
* Check the throughput to see if Streaming is necessary

---
### DATA SCOPE DEFINITION
---

**Dimensions Inclusion:**

* Title
* URL
* Language domain
* change_timestamp
* user_name
* user_comment (RCH, RVCR)
* user_is_bot
* change_type (RCH)
* lenght (RCH)
* user_registration_date (RVCR, RSC)
* user_edit_count (RVCR, RSC)
* rev_content_changed (RVCR)
* ML content quality: damage, goodfaith (RSC)


<br>**Possible Inclusion**

* user_group(bot,editor, others; many groups and no info what they mean) (RVCR, RSC)
* bot_type (good candidate but need more information)
* ML item topic: Biography, Culture etc. (RSC)
* ML draft_topic (RSC)
* minor_change (RSC)


---
#### Observation
---

* Matches between endpoints on entry changes but not all
* Revision Create (RSC) and Recentchange share the timestamp
* "request_id" can be used for matching

---
### Architecture
---

1. Batch Stream
<p> Stream is opened up for a <u>defined</u> time. The opening is happening different for RC endpoint and RV endpoints. RC is usually ahead (assumed). The sync term between end points will be dubbed as "catch-up". There are two options to approach "catch-up". First, start RC before RV. Second is start both parallel but have different times - RV should be longer. Which is option is based, is not known.</p>

2. Real Stream
Using local Kafka connect.

---
### Wikipedia EventStreams Architecture
Wikimedia is using Kafka under the hood with a custom build KafkaSSE connector by the Wikipedia.org team. The SSE client is connected to internal Kafka consumers and exposed via HTTP to external clients. More information on Wikimedia EventStreams architecture can be found [here](https://wikitech.wikimedia.org/wiki/Event_Platform/EventStreams).

Kafka Connect is using a custom SSE connector ([kudos cjmatta](https://github.com/cjmatta/kafka-connect-sse)) to stream data into the cluster.

<br>

---

### Kafka Connect

* Connector: Custom SSE Connector
* Converter: Serialization Handlers (writes into key value(bytes))
* Schema: "Contract" between (data)services
* Transforms (optional): used for single message transforms (also used in config format)

Notes:

Define an appropriate schema for endpoint

Schema Registry

How to define a schema for our case

Run through the tutorial

Steps:

Apply transformers

Schema cleanup and setup

Clarify the use of schema registry

Missing fields: bot, id, length, minor, namespace, patrolled, revision, server_name, script_path, server_url, timestamp, title, type, user, wiki

Check where are logs --> Could not configure
Try another connector, Remove fromJSON and try KSQL approach, https://aseigneurin.github.io/2018/08/02/kafka-tutorial-4-avro-and-schema-registry.html