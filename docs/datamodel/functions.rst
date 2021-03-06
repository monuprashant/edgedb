.. _ref_datamodel_functions:

=========
Functions
=========


Functions are ways to transform one set of data into another.  They
are defined in :ref:`modules <ref_datamodel_modules>` and are part of
the database schema.

For example, consider the :ref:`function <ref_eql_funcops>`
:eql:func:`len` used to transform a set of :eql:type:`str` into a set
of :eql:type:`int64`:

.. code-block:: edgeql-repl

    db> SELECT len({'hello', 'world'});
    {5, 5}

Compare that with the :ref:`aggregate <ref_eql_fundamentals_aggregates>`
function :eql:func:`count` that transforms a set of :eql:type:`str`
into a single :eql:type:`int64` value, representing the set
cardinality:

.. code-block:: edgeql-repl

    db> SELECT count({'hello', 'world'});
    {2}


See Also
--------

Function
:ref:`SDL <ref_eql_sdl_functions>`,
:ref:`DDL <ref_eql_ddl_functions>`,
and :ref:`introspection <ref_eql_introspection_functions>`.
