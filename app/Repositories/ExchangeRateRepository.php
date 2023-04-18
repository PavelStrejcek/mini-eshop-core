<?php

declare(strict_types=1);

namespace App\Repositories;

class ExchangeRateRepository extends AbstractRepository
{
    const TABLE = 'exchange_rate';

    public function getTableName(): string
    {
        return static::TABLE;
    }
}