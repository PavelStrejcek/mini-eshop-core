#!/usr/bin/env php
<?php

declare(strict_types=1);

use App\Commands\ExchangeRateImport;
use Nette\DI\Container;

/** @var Container $container */
$container = require __DIR__ . '/bootstrap.php';

/** @var ExchangeRateImport $exchangeRateImport */
$exchangeRateImport= $container->getByType(ExchangeRateImport::class);

$exchangeRateImport->execute();
