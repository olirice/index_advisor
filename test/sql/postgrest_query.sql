begin;

    create extension index_advisor version '0.1.2' cascade;

    create function get_info(x int) returns text language sql as $$ select 'foo' $$;

    select index_advisor($$
        WITH pgrst_source AS (WITH pgrst_payload AS (SELECT $1 AS json_data), pgrst_body AS ( SELECT CASE WHEN json_typeof(json_data) = $4 THEN json_data ELSE json_build_array(json_data) END AS val FROM pgrst_payload), pgrst_args AS ( SELECT * FROM json_to_recordset((SELECT val FROM pgrst_body)) AS _("x" integer) )SELECT "public"."get_info"("x" := (SELECT "x" FROM pgrst_args LIMIT $5)) AS pgrst_scalar) SELECT $6::bigint AS total_result_set, pg_catalog.count(_postgrest_t) AS page_total, coalesce((json_agg(_postgrest_t.pgrst_scalar)->$7)::text, $8) AS body, nullif(current_setting($9, $10), $11) AS response_headers, nullif(current_setting($12, $13), $14) AS response_status FROM (SELECT "get_info".* FROM "pgrst_source" AS "get_info"    LIMIT $2 OFFSET $3) _postgrest_t
    $$);

rollback;
