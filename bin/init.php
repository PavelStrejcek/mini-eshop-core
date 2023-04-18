#!/usr/bin/env php
<?php

use Nette\Database;
use Nette\DI\Container;
use Nette\Utils\FileSystem;

/** @var Container $container */
$container = require __DIR__ . '/bootstrap.php';

/** @var Database\Connection $db */
$db = $container->getByType(Database\Connection::class);

try {
    $db->query("SELECT 'product'::regclass");
} catch(\Throwable) {
    $productsNotExists = true;
}

if (empty($productsNotExists)) {
    die('bin/init.php: The database schema has already been created. Schema creation and data import skipped.' . PHP_EOL);
}

$initSql = FileSystem::read(__DIR__.'/../sql/init.sql');

$result = $db->getPdo()->exec($initSql);

if ($result !== 1) {
    die('bin/init.php: Schema and data creation FAILED!' . PHP_EOL);
}

die('bin/init.php: Success. DB schema created. Initial data imported.' . PHP_EOL);