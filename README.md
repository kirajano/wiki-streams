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

**Revision Create**:
https://stream.wikimedia.org//v2/stream/revision-create 
* Title, URL, Lang Domain, timestamp, user_name, user_is_bot, bot_type(located in user_text), user_comment
* user_group(bot,editor, others)
* user_registration_date
* user_edit_count
* rev_content_changed (if content has been chaned during the revision by the user) --> unique to end-point

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

