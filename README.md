# govuk-graphql

This is a proof of concept [GraphQL][graphql] API for GOV.UK.

It uses [Publishing API][publishing_api]'s database to efficiently serve the content needed to render pages on GOV.UK.

The goal of this implementation is to be as fast as possible, at all costs. This means that the
code uses some unfamiliar technology, and is at times harder to understand than other implementations,
but it is also (much) faster.

This allows us to set a lower bound on what's possible in terms of performance, so that we can make
an informed decision on the trade off between code readability and performance.

## Technologies

Like other proof of concepts, we use [graphql-ruby][graphql_ruby] as the main library to implement the GraphQL API.

We use the [Sequel][sequel] ORM instead of ActiveRecord, because the heart of this implementation is a complex SQL
query which is difficult to construct using ActiveRecord.

Rather than requesting one edition at a time from the database, or batching requests up using a dataloader,
this implementation:

- walks the graphql request using lookahead
- works out which link type paths are needed to resolve the request
- uses a single SQL query to fetch all the editions needed to resolve the request

The resulting SQL query is complex, but initial testing suggests that its performance is very good.

<details>
<summary>The recursive SQL query used (2025-02-06)</summary>

```sql
WITH RECURSIVE
"link_type_paths" AS (
  SELECT trim_array(path, 1) as path, path[array_upper(path, 1)] as next
  FROM json_to_recordset($1) AS paths(path text[])
),
"reverse_link_type_paths" AS (
  SELECT trim_array(path, 1) as path, path[array_upper(path, 1)] as next
  FROM json_to_recordset($2) AS paths(path text[])
),
"edition_links" AS (
  SELECT 'root' AS "type", '{}'::text[] AS "path", ARRAY["editions"."id"]::int[] AS "id_path", "documents"."content_id" AS "content_id", "editions"."id" AS "edition_id", "editions".*
  FROM "editions"
  INNER JOIN "documents" ON ("documents"."id" = "editions"."document_id")
  WHERE (("state" = 'published') AND ("locale" = 'en') AND ("base_path" = $3)
)
UNION ALL (
    WITH "edition_links" AS (SELECT * FROM "edition_links")
    SELECT 'forward edition' AS "type", ("edition_links"."path" || "link_type") AS "path", ("edition_links"."id_path" || "editions"."id") AS "id_path", "documents"."content_id" AS "content_id", "editions"."id" AS "edition_id", "editions".*
    FROM "edition_links"
    INNER JOIN "link_type_paths" ON ("link_type_paths"."path" = "edition_links"."path")
    INNER JOIN "links" ON (("links"."edition_id" = "edition_links"."edition_id") AND ("links"."link_type" = "link_type_paths"."next"))
    INNER JOIN "documents" ON (("documents"."content_id" = "links"."target_content_id") AND ("documents"."locale" = 'en'))
    INNER JOIN "editions" ON (("editions"."document_id" = "documents"."id") AND ("editions"."state" = 'published')
  )
  UNION ALL (
    SELECT 'reverse edition' AS "type", ("edition_links"."path" || "link_type") AS "path", ("edition_links"."id_path" || "editions"."id") AS "id_path", "documents"."content_id" AS "content_id", "editions"."id" AS "edition_id", "editions".*
    FROM "edition_links"
    INNER JOIN "reverse_link_type_paths" ON ("reverse_link_type_paths"."path" = "edition_links"."path")
    INNER JOIN "links" ON (("links"."target_content_id" = "edition_links"."content_id") AND ("links"."link_type" = "reverse_link_type_paths"."next"))
    INNER JOIN "editions" ON (("editions"."id" = "links"."edition_id") AND ("editions"."state" = 'published'))
    INNER JOIN "documents" ON (("documents"."id" = "editions"."document_id") AND ("documents"."locale" = 'en'))
  )
  UNION ALL (
    SELECT 'forward link set' AS "type", ("edition_links"."path" || "link_type") AS "path", ("edition_links"."id_path" || "editions"."id") AS "id_path", "documents"."content_id" AS "content_id", "editions"."id" AS "edition_id", "editions".*
    FROM "edition_links"
    INNER JOIN "link_type_paths" ON ("link_type_paths"."path" = "edition_links"."path")
    INNER JOIN "link_sets" ON ("link_sets"."content_id" = "edition_links"."content_id")
    INNER JOIN "links" ON (("links"."link_set_id" = "link_sets"."id") AND ("links"."link_type" = "link_type_paths"."next"))
    INNER JOIN "documents" ON (("documents"."content_id" = "links"."target_content_id") AND ("documents"."locale" = 'en'))
    INNER JOIN "editions" ON (("editions"."document_id" = "documents"."id") AND ("editions"."state" = 'published'))
  )
  UNION ALL (
    SELECT 'reverse link set' AS "type", ("edition_links"."path" || "link_type") AS "path", ("edition_links"."id_path" || "editions"."id") AS "id_path", "documents"."content_id" AS "content_id", "editions"."id" AS "edition_id", "editions".*
    FROM "edition_links"
    INNER JOIN "reverse_link_type_paths" ON ("reverse_link_type_paths"."path" = "edition_links"."path")
    INNER JOIN "links" ON (("links"."target_content_id" = "edition_links"."content_id") AND ("links"."link_type" = "reverse_link_type_paths"."next"))
    INNER JOIN "link_sets" ON ("link_sets"."id" = "links"."link_set_id")
    INNER JOIN "documents" ON (("documents"."content_id" = "link_sets"."content_id") AND ("documents"."locale" = 'en'))
    INNER JOIN "editions" ON (("editions"."document_id" = "documents"."id") AND ("editions"."state" = 'published')))
  )
)
SELECT * FROM "edition_links"
```

</details>

## Approach

This implementation takes a slightly different approach to the GraphQL schema.

The goal is still to be able to produce responses which are compatible with content-store. However,
the schema is designed to be a bit more flexible, allowing queries for arbitrary link types in both forward and reverse
directions.

Specifically, rather than having an explicit field for `level_one_taxons`, and the implementation knowing that this
is actually a reverse link of type `root_taxon`, the schema has a `links_of_type` field which has arguments to specify
the link type and direction. We can use graphql aliases to make the query look like the content-store response.

```graphql
# Instead of:
level_one_taxons {
  base_path
  content_id
  details
  document_type
  ...
}

# We have:
level_one_taxons: links_of_type(type: "root_taxon", reverse: true) {
  base_path
  content_id
  details
  document_type
  ...
}
```

A more complete query (for the GOV.UK homepage) might look like this:

```graphql
query homepage {
  edition(base_path: "/") {
    analytics_identifier
    base_path
    content_id
    description
    details
    document_type
    first_published_at

    links {
      level_one_taxons: links_of_type(type: "root_taxon", reverse: true) {
        base_path
        content_id
        details
        document_type
      }
      primary_publishing_organisation: links_of_type(type: "primary_publishing_organisation") {
        base_path
        title
        details
        document_type
      }
    }

    phase
    public_updated_at
    publishing_app
    publishing_request_id
    rendering_app
    schema_name
    title
    updated_at
  }
}
```

## Where to look at the code?

The big scary SQL query is in `app/graphql/resolvers/expanded_edition_resolver.rb`.

The code to walk the graphql loookahead and build link type paths, and the code to build a tree from
the database results is in `lib/tasks/path_tree_helpers.rb`.


<!-- References -->
[graphql]: https://graphql.org/
[publishing_api]: https://github.com/alphagov/publishing-api
[graphql_ruby]: https://graphql-ruby.org/
[sequel]: https://sequel.jeremyevans.net/

