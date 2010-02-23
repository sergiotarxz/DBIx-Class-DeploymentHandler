#!perl

use Test::More;

use lib 't/lib';
use DBICTest;
use DBIx::Class::DeploymentHandler;

my $sql_dir = 't/sql';

VERSION1: {
	use_ok 'DBICVersion_v1';
	my $s = DBICVersion::Schema->connect('dbi:SQLite::memory:');
	ok($s, 'DBICVersion::Schema 1.0 instantiates correctly');
	my $handler = DBIx::Class::DeploymentHandler->new({
		schema => $s,
	});

	ok($handler, 'DBIx::Class::DeploymentHandler w/1.0 instantiates correctly');

	my $version = $s->schema_version();
	$handler->create_ddl_dir( 'SQLite', $version, $sql_dir, 0);
	ok(-e 't/sql/DBICVersion-Schema-1.0-SQLite.sql', 'DDL for 1.0 got created successfully');
}

VERSION2: {
	use_ok 'DBICVersion_v2';
	my $s = DBICVersion::Schema->connect('dbi:SQLite::memory:');
	ok($s, 'DBICVersion::Schema 2.0 instantiates correctly');
	my $handler = DBIx::Class::DeploymentHandler->new({
		schema => $s,
	});

	ok($handler, 'DBIx::Class::DeploymentHandler w/2.0 instantiates correctly');

	$version = $s->schema_version();
	$handler->create_ddl_dir( 'SQLite', $version, $sql_dir, 0);
	$handler->create_ddl_dir( 'SQLite', $version, $sql_dir, '1.0');
	ok(-e 't/sql/DBICVersion-Schema-2.0-SQLite.sql', 'DDL for 2.0 got created successfully');
	ok(-e 't/sql/DBICVersion-Schema-1.0-2.0-SQLite.sql', 'DDL for migration from 1.0 to 2.0 got created successfully');
}

VERSION3: {
	use_ok 'DBICVersion_v3';
	my $s = DBICVersion::Schema->connect('dbi:SQLite::memory:');
	ok($s, 'DBICVersion::Schema 3.0 instantiates correctly');
	my $handler = DBIx::Class::DeploymentHandler->new({
		schema => $s,
	});

	ok($handler, 'DBIx::Class::DeploymentHandler w/3.0 instantiates correctly');

	$version = $s->schema_version();
	$handler->create_ddl_dir( 'SQLite', $version, $sql_dir, 0);
	$handler->create_ddl_dir( 'SQLite', $version, $sql_dir, '1.0');
	$handler->create_ddl_dir( 'SQLite', $version, $sql_dir, '2.0');
	ok(-e 't/sql/DBICVersion-Schema-3.0-SQLite.sql', 'DDL for 3.0 got created successfully');
	ok(-e 't/sql/DBICVersion-Schema-1.0-3.0-SQLite.sql', 'DDL for migration from 1.0 to 3.0 got created successfully');
	ok(-e 't/sql/DBICVersion-Schema-2.0-3.0-SQLite.sql', 'DDL for migration from 2.0 to 3.0 got created successfully');
}

done_testing;
