# 12) The library of the university needs to implement a relational database that meets the following requirements:
[Solution](SOLVED.md)

The library allows to access to research articles published in several international journals. Each article has associated a DOI (Digital Object Identifier), a title, a set of keywords, the authors and the journal in which the article has been published.

Each article has associated at most 4 authors. Each author is identified by an email address. We also need to register the name and the affiliation of the authors. Both, the email address and the affiliation associated to an author in different articles can be different.

The journals are identified by the ISSN (International Standard Serial Number). A journal publishes different volumes periodically. Each volume has associated a unique number and the month and the year in which it has been published. Different journals can publish volumes that have associated the same number, month and year. We also need to store in the database the volume of the journal in which it has been published.

Finally, each journal is published by an editorial that has associated a name that identified it. The editorial can publish several journals.

