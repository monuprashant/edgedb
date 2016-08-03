CREATE SCHEMA edgedb;

SET search_path = edgedb;

DROP SCHEMA public;


CREATE EXTENSION hstore WITH SCHEMA edgedb;
CREATE EXTENSION "uuid-ossp" WITH SCHEMA edgedb;


CREATE DOMAIN known_record_marker_t AS text;


CREATE AGGREGATE agg_product(double precision) (
    SFUNC = float8mul,
    STYPE = double precision,
    INITCOND = '1'
);


CREATE AGGREGATE agg_product(numeric) (
    SFUNC = numeric_mul,
    STYPE = numeric,
    INITCOND = '1'
);


CREATE TABLE object (
    id serial NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE
);


CREATE TABLE module (
    schema_name text NOT NULL,
    imports character varying[],

    PRIMARY KEY (id)
) INHERITS (object);


CREATE TABLE delta (
    module_id integer NOT NULL REFERENCES module(id),
    parents character varying[],
    deltabin bytea NOT NULL,
    deltasrc text NOT NULL,
    checksum character varying NOT NULL,
    commitdate timestamp with time zone DEFAULT now() NOT NULL,
    comment text,

    PRIMARY KEY (id)
) INHERITS (object);


CREATE TABLE primaryobject (
    is_abstract boolean DEFAULT false NOT NULL,
    is_final boolean DEFAULT false NOT NULL,
    title hstore,
    description text,

    PRIMARY KEY (id)
)
INHERITS (object);


CREATE TABLE function (
    paramtypes jsonb,
    paramkinds jsonb,
    paramdefaults jsonb,
    returntype integer,

    PRIMARY KEY (id),
    UNIQUE (name)
)
INHERITS (primaryobject);


CREATE TABLE action (
    PRIMARY KEY (id)
)
INHERITS (primaryobject);


CREATE TABLE inheritingobject (
    bases integer[]
)
INHERITS (primaryobject);


CREATE TABLE atom (
    constraints hstore,
    "default" text,
    attributes hstore,

    PRIMARY KEY (id)
)
INHERITS (inheritingobject);


CREATE TABLE attribute (
    type bytea NOT NULL,

    PRIMARY KEY (id)
)
INHERITS (inheritingobject);


CREATE TABLE attribute_value (
    subject integer NOT NULL,
    attribute integer NOT NULL,
    value bytea,

    PRIMARY KEY (id)
)
INHERITS (primaryobject);


CREATE TABLE concept (
    PRIMARY KEY (id)
)
INHERITS (inheritingobject);


CREATE TABLE "constraint" (
    subject integer,
    expr text,
    subjectexpr text,
    localfinalexpr text,
    finalexpr text,
    errmessage text,
    paramtypes hstore,
    inferredparamtypes hstore,
    args bytea
)
INHERITS (inheritingobject);


CREATE TABLE event (
)
INHERITS (inheritingobject);


CREATE TABLE link (
    source integer,
    target integer,
    mapping character(2) NOT NULL,
    exposed_behaviour text,
    required boolean DEFAULT false NOT NULL,
    readonly boolean DEFAULT false NOT NULL,
    loading text,
    "default" text,
    constraints hstore,
    abstract_constraints hstore,
    spectargets text[]
)
INHERITS (inheritingobject);


CREATE TABLE link_property (
    source integer,
    target integer,
    required boolean DEFAULT false NOT NULL,
    readonly boolean DEFAULT false NOT NULL,
    loading text,
    "default" text,
    constraints hstore,
    abstract_constraints hstore
)
INHERITS (inheritingobject);


CREATE TABLE policy (
    subject integer NOT NULL,
    event integer,
    actions integer[]
)
INHERITS (primaryobject);

SET search_path = DEFAULT;


CREATE TABLE feature (
    name text NOT NULL,
    class_name text NOT NULL
);


CREATE TABLE backend_info (
    format_version integer NOT NULL
);


INSERT INTO backend_info (format_version) VALUES (30);